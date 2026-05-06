# NTFS Versus Share Permissions

## Objective

Understand and validate how NTFS permissions and SMB share permissions combine to control file access.

---

# Why It Matters

Access to shared folders is controlled by both:
- Share permissions
- NTFS permissions

The effective permission is always the most restrictive combination of both permission sets.

This lab environment uses:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| FS01 | File Server | 192.168.100.40 |
| CLIENT01 | Windows Client | 192.168.100.20 |

Shared folder:

```text
D:\Shares\Sales
```

SMB Share:

```text
\\FS01\Sales
```

Domain:

```text
lab.local
```

---

# Prerequisites

Before starting:

- Shared folder created
- SMB share configured
- NTFS permissions configured
- PowerShell running as Administrator

Verify SMB share:

```powershell
Get-SmbShare -Name Sales
```

Verify connectivity:

```powershell
Test-NetConnection FS01 -Port 445
```

---

# GUI Procedure

## Review Share Permissions

1. Right-click:

```text
D:\Shares\Sales
→ Properties
→ Sharing
→ Advanced Sharing
→ Permissions
```

2. Review:
- allowed groups
- permission levels
- share access configuration

---

## Review NTFS Permissions

1. Open:

```text
Properties
→ Security
```

2. Review:
- assigned users and groups
- permission levels
- inheritance settings

---

## Review Effective Access

1. Open:

```text
Security
→ Advanced
→ Effective Access
```

2. Select a test user such as:

```text
lab\jsmith
```

3. Verify:
- read access
- write access
- modify access

---

# PowerShell Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\ntfs-versus-share-permissions.txt -Append
```

Review SMB share permissions:

```powershell
Get-SmbShareAccess -Name Sales
```

Review NTFS ACL:

```powershell
(Get-Acl "D:\Shares\Sales").Access
```

Review full NTFS permissions:

```powershell
icacls "D:\Shares\Sales"
```

Stop logging:

```powershell
Stop-Transcript
```

---

# Verification

## Verify Share Permissions

Run:

```powershell
Get-SmbShareAccess -Name Sales
```

Confirm:
- expected groups exist
- correct access level assigned

---

## Verify NTFS Permissions

Run:

```powershell
icacls "D:\Shares\Sales"
```

Confirm:
- `GG_Sales_Users`
- Modify permission assigned

---

## Verify User Group Membership

On `CLIENT01`, run:

```powershell
whoami /groups
```

Confirm the user belongs to the required security group.

---

## Verify User Access

On `CLIENT01`, run:

```powershell
Test-Path "\\FS01\Sales"
```

Create a test file inside the share to confirm write access.

---

# Common Issues And Fixes

## Share Allows Access But NTFS Denies Access

Grant NTFS permissions to the appropriate security group:

```powershell
icacls "D:\Shares\Sales" /grant "lab\GG_Sales_Users:(M)"
```

---

## Access Denied Due To Group Membership

Refresh the user logon session:
- sign out
- sign back in

Verify group membership:

```powershell
whoami /groups
```

---

## Inherited Permissions Causing Problems

Review inheritance:

```text
Properties
→ Security
→ Advanced
```

Check inherited entries and permission order.

---

## SMB Share Not Reachable

Verify SMB connectivity:

```powershell
Test-NetConnection FS01 -Port 445
```

Verify DNS resolution:

```powershell
Resolve-DnsName FS01
```

---

# Screenshot Capture

![NTFS share comparison](/screenshots/ntfs-share-comparison.png)
