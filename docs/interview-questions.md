# Windows Sysadmin Interview Questions

## Overview

This section contains commonly asked Windows system administration interview questions with practical, experience-based answers. The focus is on real-world understanding rather than theoretical definitions.

---

## Questions and Answers

---

### 1. Explain FSMO roles and why they matter

**Answer:**

FSMO (Flexible Single Master Operations) roles are specialized Active Directory roles that prevent conflicts for certain operations.

- **Forest-wide:** Schema Master, Domain Naming Master  
- **Domain-wide:** RID Master, PDC Emulator, Infrastructure Master  

The **PDC Emulator** is critical because it handles:

- Password changes  
- Account lockouts  
- Time synchronization  

**Why it matters:**  
If FSMO roles fail, key AD functions break.

---

### 2. How do you force a GPO update on all domain computers?

**Answer:**

- Local:  
  ```cmd
  gpupdate /force
Remote:
Group Policy Management Console (GPMC)
PowerShell remoting

Validation:

gpresult /r
gpresult /h report.html
3. Find users inactive for 90 days (PowerShell)

Answer:

Get-ADUser -Filter * -Properties LastLogonDate |
Where-Object { $_.LastLogonDate -lt (Get-Date).AddDays(-90) }

Note:
In production, exclude service and privileged accounts.

4. Security group vs distribution group

Answer:

Security group: Used for permissions + can be mail-enabled
Distribution group: Email only, cannot assign permissions
5. How do you recover a deleted AD object?

Answer:

With Recycle Bin:

Restore-ADObject
Without it:
Authoritative restore from backup

Important: Validate dependencies (groups, permissions)

6. NTFS vs Share permissions

Answer:

Effective permission = most restrictive combination

Best practice:

Share = broad
NTFS = detailed control
7. What causes account lockouts?

Answer:

Cached credentials
Mapped drives
Services / scheduled tasks
Mobile devices

Check:

Event ID: 4740 (Domain Controller)
8. How do you troubleshoot DNS in AD?

Answer:

Verify client DNS settings

Test resolution:

Resolve-DnsName domain.local
Check port 53
Verify zone records
Confirm replication
9. What is SYSVOL?

Answer:

SYSVOL stores:

Group Policy templates
Logon scripts

It is replicated across domain controllers.

If broken:

GPOs may not apply
Logon scripts fail
10. How do you safely patch domain controllers?

Answer:

Patch one DC at a time
Verify replication before/after
Ensure backups exist

Lab:

Use snapshot

Production:

Use change window
11. What is Kerberos token bloat?

Answer:

Occurs when a user belongs to too many groups, increasing token size and causing authentication failures.

Fix:

Reduce group memberships
Improve role design
12. How do you map a drive with GPO?

Answer:

User Configuration → Preferences → Drive Maps
Link GPO to user OU

Validate:

gpresult /r
net use
13. How do you identify stale computers?

Answer:

Get-ADComputer -Filter * -Properties LastLogonDate

Compare with threshold.

Important:
Always verify with inventory before disabling.

14. Lab vs production change

Answer:

Lab: Test technical steps
Production:
Approval
Communication
Rollback plan
Monitoring
15. How do you handle a P1 outage?

Answer:

Assess impact
Start incident bridge
Assign roles
Restore service quickly
Communicate updates

Root cause analysis happens after recovery

Summary

These questions reflect real-world system administration scenarios. The answers emphasize practical experience, validation, and operational thinking rather than memorization.