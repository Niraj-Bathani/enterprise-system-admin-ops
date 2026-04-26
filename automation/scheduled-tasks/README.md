# Scheduled Tasks

## Overview

This section demonstrates how recurring administrative tasks are automated using Windows Task Scheduler. These tasks ensure consistency, reduce manual effort, and provide reliable execution of maintenance and reporting operations.

---

## What This Section Demonstrates

- Automation of recurring system tasks  
- Use of Task Scheduler with PowerShell scripts  
- Secure execution using least-privilege principles  
- Validation and monitoring of scheduled jobs  

---

## Lab Context

Examples in this section use:

- Domain: lab.local  
- Domain Controller: DC01 (192.168.100.10)  
- Client: CLIENT01 (192.168.100.20)  
- Linux Server: UBUNTU01 (192.168.100.30)  

---

## Task Overview

- [nightly-cleanup.md](nightly-cleanup.md)  
  Automates cleanup of old logs and temporary files.

- [weekly-report.md](weekly-report.md)  
  Runs reporting scripts on a weekly schedule.

---

## Example Configuration

```powershell
$action = New-ScheduledTaskAction `
    -Execute "PowerShell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File C:\Scripts\script.ps1"

$trigger = New-ScheduledTaskTrigger -Daily -At 2:00am

Register-ScheduledTask `
    -TaskName "Example Task" `
    -Action $action `
    -Trigger $trigger
Expected Outcome

Scheduled tasks should:

Execute at defined intervals
Complete successfully (Last Run Result = 0x0)
Generate logs or reports
Perform only intended actions
Operating Standard

In production environments:

Use managed service accounts or dedicated task accounts
Assign least privilege required
Document task purpose, trigger, and script path
Monitor execution regularly

In the lab:

Use administrator account
Focus on correct configuration and validation
Validation

To validate a scheduled task:

Run the task manually
Check Last Run Result
Review script logs or output
Confirm expected behavior
Troubleshooting

If the task does not run:

Verify credentials and permissions
Check trigger configuration
Confirm script path and execution policy

If the task runs but produces incorrect results:

Validate script logic
Check working directory
Review logs
Production Considerations
Schedule tasks during maintenance windows
Monitor failures and alert when needed
Maintain rollback procedures
Ensure tasks do not impact system performance
Summary

This section demonstrates how to automate recurring administrative operations using scheduled tasks. It emphasizes reliability, validation, and operational discipline required in real-world environments.