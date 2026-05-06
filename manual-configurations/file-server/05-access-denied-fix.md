# Access Denied Fix

## Objective

Troubleshoot and resolve file share access denied issues in the `lab.local` environment.

---

# Why It Matters

File share permission issues are one of the most common enterprise support incidents.

This lab environment uses:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| FS01 | File Server | 192.168.100.40 |
| CLIENT01 | Windows Client | 192.168.100.20 |

Domain:

```text
lab.local
```

Shared folder:

```text
\\FS01\Sales
```

---

# Prerequisites

Before starting:

- Shared folder exists
- SMB share operational
- Domain user account available
- DNS functioning correctly
- PowerShell running as Administrator

Verify connectivity:

```powershell
Test-NetConnection FS01 -Port 445
```

Verify DNS:

```powershell
Resolve-DnsName FS01
```

---

# GUI Procedure

## Verify User Access

1. Sign in to `CLIENT01` as a standard domain user.

2. Open:

```text
\\FS01\Sales
```

3. Confirm the access denied error appears.

---

## Check Share Permissions

On `FS01`:

1. Right-click the shared folder.
2. Open:

```text
Properties
→ Sharing
→ Advanced Sharing
→ Permissions
```

3. Verify the required group or users have access.

---

## Check NTFS Permissions

1. Open:

```text
Properties
→ Security
```

2. Confirm the required user or group has:
- Read
- Modify
- Write

permissions as needed.

---

## Verify Effective Access

1. Open:

```text
Advanced Security Settings
→ Effective Access
```

2. Select the affected user.
3. Review resulting permissions.

---

## Refresh User Session

After permission changes:

```text
Sign out
→ Sign in again
```

This refreshes the Kerberos security token.

---

# PowerShell Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\access-denied-fix.txt -Append
```

Verify user group membership:

```powershell
Get-ADPrincipalGroupMembership jsmith | Select-Object Name
```

Verify SMB share permissions:

```powershell
Get-SmbShareAccess -Name Sales
```

Verify NTFS permissions:

```powershell
icacls 'D:\Shares\Sales'
```

Verify current user token:

```powershell
whoami /groups
```

Stop logging:

```powershell
Stop-Transcript
```

---

# Verification

## Verify Share Access

Run:

```powershell
Test-Path '\\FS01\Sales'
```

Expected result:

```text
True
```

---

## Verify File Creation

Run:

```powershell
New-Item '\\FS01\Sales\access-test.txt' -ItemType File
```

Expected result:

```text
File created successfully
```

---

## Verify User Access

Open:

```text
\\FS01\Sales
```

Confirm:
- folder opens successfully
- files are visible
- file creation works

---

# Common Issues And Fixes

## User Missing Required Group

Add the user to the required security group:

```powershell
Add-ADGroupMember -Identity GG_Sales_Share_Modify -Members jsmith
```

Sign the user out and back in afterward.

---

## Share Permission Allows Access But NTFS Blocks It

Verify both:
- Share permissions
- NTFS permissions

Effective permissions use the most restrictive result.

---

## Kerberos Token Not Updated

After group membership changes:

```text
Log off
→ Log back in
```

or reboot the client.

---

## DNS Or Connectivity Failure

Verify:

```powershell
Resolve-DnsName FS01
```

Verify SMB connectivity:

```powershell
Test-NetConnection FS01 -Port 445
```

---

# Screenshot Capture

![Access denied fix](/screenshots/access-denied-fix.png)
