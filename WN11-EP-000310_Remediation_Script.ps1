.SYNOPSIS
    This PowerShell script ensures that the associated STIG-ID vulnerability is remediated.


.NOTES
    Author          : Loughton Bennett
    Date Created    : 02/01/2026
    Last Modified   : 02/01/2026
    Version         : 1.0
    STIG-ID         : WN11-EP-000310


.TESTED ON
    Date(s) Tested  : 10/29/2025
    Tested By       : Loughton Bennett
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1.26100.7705

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\stig_remediation_template(STIG-ID-).ps1

.Description: Configures the "Enumeration policy for external devices incompatible with Kernel DMA Protection" to "Block All".


#>


$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Kernel DMA Protection"
$RegName = "DeviceEnumerationPolicy"
$RegValue = 0 # 0 = Block All (Secure), 1 = Allow after login (Default), 2 = Allow All

Try {
    # 1. Check if the path exists, if not, create it
    If (!(Test-Path $RegPath)) {
        Write-Host "Registry path not found. Creating..." -ForegroundColor Yellow
        New-Item -Path $RegPath -Force | Out-Null
    }

    # 2. Set the registry value to '0' (Block All)
    New-ItemProperty -Path $RegPath -Name $RegName -Value $RegValue -PropertyType DWORD -Force | Out-Null

    Write-Host "Success: WN11-EP-000310 has been remediated (Set to 'Block All')." -ForegroundColor Green
    Write-Host "Value '$RegName' set to '$RegValue' at '$RegPath'" -ForegroundColor Gray

} Catch {
    Write-Error "Failed to remediate registry key. Error: $_"
}
