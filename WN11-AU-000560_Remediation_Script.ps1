.SYNOPSIS
    This PowerShell script ensures that the associated STIG-ID vulnerability is remediated.


.NOTES
    Author          : Loughton Bennett
    Date Created    : 02/01/2026
    Last Modified   : 02/01/2026
    Version         : 1.0
    STIG-ID         : WN11-AU-000560


.TESTED ON
    Date(s) Tested  : 10/29/2025
    Tested By       : Loughton Bennett
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1.26100.7705

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\stig_remediation_template(STIG-ID-).ps1

.Description: Enables 'Success' auditing for the 'Other Logon/Logoff Events' subcategory.


#>


# 1. Define the Subcategory GUID for "Other Logon/Logoff Events"
#    Using GUID is reliable across different language versions of Windows.
$SubCategoryGUID = "{0CCE921C-69AE-11D9-BED3-505054503030}"

Try {
    # 2. Check for Administrative Privileges
    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Throw "This script must be run as Administrator to change Audit Policies."
    }

    # 3. Apply the Audit Policy
    #    /success:enable -> Turns on Success auditing
    #    /failure:disable -> Explicitly disables Failure auditing (unless your policy requires both)
    Write-Host "Applying Audit Policy for Other Logon/Logoff Events..." -ForegroundColor Cyan
    
    $ProcessInfo = Start-Process -FilePath "auditpol.exe" -ArgumentList "/set /subcategory:$SubCategoryGUID /success:enable /failure:disable" -Wait -NoNewWindow -PassThru

    If ($ProcessInfo.ExitCode -eq 0) {
        Write-Host "Success: WN11-AU-000560 has been remediated." -ForegroundColor Green
    } Else {
        Write-Error "Auditpol failed with exit code $($ProcessInfo.ExitCode)."
    }

} Catch {
    Write-Error "Script Failed. Error: $_"
}
