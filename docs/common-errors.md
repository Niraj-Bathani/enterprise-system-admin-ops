# Common Errors

## Overview

This section provides quick troubleshooting references for common system administration issues. It focuses on identifying root causes and applying structured diagnostics rather than guessing fixes.

---

## What This Demonstrates

- Practical troubleshooting skills  
- Root cause analysis  
- Use of diagnostic tools and commands  
- Structured problem-solving approach  

---

## Troubleshooting Approach

When diagnosing issues, follow this order:

1. Identity (user/account state)  
2. Network connectivity  
3. DNS resolution  
4. Permissions and access  
5. Service status  

Avoid changing multiple things at once.

---

## Common Issues

---

### Account Locked Out

**Cause:**  
Repeated failed login attempts trigger lockout policy.

**Check:**

```powershell
Search-ADAccount -LockedOut

Event log (Domain Controller):

Event ID: 4740

Fix:

Unlock account
Clear saved credentials on client device
Network Path Not Found

Cause:
DNS, SMB, firewall, or server not reachable.

Check:

Resolve-DnsName FS01
Test-NetConnection FS01 -Port 445

On server:

Get-SmbShare

Fix:

Resolve DNS issues
Ensure SMB service is running
Check firewall rules
Access Is Denied

Cause:
Authentication works, but permissions are insufficient.

Check:

whoami /groups
Get-SmbShareAccess
icacls C:\Path

Fix:

Adjust NTFS or share permissions
Ensure correct group membership
Ask user to log out/in after changes
Group Policy Not Applying

Cause:
Incorrect OU, filtering, or replication issues.

Check:

gpupdate /force
gpresult /r
gpresult /h report.html

Fix:

Verify OU link
Check security filtering
Confirm SYSVOL and replication
Validate DNS
DNS Name Does Not Exist

Cause:
Missing or incorrect DNS record.

Check:

Resolve-DnsName name -Server 192.168.100.10
ipconfig /flushdns

Fix:

Create or correct DNS record
Verify zone
Check replication if AD-integrated
Expected Outcome
Issues are diagnosed using structured steps
Root cause is identified before changes
Fixes are applied based on evidence, not guesswork
Summary

This section demonstrates practical troubleshooting skills used in real environments. It emphasizes structured diagnostics, correct tool usage, and disciplined problem-solving.