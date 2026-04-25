# Pre And Post Patch Validation

## Objective

Use a repeatable validation checklist before and after patching so service health is measured instead of assumed. The same checks should run before and after the maintenance window, and differences should be investigated before the change is closed.

## Pre-Validation

Record uptime with `Get-CimInstance Win32_OperatingSystem | Select-Object LastBootUpTime`. Record installed hotfixes with `Get-HotFix`. Check disk space using `Get-PSDrive`. On a domain controller, run `dcdiag /q`, `repadmin /replsummary`, `Get-Service DNS,NTDS,Netlogon,Kdc`, and `Get-SmbShare SYSVOL,NETLOGON`. On a file server, run `Get-SmbShare`, `Get-SmbSession`, and a test file read from a client. On a DHCP server, run `Get-DhcpServerv4Scope` and `Get-DhcpServerv4Lease`.

## Post-Validation

After patching and reboot, repeat the same commands. Expected output should show services running, no new replication failures, DNS resolution working, and users able to access file shares. A successful update install is not enough if domain logon, DNS, DHCP, or SMB is broken. Save the before and after output in the change record.

## Screenshot Capture

Use `![Patch pre check](./screenshots/patch-pre-check.png)` and `![Patch post check](./screenshots/patch-post-check.png)` after the lab run. The screenshots should show command output or Server Manager health, not a generic desktop view.

## Escalation

If a post-check fails, classify severity by business impact. A stopped DNS service on `DC01` is more urgent than a single optional update failure on `CLIENT01`. Escalate with the failed command, error output, event IDs, time of reboot, and rollback recommendation.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `pre-and-post-patch-validation-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [monthly-patch-checklist.md](monthly-patch-checklist.md), [failed-update-remediation.md](failed-update-remediation.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
