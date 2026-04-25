# Nightly Cleanup Scheduled Task

## Objective

Create a scheduled task that runs a safe nightly cleanup script for temporary files and old logs in the lab. The task demonstrates how administrators document triggers, actions, run accounts, logging, and validation.

## Design

In the lab, the task can run as an authorized administrator. In production, use a managed service account or dedicated task account with only the permissions required. The cleanup should target known paths such as `C:\Logs\Archive` or application temp folders, not broad system locations. Deleting files older than a threshold is safer than deleting everything in a folder.

## Example Command

Create the action with `New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-NoProfile -ExecutionPolicy Bypass -File C:\Scripts\NightlyCleanup.ps1'`. Create the trigger with `New-ScheduledTaskTrigger -Daily -At 2:00am`. Register with `Register-ScheduledTask -TaskName 'LAB Nightly Cleanup' -Action $action -Trigger $trigger -Description 'Removes old lab logs after retention period'`.

## Validation

Run the task manually from Task Scheduler, then check Last Run Result. A result of `0x0` means the process exited successfully, but still review the script log. Check that only expected files were removed and that the log includes timestamped actions. Capture `![Nightly cleanup task](./screenshots/nightly-cleanup-task.png)` after lab execution.

## Troubleshooting

If the task does not run, confirm the account password, run whether user is logged on setting, execution policy, path spelling, and permissions to the script and target folders. If it runs but deletes nothing, check the file age filter and whether the script is running in the expected working directory.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `nightly-cleanup-scheduled-task-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [weekly-report.md](weekly-report.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
