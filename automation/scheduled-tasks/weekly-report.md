# Weekly Report Scheduled Task

## Overview

This task automates the execution of operational reports on a weekly basis. It ensures regular visibility into system health, user activity, and potential issues before they escalate into incidents.

---

## What This Demonstrates

- Scheduling and automation of reporting workflows  
- Aggregating multiple scripts into a single execution  
- Operational monitoring and proactive maintenance  
- Structured review and follow-up processes  

---

## Objective

Create a scheduled task that runs a set of operational reports weekly and stores the results for review and action.

---

## Report Set

The weekly report includes:

- `last-logon-report.ps1`  
- `locked-accounts-report.ps1`  
- `stale-computers-report.ps1`  
- `disk-space-report.ps1`  
- `server-uptime-check.ps1`  

Each script generates logs under `C:\Logs` and exports structured output.

---

## Wrapper Script Example

```powershell
# WeeklyOpsReport.ps1

$logPath = "C:\Logs\WeeklyReport"

New-Item -ItemType Directory -Path $logPath -Force | Out-Null

.\last-logon-report.ps1 -SearchBase 'OU=Users,DC=lab,DC=local'
.\locked-accounts-report.ps1
.\stale-computers-report.ps1 -SearchBase 'DC=lab,DC=local'
.\disk-space-report.ps1 -ComputerName DC01
.\server-uptime-check.ps1 -ComputerName DC01
Scheduled Task Configuration
$action = New-ScheduledTaskAction `
    -Execute "PowerShell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File C:\Scripts\WeeklyOpsReport.ps1"

$trigger = New-ScheduledTaskTrigger `
    -Weekly `
    -DaysOfWeek Monday `
    -At 7:00am

Register-ScheduledTask `
    -TaskName "LAB Weekly Ops Report" `
    -Action $action `
    -Trigger $trigger
Expected Outcome
Reports are generated weekly
Output files are stored in C:\Logs
Task completes successfully (Last Run Result = 0x0)
Logs reflect successful execution
Review Process

Assign a responsible owner to review reports every week.

Typical actions:

Investigate locked accounts
Disable inactive users
Review stale computer objects
Address low disk space

Changes should be tracked via tickets rather than applied silently.

Validation
Run the task manually
Check Task Scheduler history
Verify report files are created
Confirm script outputs are correct

📸 Screenshot:

![Weekly report task](./screenshots/weekly-report-task.png)
Troubleshooting

If the task does not run:

Verify credentials and permissions
Confirm script path and execution policy
Check Task Scheduler history

If reports are incomplete:

Validate script execution
Confirm paths and parameters
Review logs under C:\Logs
Production Considerations
Use service accounts with least privilege
Schedule during non-business hours
Integrate with monitoring or ticketing systems
Ensure reports are reviewed and acted upon
Summary

This task demonstrates how to automate recurring reporting workflows and turn system data into actionable insights. It reflects real-world operational practices used to maintain system health and prevent incidents.