# Map Network Drive

## Objective

Map a network drive manually and through Group Policy in the `lab.local` environment.

---

# Why It Matters

Mapped drives provide users with easy access to centralized file shares and improve consistency across workstations.

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

Mapped drive letter:

```text
S:
```

---

# Prerequisites

Before starting:

- Shared folder created
- SMB share operational
- DNS functioning correctly
- Client joined to domain
- PowerShell running as Administrator

Verify SMB connectivity:

```powershell
Test-NetConnection FS01 -Port 445
```

Verify DNS resolution:

```powershell
Resolve-DnsName FS01
```

---

# GUI Procedure

## Manual Drive Mapping

On `CLIENT01`:

1. Open:

```text
File Explorer
```

2. Select:

```text
This PC
→ Map network drive
```

3. Configure:

| Setting | Value |
|---|---|
| Drive Letter | S: |
| Folder | \\FS01\Sales |

4. Enable:

```text
Reconnect at sign-in
```

5. Complete the wizard.

---

## Group Policy Drive Mapping

Open:

```text
Group Policy Management
```

Navigate to:

```text
User Configuration
→ Preferences
→ Windows Settings
→ Drive Maps
```

Create:
- New Mapped Drive

Configure:

| Setting | Value |
|---|---|
| Action | Create |
| Location | \\FS01\Sales |
| Drive Letter | S: |

Apply the GPO to the required users or OU.

Run on `CLIENT01`:

```powershell
gpupdate /force
```

---

# PowerShell Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\map-network-drive.txt -Append
```

Map the drive:

```powershell
net use S: \\FS01\Sales /persistent:yes
```

Verify SMB mapping:

```powershell
Get-SmbMapping
```

Stop logging:

```powershell
Stop-Transcript
```

---

# Verification

## Verify Drive Mapping

Run:

```powershell
net use
```

Expected result:

```text
S: \\FS01\Sales
```

---

## Verify Drive Access

Run:

```powershell
Test-Path S:\
```

Expected result:

```text
True
```

---

## Verify File Access

Create a test file:

```powershell
New-Item S:\test.txt -ItemType File
```

Confirm the file appears inside the share.

---

## Verify Group Policy Application

Run:

```powershell
gpresult /r
```

Confirm the drive mapping GPO is applied.

---

# Common Issues And Fixes

## Drive Maps But Access Is Denied

Verify:
- NTFS permissions
- share permissions
- group membership

Refresh user logon session after permission changes.

---

## Drive Does Not Reconnect

Verify:
- persistent mapping enabled
- DNS resolution functioning
- SMB connectivity available

Reconnect manually if necessary:

```powershell
net use S: /delete
```

```powershell
net use S: \\FS01\Sales /persistent:yes
```

---

## Drive Mapping GPO Not Applying

Run:

```powershell
gpupdate /force
```

Verify applied policies:

```powershell
gpresult /r
```

---

## Name Resolution Failure

Verify DNS:

```powershell
Resolve-DnsName FS01
```

Confirm client DNS server:

```text
192.168.100.10
```

---

# Screenshot Capture

![Mapped network drive](/screenshots/mapped-drive.png)
