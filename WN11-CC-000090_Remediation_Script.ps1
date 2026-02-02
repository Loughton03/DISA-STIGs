<#
.SYNOPSIS
    This PowerShell script ensures that the associated STIG-ID vulnerability is remediated.


.NOTES
    Author          : Loughton Bennett
    Date Created    : 02/01/2026
    Last Modified   : 02/01/2026
    Version         : 1.0
    STIG-ID         : WN11-CC-000090


.TESTED ON
    Date(s) Tested  : 10/29/2025
    Tested By       : Loughton Bennett
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1.26100.7705

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\stig_remediation_template(STIG-ID-).ps1

.Description: Enforces 'Process even if the Group Policy objects have not changed' by setting NoGPOListChanges to 0.
#>




$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"
$RegName = "NoGPOListChanges"
$RegValue = 0 # 0 = Process even if not changed (Secure), 1 = Skip if not changed

Try {
    # Check if the path exists, if not, create it
    If (!(Test-Path $RegPath)) {
        Write-Host "Registry path not found. Creating..." -ForegroundColor Yellow
        New-Item -Path $RegPath -Force | Out-Null
    }

    # Set the registry value
    New-ItemProperty -Path $RegPath -Name $RegName -Value $RegValue -PropertyType DWORD -Force | Out-Null

    Write-Host "Success: WN11-CC-000090 has been remediated." -ForegroundColor Green
    Write-Host "Value '$RegName' set to '$RegValue' at '$RegPath'" -ForegroundColor Gray

} Catch {
    Write-Error "Failed to remediate registry key. Error: $_"
}
