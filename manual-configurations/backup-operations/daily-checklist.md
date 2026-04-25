# Daily Backup Checklist

## Objective

Review backup success every day and catch failures before a restore is needed. A backup failure discovered during an incident is already too late. The daily checklist is intentionally short enough for routine operations but detailed enough to produce audit evidence.

## Daily Steps

Check the backup console or command output for the previous night's jobs. Confirm status, start time, end time, amount of data protected, and target location. On Windows Server Backup, use `wbadmin get versions` to list available backups. Confirm that the backup target has enough free space with `Get-PSDrive` or the storage console. Review Event Viewer under Microsoft, Windows, Backup, Operational for warnings and failures.

## Sample Command Review

Run `wbadmin get status` during an active job or `wbadmin get versions` after completion. If using file copy or another backup tool in the lab, list the target folder and compare timestamp and size with the source. The point is not the tool; the point is verifying that a usable restore point exists.

## Failure Handling

If a backup failed, open an incident or operational task immediately. Record the error, affected server, backup type, and last known good restore point. Do not simply rerun the job without understanding whether the target was full, credentials failed, VSS had an error, or the source was unavailable.

## Screenshot Capture

Use `![Daily backup check](./screenshots/daily-backup-check.png)` after lab execution. The screenshot should show the backup version list or successful job status with date and server name visible.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `daily-backup-checklist-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [backup-plan.md](backup-plan.md), [restore-test.md](restore-test.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
