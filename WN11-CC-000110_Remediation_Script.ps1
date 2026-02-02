.SYNOPSIS
    This PowerShell script ensures that the associated STIG-ID vulnerability is remediated.


.NOTES
    Author          : Loughton Bennett
    Date Created    : 02/01/2026
    Last Modified   : 02/01/2026
    Version         : 1.0
    STIG-ID         : WN11-CC-000110


.TESTED ON
    Date(s) Tested  : 10/29/2025
    Tested By       : Loughton Bennett
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1.26100.7705

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\stig_remediation_template(STIG-ID-).ps1

.Description: Sets 'DisableHTTPPrinting' to 1 to prevent printing via HTTP.

#>


$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$RegName = "DisableHTTPPrinting"
$RegValue = 1 # 1 = Enabled (Turn OFF HTTP Printing), 0 = Disabled (Allow HTTP Printing)

Try {
    # 1. Check if the path exists, if not, create it
    # Note: 'Windows NT\Printers' path often doesn't exist by default in Policies
    If (!(Test-Path $RegPath)) {
        Write-Host "Registry path not found. Creating..." -ForegroundColor Yellow
        New-Item -Path $RegPath -Force | Out-Null
    }

    # 2. Set the registry value to '1'
    New-ItemProperty -Path $RegPath -Name $RegName -Value $RegValue -PropertyType DWORD -Force | Out-Null

    Write-Host "Success: WN11-CC-000110 has been remediated." -ForegroundColor Green
    Write-Host "Value '$RegName' set to '$RegValue' (Enabled) at '$RegPath'" -ForegroundColor Gray

} Catch {
    Write-Error "Failed to remediate registry key. Error: $_"
}
