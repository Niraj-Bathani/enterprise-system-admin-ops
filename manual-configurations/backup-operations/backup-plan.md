# Backup Plan

## Objective

Define a lab backup plan that mirrors production thinking: identify what matters, choose frequency, define retention, test restore, and assign ownership. The lab focuses on `DC01`, file share data, configuration exports, and documentation evidence.

## Scope

Back up system state for `DC01`, file data from `FS01`, exported GPO reports, DHCP configuration, DNS zone data where applicable, and automation scripts. In production, Active Directory system state and file data usually have different recovery objectives. Domain controllers can often be rebuilt if another healthy DC exists, but a single-DC lab needs system state backup for realistic recovery practice.

## Schedule

Run daily file backups and weekly system state backups in the lab. Keep at least seven daily restore points and four weekly restore points. Use external storage or a separate virtual disk to avoid storing backups only on the system being protected. In production, align frequency with recovery point objective, business criticality, and compliance rules.

## Commands

For Windows Server Backup, install the feature with `Install-WindowsFeature Windows-Server-Backup`. A lab system state backup can be started with `wbadmin start systemstatebackup -backupTarget:E: -quiet`. File backups depend on the tool, but validation should include listing backup contents and restoring a sample file.

## Evidence

Capture `![Backup verify](../../screenshots/backup-verify.png)` after the lab run. The image should show job success or restore proof. A backup plan is incomplete until restore testing is scheduled and documented.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `backup-plan-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [daily-checklist.md](daily-checklist.md), [restore-test.md](restore-test.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
