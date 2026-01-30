# DISA-STIG

Defense Information Systems Agency - Security Technical Implementation Guides (DISA - STIGs)
STIG Remediation Template

Windows 11 STIG Remediation Scripts:

WN11-AU-000050

WN11-CC-000005

WN11-CC-000090

WN11-CC-000315

WN11-EP-000310

WN11-CC-000197

WN11-SO-000220

WN11-SO-000230

WN11-UR-000070

WN11-CC-000285

Platforms and Languages Leveraged
Windows 11 Virtual Machines (Microsoft Azure)
Tenable
Windows PowerShell
Scenario
An internal audit has revealed that various Windows 11 machines have numerous failures in regards to Windows Compliance Checks. I have been tasked to remediate these vulnerabilities using automation and confirm that the STIG has been successfully implemented.

Discovery
Scan the virtual machine associated with the Windows Compliance Check failures using tenable.
Select Audits and discover the STIG-ID associated with the failure.
Research remediation for the STIG-ID.
Steps Taken
1. Perform a vulnerability scan using Tenable using the Windows Compliance Checks.
image
2. Searched the STIG-ID using Tenable Audits.
Searched for STIG-ID within the Tenable Audits database (https://www.tenable.com/audits).

image
3. Researched the solution.
After searching for the specified STIG-ID within the Tenable Audit database, the solution to remediate the vulnerbility was given in steps.

Example solution:

image
4. Used the Stig Remediation Template to write a PowerShell script solution.
Stig Remediation Template used: https://github.com/behan101/DISA-STIGs/blob/main/stig_remediation_template

image
5. Using PowerShell ISE, I began the process of testing and executing the script.
Running the script:

image
6. Remediation Validation post PowerShell Script execution.
Remediation Validation:

After executing the script, I validate the changes by finding the policy on the Windows machine and checking the values. I then scanned the machine using Tenable again and checked the results with the STIG-ID remediated in the script. When the scan results did not have the STIG-ID as a failure for compliance, I confirmed that the vulnerability has been remediated.

image
Checking the HKEY_LOCAL_MACHINE path for creation and correct value of the DWORD.

image
After validating, I restart the machine before scanning with Tenable for another audit to ensure the changes are saved and implemented.

Scan Results:

image
Summary
The vulnerability with the associated STIG-ID has been identified using Tenable. The scan was configured internally on the Local-Scan-Engine-01 with the target specified as the private IP address of the virtual machine. Administrative credentials were given so that the scan would be thorough. The compliance audit used in the scan was configured to the appropriate operating system and version (DISA Microsoft Windows 11 STIG v2r4). All plugins were disabled with the exception of the Windows Compliance Checks (Plugin ID: 24760) in order to expedite the scanning process and reduce resource consumption. The identified STIG-ID compliance failure was then remediated using PowerShell scripting and the STIG Remediation Template . After the script executed, the remediation validation process began with looking up the policy configuration in the Registry Editor of the machine. The machine was then restarted before another scan was conducted using the same parameters in Tenable. The results were confirmed to have passed the compiance check associated with the STIG-ID.

Response Taken
The InfoSec / SecOps department was then notified and sent the documentation and scripts for review and deployment.

