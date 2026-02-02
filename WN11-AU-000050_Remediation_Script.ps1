.SYNOPSIS
    This PowerShell script ensures that the associated STIG-ID vulnerability is remediated.


.NOTES
    Author          : Loughton Bennett
    Date Created    : 02/01/2026
    Last Modified   : 02/01/2026
    Version         : 1.0
    STIG-ID         : WN11-AU-000050


.TESTED ON
    Date(s) Tested  : 10/29/2025
    Tested By       : Loughton Bennett
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1.26100.7705

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\stig_remediation_template(STIG-ID-).ps1

.Description: Enables 'Success' auditing for the 'Process Creation' subcategory.


#>

# 1. Define the Subcategory GUID for "Process Creation"
#    (Using GUID is safer than names for non-English Windows versions)
$SubCategoryGUID = "{0CCE922B-69AE-11D9-BED3-505054503030}"

Try {
    # 2. Check for Administrative Privileges
    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Throw "This script must be run as Administrator to change Audit Policies."
    }

    # 3. Apply the Audit Policy
    #    /success:enable -> Turns on Success auditing
    #    /failure:disable -> Ensures Failure auditing is off (unless you specifically need it, usually STIG asks for Success)
    Write-Host "Applying Audit Policy for Process Creation..." -ForegroundColor Cyan
    
    $ProcessInfo = Start-Process -FilePath "auditpol.exe" -ArgumentList "/set /subcategory:$SubCategoryGUID /success:enable /failure:disable" -Wait -NoNewWindow -PassThru

    If ($ProcessInfo.ExitCode -eq 0) {
        Write-Host "Success: WN11-AU-000050 has been remediated." -ForegroundColor Green
    } Else {
        Write-Error "Auditpol failed with exit code $($ProcessInfo.ExitCode)."
    }

} Catch {
    Write-Error "Script Failed. Error: $_"
}
