# Patching Operations

## Purpose

This section covers practical Windows patch management procedures in the `lab.local` environment using Windows Server 2022 and domain-joined Windows clients.

The procedures focus on:

- monthly patch planning
- update installation workflows
- pre-patch validation
- post-patch verification
- failed update remediation
- reboot coordination
- operational validation

Lab systems used throughout this section:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| CLIENT01 | Windows Client | 192.168.100.20 |
| UBUNTU01 | Ubuntu Test Host | 192.168.100.30 |

Domain:

```text
lab.local
```

---

## Recommended Order

1. [monthly-patch-checklist.md](monthly-patch-checklist.md)  
   Perform monthly patch planning and execution.

2. [pre-post-validation.md](pre-post-validation.md)  
   Validate systems before and after patch installation.

3. [failed-update-remediation.md](failed-update-remediation.md)  
   Troubleshoot and remediate failed Windows updates.

---

## Operating Standard

When performing patch operations:

- verify backups before patching
- document maintenance windows
- notify affected users
- patch test systems first
- reboot systems in a controlled sequence
- validate services after reboot
- collect screenshots and logs after validation

Store screenshots inside:

```text
/screenshots/
```

Use filenames that match the procedure being validated.

---

## Validation Pattern

Each patching procedure follows the same workflow:

1. Verify system health before patching.
2. Install updates.
3. Reboot the system if required.
4. Validate services and connectivity.
5. Review update logs and event logs.
6. Document final operational status.

Common validation commands:

```powershell
Get-HotFix
```

```powershell
Get-Service
```

```powershell
Test-NetConnection DC01 -Port 389
```

```powershell
Resolve-DnsName lab.local
```

---

## Troubleshooting Mindset

When troubleshooting patching problems:

- verify network connectivity
- confirm Windows Update service status
- review update history
- check available disk space
- review CBS and Windows Update logs
- validate service startup state after reboot
- isolate failed KB updates before remediation

Useful troubleshooting commands:

```powershell
Get-WindowsUpdateLog
```

```powershell
Get-Service wuauserv
```

```powershell
Get-HotFix
```

```powershell
sfc /scannow
```

```powershell
DISM /Online /Cleanup-Image /RestoreHealth
```

---

## Production Notes

In production environments:

- use approved maintenance windows
- patch non-production systems first
- validate backups before deployment
- maintain rollback procedures
- notify support teams before reboot operations
- document failed updates and remediation actions
- validate critical services after patching
