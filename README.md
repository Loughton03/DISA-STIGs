<img width="938" height="520" alt="image" src="https://github.com/user-attachments/assets/301a546e-48ef-4247-a35d-c6da01ed5d5f" />



# Defense Information Systems Agency - Security Technical Implementation Guides (DISA - STIGs)
- **[STIG Remediation Template](https://github.com/Loughton03/DISA-STIGs/blob/main/Disa_Stig_Remediation_Template.ps1)**

## Windows 11 STIG Remediation Scripts:

- **[WN11-CC-000090 - Group Policy objects must be reprocessed even if they have not changed.](https://github.com/Loughton03/DISA-STIGs/blob/main/WN11-CC-000090_Remediation_Script.ps1)**

- **[WN11-AU-000050 - The system must be configured to audit Detailed Tracking - Process Creation success.](https://github.com/Loughton03/DISA-STIGs/blob/main/WN11-AU-000050_Remediation_Script.ps1)**
  
- **[WN11-EP-000310 - Windows 11 Kernel (Direct Memory Access) DMA Protection must be enabled.](https://github.com/Loughton03/DISA-STIGs/blob/main/WN11-EP-000310_Remediation_Script.ps1)**
 
- **[WN11-CC-000110 - Printing over HTTP must be prevented.](https://github.com/Loughton03/DISA-STIGs/blob/main/WN11-CC-000110_Remediation_Script.ps1)**
 
- **[WN11-CC-000197 - Microsoft consumer experiences must be turned off.](https://github.com/Loughton03/DISA-STIGs/blob/main/WN11-CC-000197_Remediation_Script.ps1)**
  
- **[WN11-CC-000285 - The Remote Desktop Session Host must require secure RPC communications.](https://github.com/Loughton03/DISA-STIGs/blob/main/WN11-CC-000285_Remediation_Script.ps1)**
  
- **[WN11-CC-000070 - Virtualization-based Security must be enabled on Windows 11 with the platform security level configured to Secure Boot or Secure Boot with DMA Protection.](https://github.com/Loughton03/DISA-STIGs/blob/main/WN11-CC-000070_Remediation_Script.ps1)**
  
- **[WN11-AU-000560 - Windows 11 must be configured to audit other Logon/Logoff Events Successes.](https://github.com/Loughton03/DISA-STIGs/blob/main/WN11-AU-000560_Remediation_Script.ps1)**
  
- **[WN11-CC-000255 - The use of a hardware security device with Windows Hello for Business must be enabled.](https://github.com/Loughton03/DISA-STIGs/blob/main/WN11-CC-000255_Remediation_Script.ps1)**

- **[WN11-AC-000010 - The number of allowed bad logon attempts must be configured to three or less.]()**

## Platforms and Languages Leveraged:

-Windows 11 Virtual Machines (Microsoft Azure) </br>
-Tenable </br>
-Windows PowerShell

## Scenario
An internal audit revealed that multiple Windows 11 endpoints are failing Windows Compliance Checks against the DISA STIG baseline. I was tasked with remediating the identified STIG findings using automation (PowerShell) and then verifying—through both local validation and re-scanning—that the STIG requirements were successfully implemented.

## Discovery
To begin, I scanned the affected Windows 11 virtual machine with Tenable and reviewed the compliance failures associated with Windows Compliance Checks. For each failed item, I identified the STIG-ID associated with the requirement, then researched the official remediation guidance in the Tenable Audits database. Once the remediation steps were understood, I translated the guidance into a repeatable, scripted fix suitable for scaling across multiple systems.

## Steps Taken

#### 1. Perform a vulnerability scan using Tenable using the Windows Compliance Checks.

I initiated a Tenable scan of the target Windows 11 VM using the appropriate compliance configuration and administrative credentials to ensure the results accurately reflected the system configuration. </br>

<img width="1380" height="1001" alt="image" src="https://github.com/user-attachments/assets/0ca2d916-4a0f-4114-bed5-705859bb18b7" />

---

#### 2. Search the STIG-ID using Tenable Audits

After the scan completed, I located the compliance failure and identified the STIG-ID associated with it. I then searched for that STIG-ID within the Tenable Audits database: Tenable Audits: https://www.tenable.com/audits

<img width="1880" height="1070" alt="image" src="https://github.com/user-attachments/assets/4a209ada-d3f7-4ad3-90d9-801b6de47358" />

---

#### 3. Research the solution

Within the Tenable Audit entry for the identified STIG-ID, I reviewed the remediation section and captured the exact steps required to bring the system into compliance. This typically included specific policy requirements and, in many cases, registry changes such as creating a missing key and enforcing the correct value (often a DWORD).
</br>

<img width="1881" height="992" alt="image" src="https://github.com/user-attachments/assets/ae3090af-502a-485f-a666-f6dc14bbf154" />

---

#### 4. Use the STIG Remediation Template to write a PowerShell solution

To ensure consistency and safe execution, I used a structured remediation template to develop a PowerShell script aligned to the specific STIG requirement:

<img width="1378" height="616" alt="image" src="https://github.com/user-attachments/assets/edcb8df7-274b-40c4-b7a4-f4d991f21900" />

The script was written to be clear, auditable, and reusable—focusing on:

* Validating whether the required registry path/value already exists.
* Creating missing keys when necessary.
* Logging output so execution results can be reviewed.
 </br>

---

#### 5. Test and execute the script in PowerShell ISE

Using PowerShell ISE, I incrementally tested the logic to ensure it performed the intended change without unintended side effects. Once confirmed, I executed the script on the target system and captured execution output for documentation.
 </br>

<img width="1881" height="1081" alt="image" src="https://github.com/user-attachments/assets/96debe85-5e67-4ddd-817f-0beb56b940c4" />

---

#### 6. Remediation validation after script execution

After execution, I validated the change in two ways:

Local validation (Windows configuration check):
- I located the corresponding policy/setting on the Windows 11 machine and confirmed the value matched the expected STIG configuration. Where applicable, this included checking the registry:

* Confirming the presence of the expected value.
* Confirming the configured data matches the STIG requirement.

<img width="1875" height="305" alt="image" src="https://github.com/user-attachments/assets/593e40c4-416d-4a41-9c98-feebd10b4008" />


Operational validation (Tenable re-scan):
After verifying locally, I restarted the machine to ensure the configuration was fully applied and persisted, then ran a follow-up Tenable scan using the same compliance audit settings. Once the STIG-ID no longer appeared as a compliance failure, I confirmed that the vulnerability had been remediated.

Scan Results: </br>

<img width="1437" height="1096" alt="image" src="https://github.com/user-attachments/assets/9cb33e92-8cc1-41c9-8fd3-c4815d5cdce4" />


## Summary
The failed STIG compliance item was identified through Tenable Windows Compliance Checks during a scan of the Windows 11 VM on the internal scanning infrastructure. The scan was executed from Local-Scan-Engine-01, targeting the VM’s private IP address, using administrative credentials to enable a complete compliance evaluation. The compliance audit selected was aligned to the operating system baseline (DISA Microsoft Windows 11 STIG v2r4). 

Once the scan results identified the failing STIG-ID, I researched the remediation guidance within the Tenable Audits database and implemented the fix using a PowerShell script built from the STIG remediation template. After execution, I validated the remediation locally by confirming the policy/registry configuration. Following a system restart, I re-scanned the endpoint in Tenable using the same parameters and confirmed the STIG compliance check associated with the STIG-ID passed successfully.


## Response Taken
After remediation and validation were complete, I notified the InfoSec / SecOps team and provided the supporting documentation and PowerShell remediation scripts for peer review and broader deployment across the remaining affected Windows 11 systems.

