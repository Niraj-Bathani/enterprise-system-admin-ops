# Failed Update Remediation

## Objective

Diagnose and remediate failed Windows updates in the `lab.local` environment using a structured troubleshooting workflow.

---

## Why It Matters

Windows update failures can be caused by:

- pending reboots
- corrupted update cache
- component store corruption
- insufficient disk space
- service failures
- network connectivity problems
- invalid or failed KB packages

This lab environment uses:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| CLIENT01 | Windows Client | 192.168.100.20 |

Domain:

```text
lab.local
```

---

## Prerequisites

Before starting:

- administrative PowerShell access
- Windows Update service enabled
- internet or WSUS connectivity available
- sufficient disk space available
- current backup or snapshot available

Verify update service status:

```powershell
Get-Service wuauserv
```

Verify free disk space:

```powershell
Get-PSDrive C
```

---

## Triage

Record the following information before remediation:

- KB number
- update error code
- operating system version
- exact failure time
- affected server or workstation

Verify whether the update actually installed:

```powershell
Get-HotFix -Id KB5000000
```

Replace the KB number with the failed update.

Review update history:

```text
Settings
→ Windows Update
→ Update history
```

Review logs:

```text
C:\Windows\Logs\CBS\CBS.log
```

Check Event Viewer:

```text
Event Viewer
→ Windows Logs
→ Setup
```

---

## PowerShell Remediation Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\failed-update-remediation.txt -Append
```

Check component store health:

```powershell
DISM /Online /Cleanup-Image /ScanHealth
```

Repair component store:

```powershell
DISM /Online /Cleanup-Image /RestoreHealth
```

Run system file repair:

```powershell
sfc /scannow
```

Stop update services:

```powershell
Stop-Service wuauserv
Stop-Service bits
```

Rename SoftwareDistribution folder:

```powershell
Rename-Item `
-Path C:\Windows\SoftwareDistribution `
-NewName SoftwareDistribution.old
```

Start update services:

```powershell
Start-Service wuauserv
Start-Service bits
```

Retry Windows Update.

Stop logging:

```powershell
Stop-Transcript
```

---

## Validation

Verify the update installation:

```powershell
Get-HotFix
```

Verify Windows Update service:

```powershell
Get-Service wuauserv
```

Check reboot status:

```powershell
shutdown /r /t 0
```

After reboot:
- confirm the update appears in update history
- verify system services are operational
- confirm applications start normally
- verify network connectivity

---

## Common Issues And Fixes

### Pending Reboot

Restart the system before retrying updates.

---

### Corrupted Update Cache

Reset the update cache:

```powershell
Stop-Service wuauserv
Stop-Service bits
```

```powershell
Rename-Item `
-Path C:\Windows\SoftwareDistribution `
-NewName SoftwareDistribution.old
```

```powershell
Start-Service wuauserv
Start-Service bits
```

---

### DISM Repair Failure

Run:

```powershell
DISM /Online /Cleanup-Image /RestoreHealth
```

If the repair fails repeatedly:
- verify internet connectivity
- verify WSUS accessibility
- consider in-place repair installation

---

### Low Disk Space

Verify available storage:

```powershell
Get-PSDrive C
```

Remove temporary files or expand disk space before retrying updates.

---

## Escalation Conditions

Escalate remediation when:

- DISM cannot repair corruption
- multiple systems fail the same update
- critical services fail after patching
- rollback affects production operations
- CBS or Windows Update logs indicate persistent corruption

Include:
- KB number
- error code
- PowerShell transcript
- Event Viewer logs
- CBS log excerpts
- screenshots of update failure

---

## Screenshot Capture

![Failed update remediation](/screenshots/failed-update-remediation.png)

