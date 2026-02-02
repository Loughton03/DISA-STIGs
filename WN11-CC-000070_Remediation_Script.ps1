.SYNOPSIS
    This PowerShell script ensures that the associated STIG-ID vulnerability is remediated.


.NOTES
    Author          : Loughton Bennett
    Date Created    : 02/01/2026
    Last Modified   : 02/01/2026
    Version         : 1.0
    STIG-ID         : WN11-CC-000070


.TESTED ON
    Date(s) Tested  : 10/29/2025
    Tested By       : Loughton Bennett
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1.26100.7705

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\stig_remediation_template(STIG-ID-).ps1

.Description: Enables VBS and sets Platform Security Level to secure Boot and DMA Protection.


#>
             

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"

Try {
    # 1. Create the Registry Path if it doesn't exist
    If (!(Test-Path $RegPath)) {
        Write-Host "Registry path not found. Creating..." -ForegroundColor Yellow
        New-Item -Path $RegPath -Force | Out-Null
    }

    # 2. Enable Virtualization Based Security
    # 1 = Enabled
    New-ItemProperty -Path $RegPath -Name "EnableVirtualizationBasedSecurity" -Value 1 -PropertyType DWORD -Force | Out-Null
    Write-Host "Set 'EnableVirtualizationBasedSecurity' to 1." -ForegroundColor Gray

    # 3. Configure Platform Security Level
    # 1 = Secure Boot
    # 3 = Secure Boot and DMA Protection (Recommended for Win11)
    New-ItemProperty -Path $RegPath -Name "RequirePlatformSecurityFeatures" -Value 3 -PropertyType DWORD -Force | Out-Null
    Write-Host "Set 'RequirePlatformSecurityFeatures' to 3 (Secure Boot & DMA)." -ForegroundColor Gray

    Write-Host "Success: WN11-CC-000070 configuration applied." -ForegroundColor Green
    Write-Host "NOTE: You must reboot for VBS to activate." -ForegroundColor Cyan

} Catch {
    Write-Error "Failed to apply VBS configuration. Error: $_"
}
