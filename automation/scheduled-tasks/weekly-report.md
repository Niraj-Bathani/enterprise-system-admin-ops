# Weekly Report Scheduled Task

## Objective

Create a weekly scheduled task that runs operational reports and stores output for review. Weekly reports help identify stale accounts, locked accounts, low disk space, recent restarts, and other patterns before they become incidents.

## Report Set

A useful lab report can run `last-logon-report.ps1`, `locked-accounts-report.ps1`, `stale-computers-report.ps1`, `disk-space-report.ps1`, and `server-uptime-check.ps1`. Each script writes logs under `C:\Logs` and returns structured output. In production, combine this with email, ticket creation, or dashboard ingestion only after the script output is trusted.

## Example Task

Create a wrapper script at `C:\Scripts\WeeklyOpsReport.ps1` that calls each report with explicit parameters. Register a task with `New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 7:00am`. The action should run PowerShell with `-NoProfile` and a fully qualified script path. Avoid relying on mapped drives because scheduled tasks often run without an interactive user profile.

## Review Process

Assign an owner to review the report every Monday. The owner should open tickets for cleanup work rather than silently changing accounts. For example, stale computers should be validated with endpoint inventory before disabling. Locked account trends should be compared with incident records.

## Screenshot Capture

Use `![Weekly report task](./screenshots/weekly-report-task.png)` after lab execution. Capture Task Scheduler history, last run result, and the generated report folder.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `weekly-report-scheduled-task-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](../reports/README.md), [README.md](../health-checks/README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
