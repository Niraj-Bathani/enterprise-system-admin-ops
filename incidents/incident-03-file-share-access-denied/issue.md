# Incident 03 File Share Access Denied - Issue Report

## Objective

---

This document records the initial issue report and triage process for a Finance file share access problem within the `lab.local` Windows Server 2022 environment.

The incident focuses on identifying the user impact, collecting initial evidence, and preparing the environment for structured diagnostics and remediation.

---

# Why It Matters

---

Accurate issue reporting improves troubleshooting efficiency and reduces repeated investigation steps.

A properly documented incident helps:

- Preserve troubleshooting evidence
- Reduce repeated user questioning
- Improve escalation quality
- Speed up root cause identification
- Support post-incident review

Clear initial triage also helps determine whether the issue is related to:

- Active Directory
- Group Policy
- DNS
- File permissions
- Authentication
- Workstation configuration

---

# Prerequisites

---

Before beginning triage, confirm:

- The affected user is available for validation
- Administrative tools are accessible
- The issue can be reproduced safely in the lab
- The incident ticket contains sufficient detail

Environment references:

| Component | Value |
|---|---|
| Domain | `lab.local` |
| DC01 | `192.168.100.10` |
| FS01 | `192.168.100.30` |
| CLIENT01 | `192.168.100.20` |

---

# GUI Procedure

---

1. Review the incident ticket and confirm:
   - Username
   - Computer name
   - Error message
   - Time of failure
   - Network location

2. Confirm whether the issue:
   - Occurs only on file shares
   - Follows the user to another workstation
   - Impacts additional users

3. On `CLIENT01`, verify the user is connected to the corporate network.

4. Attempt to reproduce the issue by accessing the Finance share.

5. Confirm the visible error message:

```text
Access is denied.
```

6. Review the user account in:
   - Active Directory Users and Computers
   - Group membership assignments
   - Account status

7. Collect initial evidence before remediation begins.

---

# PowerShell Procedure

---

## Validate Network Configuration

```powershell
ipconfig /all
```

---

## Validate User Group Membership

```powershell
whoami /groups
```

---

## Validate DNS Resolution

```powershell
Resolve-DnsName lab.local
```

---

## Review Applied Group Policies

```powershell
gpresult /r
```

---

# Verification

---

The initial investigation should confirm:

- The issue is reproducible
- The user is authenticated to the domain
- DNS resolution functions correctly
- The problem is isolated to file share access
- Evidence has been collected successfully

Validation checklist:

| Validation Item | Expected Result |
|---|---|
| Network Connectivity | Successful |
| DNS Resolution | Successful |
| Domain Authentication | Successful |
| File Share Access | Failing as reported |
| Evidence Collection | Completed |

---

# Common Issues And Fixes

---

| Issue | Cause | Resolution |
|---|---|---|
| Access denied on Finance share | Missing permissions | Validate group membership |
| User authentication issue | Account lockout | Unlock account |
| DNS lookup failure | Incorrect DNS server | Point client to `192.168.100.10` |
| GPO processing issue | Policy failure | Run `gpupdate /force` |

---

# Operational Quality Notes

---

This procedure is intended for the `lab.local` enterprise lab environment using Windows Server 2022 systems.

During incident triage:

- Record exact timestamps
- Preserve initial evidence
- Avoid immediate permission changes
- Confirm the issue before remediation

Evidence should include:

- Event Viewer logs
- PowerShell output
- ADUC screenshots
- Group Policy results
- File access error messages

Reference:

```text
../../ticketing-system/README.md
```

Do not close the incident until:

- Root cause is identified
- Standard-user validation succeeds
- Evidence is attached to the ticket
- Final remediation is verified

---

# Screenshot Capture

---

| Screenshot Requirement | Suggested Filename |
|---|---|
| Initial access denied investigation | `incident-03-file-share-access-denied-issue-report-verification.png` |

---

## Screenshot Reference

---


![Incident 03 File Share Access Denied Issue Report](../../screenshots/incident-03-file-share-access-denied-issue-report-verification.png)
