.SYNOPSIS
    This PowerShell script ensures that the associated STIG-ID vulnerability is remediated.


.NOTES
    Author          : Loughton Bennett
    Date Created    : 02/01/2026
    Last Modified   : 02/01/2026
    Version         : 1.0
    STIG-ID         :WN11-AC-000010


.TESTED ON
    Date(s) Tested  : 10/29/2025
    Tested By       : Loughton Bennett
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1.26100.7705

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\stig_remediation_template(STIG-ID-).ps1

.Description: Sets the local account lockout threshold to 3 attempts. This applies to local accounts (SAM), not Domain accounts.


#>

Try {
    # 1. Check for Administrative Privileges
    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Throw "This script must be run as Administrator."
    }

    # 2. Configure the Lockout Threshold
    #    /lockoutthreshold:X -> Sets the number of failed attempts before lockout.
    #    STIG requires 3 or fewer.
    Write-Host "Setting Account Lockout Threshold to 3..." -ForegroundColor Cyan
    
    $Result = cmd.exe /c "net accounts /lockoutthreshold:3"

    # 3. Check result (net accounts doesn't throw PS errors, check output/exit code)
    If ($LASTEXITCODE -eq 0) {
        Write-Host "Success: WN11-AC-000010 has been remediated." -ForegroundColor Green
        Write-Host "Local accounts will lock out after 3 failed attempts." -ForegroundColor Gray
    } Else {
        Write-Error "Failed to set lockout threshold. Output: $Result"
    }

} Catch {
    Write-Error "Script Failed. Error: $_"
}




