.SYNOPSIS
    This PowerShell script ensures that the associated STIG-ID vulnerability is remediated.


.NOTES
    Author          : Loughton Bennett
    Date Created    : 02/01/2026
    Last Modified   : 02/01/2026
    Version         : 1.0
    STIG-ID         : WN11-CC-000255


.TESTED ON
    Date(s) Tested  : 10/29/2025
    Tested By       : Loughton Bennett
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1.26100.7705

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\stig_remediation_template(STIG-ID-).ps1

.Description: Configures 'SeDenyNetworkLogonRight' to include:
#              - Guests (All Systems)
#              - Local account (Domain Systems)
#              - Domain Admins (Domain Systems)
#              - Enterprise Admins (Domain Systems)


#>


# Define the User Right constant
$Privilege = "SeDenyNetworkLogonRight"

# --- Helper Type for LSA Policy Manipulation ---
$LsaType = @"
using System;
using System.Runtime.InteropServices;

public class LsaWrapper {
    [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
    public static extern uint LsaOpenPolicy(ref LSA_UNICODE_STRING SystemName, ref LSA_OBJECT_ATTRIBUTES ObjectAttributes, uint DesiredAccess, out IntPtr PolicyHandle);

    [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
    public static extern uint LsaAddAccountRights(IntPtr PolicyHandle, byte[] AccountSid, LSA_UNICODE_STRING[] UserRights, uint CountOfRights);

    [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
    public static extern uint LsaClose(IntPtr ObjectHandle);

    [StructLayout(LayoutKind.Sequential)]
    public struct LSA_UNICODE_STRING {
        public UInt16 Length;
        public UInt16 MaximumLength;
        public IntPtr Buffer;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct LSA_OBJECT_ATTRIBUTES {
        public UInt32 Length;
        public IntPtr RootDirectory;
        public IntPtr ObjectName;
        public UInt32 Attributes;
        public IntPtr SecurityDescriptor;
        public IntPtr SecurityQualityOfService;
    }
}
"@
Add-Type -TypeDefinition $LsaType

# --- Function to Add Right ---
function Add-UserRight {
    param([System.Security.Principal.SecurityIdentifier]$Sid, [string]$Right)
    
    $PolicyHandle = [IntPtr]::Zero
    $Attributes = New-Object LsaWrapper+LSA_OBJECT_ATTRIBUTES
    $Attributes.Length = [Marshal]::SizeOf($Attributes)
    
    # Open Policy (POLICY_LOOKUP_NAMES | POLICY_CREATE_ACCOUNT)
    $Result = [LsaWrapper]::LsaOpenPolicy([ref]$null, [ref]$Attributes, 0x0818, [ref]$PolicyHandle)
    
    if ($Result -ne 0) { Write-Error "Failed to open LSA Policy. Error Code: $Result"; return }

    # Setup Right String
    $RightString = New-Object LsaWrapper+LSA_UNICODE_STRING
    $RightString.Buffer = [Marshal]::StringToHGlobalUni($Right)
    $RightString.Length = $Right.Length * 2
    $RightString.MaximumLength = ($Right.Length * 2) + 2
    
    # Get SID Bytes
    $SidBytes = New-Object byte[] $Sid.BinaryLength
    $Sid.GetBinaryForm($SidBytes, 0)

    # Add Right
    $Result = [LsaWrapper]::LsaAddAccountRights($PolicyHandle, $SidBytes, [array]$RightString, 1)
    [LsaWrapper]::LsaClose($PolicyHandle) | Out-Null
    [Marshal]::FreeHGlobal($RightString.Buffer)

    if ($Result -eq 0) {
        Write-Host "Success: Added '$($Sid.Translate([System.Security.Principal.NTAccount]))' ($Sid) to $Right" -ForegroundColor Green
    } else {
        Write-Host "Info: Account might already have the right or failed. Result: $Result" -ForegroundColor Yellow
    }
}

# --- Main Execution ---

Write-Host "Starting Remediation for WN11-UR-000070..." -ForegroundColor Cyan

# 1. Universal: Guests (S-1-5-32-546)
$GuestsSID = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-546")
Add-UserRight -Sid $GuestsSID -Right $Privilege

# 2. Check Domain Status
$IsDomainJoined = (Get-CimInstance -ClassName Win32_ComputerSystem).PartOfDomain

if ($IsDomainJoined) {
    Write-Host "Domain Joined detected. Applying Domain restrictions..." -ForegroundColor Cyan
    
    # A. Local account (S-1-5-113) - Critical for Anti-Lateral Movement
    $LocalAccountSID = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-113")
    Add-UserRight -Sid $LocalAccountSID -Right $Privilege

    try {
        # B. Domain Admins (Current Domain + "-512")
        $Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
        $DomainSid = (New-Object System.Security.Principal.NTAccount($Domain.Name)).Translate([System.Security.Principal.SecurityIdentifier]).Value
        $DomainAdminsSID = New-Object System.Security.Principal.SecurityIdentifier("$DomainSid-512")
        Add-UserRight -Sid $DomainAdminsSID -Right $Privilege

        # C. Enterprise Admins (Root Domain + "-519")
        $RootDomain = $Domain.Forest.RootDomain
        $RootSid = (New-Object System.Security.Principal.NTAccount($RootDomain.Name)).Translate([System.Security.Principal.SecurityIdentifier]).Value
        $EntAdminsSID = New-Object System.Security.Principal.SecurityIdentifier("$RootSid-519")
        Add-UserRight -Sid $EntAdminsSID -Right $Privilege

    } catch {
        Write-Error "Could not resolve Domain SIDs. Ensure you are connected to the network. Error: $_"
    }
} else {
    Write-Host "Machine is not Domain Joined. Skipping Domain/Enterprise Admin blocks." -ForegroundColor Gray
}

Write-Host "Remediation Complete." -ForegroundColor Cyan
