![image](https://i.imgur.com/)

# Defense Information Systems Agency - Security Technical Implementation Guides (DISA - STIGs)
STIG Remediation Template

## Windows 11 STIG Remediation Scripts:

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

## Platforms and Languages Leveraged:

-Windows 11 Virtual Machines (Microsoft Azure) </br>
-Tenable </br>
-Windows PowerShell

## Scenario
An internal audit revealed that multiple Windows 11 endpoints are failing Windows Compliance Checks against the DISA STIG baseline. I was tasked with remediating the identified STIG findings using automation (PowerShell) and then verifying—through both local validation and re-scanning—that the STIG requirements were successfully implemented.

## Discovery
To begin, I scanned the affected Windows 11 virtual machine with Tenable and reviewed the compliance failures associated with Windows Compliance Checks. For each failed item, I identified the STIG-ID associated with the requirement, then researched the official remediation guidance in the Tenable Audits database. Once the remediation steps were understood, I translated the guidance into a repeatable, scripted fix suitable for scaling across multiple systems.

## Steps Taken

1. Perform a vulnerability scan using Tenable using the Windows Compliance Checks.

I initiated a Tenable scan of the target Windows 11 VM using the appropriate compliance configuration and administrative credentials to ensure the results accurately reflected the system configuration. </br>
![image](https://i.imgur.com/)

2. Search the STIG-ID using Tenable Audits

After the scan completed, I located the compliance failure and identified the STIG-ID associated with it. I then searched for that STIG-ID within the Tenable Audits database:

* Tenable Audits: https://www.tenable.com/audits


3. Research the solution

Within the Tenable Audit entry for the identified STIG-ID, I reviewed the remediation section and captured the exact steps required to bring the system into compliance. This typically included specific policy requirements and, in many cases, registry changes such as creating a missing key and enforcing the correct value (often a DWORD).
</br>
![image](https://i.imgur.com/)


4. Researched the solution.
After searching for the specified STIG-ID within the Tenable Audit database, the solution to remediate the vulnerbility was given in steps.

Example solution:
![image](https://i.imgur.com/)

4. Use the STIG Remediation Template to write a PowerShell solution

To ensure consistency and safe execution, I used a structured remediation template to develop a PowerShell script aligned to the specific STIG requirement:

* STIG Remediation Template: https://github.com/behan101/DISA-STIGs/blob/main/stig_remediation_template

The script was written to be clear, auditable, and reusable—focusing on:

* Validating whether the required registry path/value already exists.
* Creating missing keys when necessary.
* Enforce the required value type (e.g., DWORD) and correct data.
* Logging output so execution results can be reviewed.
 </br>

![image](https://i.imgur.com/)

5. Test and execute the script in PowerShell ISE

Using PowerShell ISE, I incrementally tested the logic to ensure it performed the intended change without unintended side effects. Once confirmed, I executed the script on the target system and captured execution output for documentation.
 </br>

![image](https://i.imgur.com/)

6. Remediation validation after script execution

After execution, I validated the change in two ways:

Local validation (Windows configuration check):
I located the corresponding policy/setting on the Windows 11 machine and confirmed the value matched the expected STIG configuration. Where applicable, this included checking the registry:

* Verifying the HKEY_LOCAL_MACHINE registry path exists.
* Confirming the presence of the expected value.
* Ensuring the value type is correct (e.g., DWORD).
* Confirming the configured data matches the STIG requirement.

Operational validation (Tenable re-scan):
After verifying locally, I restarted the machine to ensure the configuration was fully applied and persisted, then ran a follow-up Tenable scan using the same compliance audit settings. Once the STIG-ID no longer appeared as a compliance failure, I confirmed that the vulnerability had been remediated.


![image](https://i.imgur.com/)

Checking the HKEY_LOCAL_MACHINE path for creation and correct value of the DWORD. </br>

![image](https://i.imgur.com/)

After validating, I restart the machine before scanning with Tenable for another audit to ensure the changes are saved and implemented.

Scan Results: </br>

![image](https://i.imgur.com/)

## Summary
The failed STIG compliance item was identified through Tenable Windows Compliance Checks during a scan of the Windows 11 VM on the internal scanning infrastructure. The scan was executed from Local-Scan-Engine-01, targeting the VM’s private IP address, using administrative credentials to enable a complete compliance evaluation. The compliance audit selected was aligned to the operating system baseline (DISA Microsoft Windows 11 STIG v2r4). To reduce scan time and resource usage, all plugins were disabled except Windows Compliance Checks (Plugin ID: 24760).

Once the scan results identified the failing STIG-ID, I researched the remediation guidance within the Tenable Audits database and implemented the fix using a PowerShell script built from the STIG remediation template. After execution, I validated the remediation locally by confirming the policy/registry configuration (including verifying the correct HKEY_LOCAL_MACHINE path and DWORD value when applicable). Following a system restart, I re-scanned the endpoint in Tenable using the same parameters and confirmed the STIG compliance check associated with the STIG-ID passed successfully.


## Response Taken
After remediation and validation were complete, I notified the InfoSec / SecOps team and provided the supporting documentation and PowerShell remediation scripts for peer review and broader deployment across the remaining affected Windows 11 systems.

