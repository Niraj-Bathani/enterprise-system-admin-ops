# Monthly Patch Checklist

## Objective

Perform a controlled monthly Windows patch cycle for the `lab.local` environment while following standard operational validation procedures.

---

# Environment

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| FS01 | File Server | 192.168.100.40 |
| CLIENT01 | Windows Client | 192.168.100.20 |

Domain:

```text
lab.local
```

---

# Pre-Patch Checklist

Before installing updates:

- confirm successful backups for all systems
- verify available disk space
- document current patch state
- confirm critical services are operational
- notify maintenance window participants

Check installed updates:

```powershell
Get-HotFix |
Sort-Object InstalledOn -Descending |
Select-Object -First 10
```

Check free disk space:

```powershell
Get-PSDrive C
```

Verify service status:

```powershell
Get-Service DNS,NTDS,Netlogon,Kdc
```

---

# Install Updates

## GUI Method

1. Open:

```text
Settings
→ Windows Update
```

2. Select:

```text
Check for updates
```

3. Install available updates.

4. Restart the system if required.

---

# PowerShell Validation

Verify installed updates:

```powershell
Get-HotFix
```

View operating system information:

```powershell
systeminfo
```

Review update-related logs:

```powershell
Get-EventLog -LogName Setup -Newest 20
```

---

# Post-Patch Validation

## Domain Controller Validation

Run:

```powershell
dcdiag /q
```

```powershell
repadmin /replsummary
```

```powershell
Resolve-DnsName lab.local
```

```powershell
Get-Service DNS,NTDS,Netlogon,Kdc
```

---

## File Server Validation

From `CLIENT01`, test file share access:

```powershell
Test-Path '\\FS01\Sales'
```

Create a test file:

```powershell
New-Item '\\FS01\Sales\patch-test.txt' -ItemType File
```

---

## Client Validation

Refresh Group Policy:

```powershell
gpupdate /force
```

Verify domain sign-in functionality.

---

# Troubleshooting

## Windows Update Failure

Capture:
- KB number
- error code
- timestamp

Review logs:

```powershell
Get-WindowsUpdateLog
```

```text
C:\Windows\Logs\CBS\CBS.log
```

Repair Windows image:

```powershell
DISM /Online /Cleanup-Image /RestoreHealth
```

Run system file check:

```powershell
sfc /scannow
```

---

# Screenshot Capture

![Patch validation](/screenshots/monthly-patch-validation.png)
