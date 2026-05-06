# Daily Backup Checklist

## Objective

The purpose of this checklist is to verify daily backup health, confirm restore point availability, and identify operational issues before they affect recovery capability. Regular validation reduces the risk of discovering failed backups during an actual incident or outage.

This procedure applies to the following lab environment:

| Server | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| FS01 | File Server | 192.168.100.20 |
| CLIENT01 | Validation Workstation | 192.168.100.30 |

Domain: `lab.local`

---

# Daily Validation Tasks

## 1. Verify Backup Versions

Run the following command to confirm recent backup versions exist:

```powershell
wbadmin get versions
```

### Validation Criteria

- A recent backup version is listed
- The timestamp matches the expected backup schedule
- The backup target is correct
- No backup catalog errors appear

### Example Output

```text
Backup time: 2026-05-01 02:00
Backup target: Fixed Disk labeled Backup
Version identifier: 05/01/2026-02:00
```

---

## 2. Verify Backup Job Status

Check the current backup status:

```powershell
wbadmin get status
```

### Validation Criteria

- Backup completed successfully
- No failed jobs are present
- No interrupted or pending operations exist

If backups are scheduled overnight, perform this review during the morning operational check.

---

## 3. Verify Backup Storage Capacity

Review available storage space on the backup destination:

```powershell
Get-PSDrive
```

or:

```powershell
Get-Volume
```

### Validation Criteria

- Sufficient free space exists
- Backup volumes are healthy
- Retention growth remains within expected limits

Low storage space is one of the most common causes of backup failure.

---

## 4. Review Backup Event Logs

Open:

```text
Event Viewer
→ Applications and Services Logs
→ Microsoft
→ Windows
→ Backup
→ Operational
```

Review recent events for:

- Errors
- Warnings
- Failed jobs
- VSS issues
- Storage access failures

PowerShell alternative:

```powershell
Get-WinEvent -LogName 'Microsoft-Windows-Backup/Operational' -MaxEvents 20
```

### Validation Criteria

- No critical errors exist
- No repeated backup failures appear
- Backup operations completed successfully

---

## 5. Verify Backup Destination Contents

Review the backup target directly:

```powershell
Get-ChildItem E:\WindowsImageBackup
```

### Validation Criteria

- Backup folders exist
- File timestamps are current
- Backup sizes appear normal
- No incomplete backup sets are present

---

# File Backup Validation

If file-level backups or `Robocopy` jobs are used, review logs and confirm successful copy operations.

Example:

```powershell
Get-Content C:\Logs\Robocopy.log
```

### Validation Criteria

- Files copied successfully
- No excessive failures or skipped files
- Backup completed within expected duration

---

# Failure Handling Procedure

If a backup fails:

1. Create an incident or operational task immediately.
2. Record:
   - affected server
   - backup type
   - exact error message
   - timestamp
   - last successful restore point
3. Investigate root cause before rerunning the job.

Common causes include:

- insufficient disk space
- VSS writer failures
- disconnected backup targets
- credential failures
- permission issues
- corrupted backup catalogs

Do not assume rerunning the backup resolves the underlying issue.

---

# Troubleshooting Commands

## Check VSS Writers

```powershell
vssadmin list writers
```

Expected result:

```text
State: Stable
Last error: No error
```

---

## Verify Backup Feature Installation

```powershell
Get-WindowsFeature Windows-Server-Backup
```

---

## Verify Backup Services

```powershell
Get-Service wbengine,VSS
```

Expected service state:

```text
Running
```

---

# Daily Backup Validation Checklist

| Validation Item | Expected Result |
|---|---|
| Backup completed successfully | Yes |
| Recent restore point exists | Yes |
| Backup storage healthy | Yes |
| Event logs clean | Yes |
| No VSS errors detected | Yes |
| Backup files accessible | Yes |

---

# Screenshot Capture

![Daily backup check](/screenshots/daily-backup-check.png)


---
