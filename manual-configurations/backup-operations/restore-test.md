# Restore Test

## Objective

Perform a controlled restore test to prove backups are usable. Restore testing is the difference between hoping and knowing. The lab restore should recover a sample file and document the time, source backup, target location, and validation result.

## Preparation

Create a test file in `D:\Shares\Sales\restore-test.txt` with known content. Run the backup job. Delete or rename the file only after confirming the backup version exists. Choose a restore target that does not overwrite production-like data unless the test specifically requires original-location restore.

## Restore Steps

Using Windows Server Backup, open the console, choose Recover, select the backup location, choose the backup date, select Files and folders, choose the sample file, and restore to an alternate path such as `D:\RestoreTest`. With command-line tools, document the exact command and output. After restore, compare the file content using `Get-Content` and file hash using `Get-FileHash`.

## Validation

The restore passes when the file exists, contents match, permissions are understood, and the restore time is recorded. Capture `![Restore test](./screenshots/restore-test.png)` after the lab run. Include the screenshot in the change or operations record.

## Lessons For Production

Production restore tests should include file-level, system-state, and application-aware scenarios where relevant. Test to alternate location first unless the business explicitly approves overwriting live data. Record recovery time objective and actual restore duration so planning is based on evidence.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `restore-test-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [backup-plan.md](backup-plan.md), [daily-checklist.md](daily-checklist.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
