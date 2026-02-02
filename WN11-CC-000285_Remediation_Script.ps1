.SYNOPSIS
    This PowerShell script ensures that the associated STIG-ID vulnerability is remediated.


.NOTES
    Author          : Loughton Bennett
    Date Created    : 02/01/2026
    Last Modified   : 02/01/2026
    Version         : 1.0
    STIG-ID         : WN11-CC-000285


.TESTED ON
    Date(s) Tested  : 10/29/2025
    Tested By       : Loughton Bennett
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1.26100.7705

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\stig_remediation_template(STIG-ID-).ps1

.Description: Sets 'fEncryptRPCTraffic' to 1 to enforce secure RPC for RDP.

#>

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$RegName = "fEncryptRPCTraffic"
$RegValue = 1 # 1 = Enabled (Require Secure RPC), 0 = Disabled

Try {
    # 1. Check if the path exists, if not, create it
    If (!(Test-Path $RegPath)) {
        Write-Host "Registry path not found. Creating..." -ForegroundColor Yellow
        New-Item -Path $RegPath -Force | Out-Null
    }

    # 2. Set the registry value to '1'
    New-ItemProperty -Path $RegPath -Name $RegName -Value $RegValue -PropertyType DWORD -Force | Out-Null

    Write-Host "Success: WN11-CC-000285 has been remediated." -ForegroundColor Green
    Write-Host "Value '$RegName' set to '$RegValue' at '$RegPath'" -ForegroundColor Gray

    # 3. Optional: Restart the service to ensure immediate application
    Write-Host "Note: A restart of the Remote Desktop Services (TermService) or a reboot is recommended." -ForegroundColor Cyan

} Catch {
    Write-Error "Failed to remediate registry key. Error: $_"
}



