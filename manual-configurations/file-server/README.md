# File Server Manual Configuration

## Purpose

This section covers practical Windows file server administration tasks using shared folders, NTFS permissions, department-based access control, mapped drives, and access troubleshooting.

The lab environment uses:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| FS01 | File Server | 192.168.100.40 |
| CLIENT01 | Windows Client | 192.168.100.20 |

Domain:

```text
lab.local
```

Primary shared path:

```text
\\FS01\Sales
```

---

# Recommended Order

1. [01-create-shared-folder.md](01-create-shared-folder.md)  
   Create and configure a shared folder.

2. [02-ntfs-vs-share-permissions.md](02-ntfs-vs-share-permissions.md)  
   Validate effective access permissions.

3. [03-department-share-model.md](03-department-share-model.md)  
   Configure department-based access using AD security groups.

4. [04-map-network-drive.md](04-map-network-drive.md)  
   Configure mapped network drives manually and through Group Policy.

5. [05-access-denied-fix.md](05-access-denied-fix.md)  
   Troubleshoot and resolve file access problems.

---

# Operating Standard

All file access changes must be tested using standard domain users.

Administrative accounts may bypass permission restrictions and produce incorrect validation results.

Before modifying:
- shared folders
- NTFS permissions
- SMB permissions
- mapped drives
- security groups

record the current configuration and verify:
- DNS resolution
- network connectivity
- SMB access
- Active Directory group membership

Use PowerShell transcripts during administrative work:

```powershell
Start-Transcript -Path C:\Logs\fileserver-change.txt -Append
```

Store screenshots in:

```text
screenshots/
```

---

# Validation Pattern

Each procedure should follow the same validation workflow:

1. Configure the change on the server.
2. Verify configuration using PowerShell.
3. Test access from `CLIENT01`.
4. Validate with a standard domain user.
5. Confirm expected permissions and file operations.

Common validation commands:

```powershell
Get-SmbShare
```

```powershell
Get-SmbShareAccess -Name Sales
```

```powershell
icacls D:\Shares\Sales
```

```powershell
Test-Path '\\FS01\Sales'
```

---

# Troubleshooting Workflow

When file access issues occur:

1. Verify DNS resolution.
2. Verify SMB connectivity.
3. Verify share permissions.
4. Verify NTFS permissions.
5. Verify AD group membership.
6. Verify user logon refresh.

Useful troubleshooting commands:

```powershell
Resolve-DnsName FS01
```

```powershell
Test-NetConnection FS01 -Port 445
```

```powershell
whoami /groups
```

```powershell
Get-ADPrincipalGroupMembership jsmith
```

---

# Verification Requirements

Each completed lab should verify:

- Shared folders accessible
- NTFS permissions applied correctly
- Security groups functioning
- Mapped drives operational
- Standard users able to access approved data
- Unauthorized access properly blocked

Use screenshots and PowerShell output as operational evidence.
