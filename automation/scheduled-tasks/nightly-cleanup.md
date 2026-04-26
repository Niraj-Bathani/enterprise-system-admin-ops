# Nightly Cleanup Scheduled Task

## Overview

This task automates the cleanup of temporary files and archived logs in the lab environment. It demonstrates how administrators design, schedule, validate, and document recurring maintenance tasks.

---

## What This Demonstrates

- Scheduled task creation and automation  
- Safe file cleanup practices using retention policies  
- Logging and validation of automated processes  
- Operational thinking for recurring maintenance tasks  

---

## Objective

Create a scheduled task that runs a controlled cleanup script nightly to remove old log and temporary files without affecting system stability.

---

## Design

In the lab, the task can run as an administrator account.  
In production, use a dedicated service account or managed service account with minimal required permissions.

The cleanup must:

- Target specific directories (e.g., `C:\Logs\Archive`)  
- Use file age thresholds (not blanket deletion)  
- Log all actions  

---

## Cleanup Script Example

```powershell
# NightlyCleanup.ps1

$path = "C:\Logs\Archive"
$days = 30

Get-ChildItem -Path $path -File |
Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$days) } |
ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Output "Deleted: $($_.FullName)"
}
Scheduled Task Configuration
$action = New-ScheduledTaskAction `
    -Execute 'PowerShell.exe' `
    -Argument '-NoProfile -ExecutionPolicy Bypass -File C:\Scripts\NightlyCleanup.ps1'

$trigger = New-ScheduledTaskTrigger -Daily -At 2:00am

Register-ScheduledTask `
    -TaskName 'LAB Nightly Cleanup' `
    -Action $action `
    -Trigger $trigger `
    -Description 'Removes old lab logs after retention period'
Validation
Run the task manually from Task Scheduler
Check Last Run Result = 0x0
Review script output/logs
Confirm only expected files were deleted

📸 Screenshot:

![Nightly cleanup task](./screenshots/nightly-cleanup-task.png)
Expected Outcome
Old files are deleted based on retention policy
No critical system files are affected
Script logs show actions performed
Task completes successfully (0x0)
Troubleshooting

If the task does not run:

Verify account credentials
Check “Run whether user is logged on or not”
Confirm script path and execution policy
Check permissions on script and target folders

If the task runs but no files are deleted:

Verify file age filter
Confirm correct directory path
Check script execution context
Operational Notes

This procedure is tested in a lab environment (lab.local, 192.168.100.0/24).

In production:

Use change management
Define maintenance window
Assign ownership and validation responsibility
Ensure rollback plan exists

Always capture:

initial state
configuration changes
validation results
Summary

This task demonstrates how to safely automate recurring maintenance using scheduled tasks. It emphasizes controlled execution, logging, validation, and operational discipline required in real-world system administration.