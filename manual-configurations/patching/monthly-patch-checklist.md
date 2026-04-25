# Monthly Patch Checklist

## Objective

Run a controlled monthly Windows patch cycle for the lab while practicing production-grade change discipline. The checklist starts before updates are installed because patching is not simply clicking Install. It includes inventory, backup confirmation, stakeholder notification, installation, reboot planning, validation, and ticket closure.

## Pre-Patch Steps

Create a change record with the patch window, affected systems, expected reboot count, and rollback plan. Confirm the latest successful backup for `DC01`, `FS01`, and `CLIENT01`. Run `Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 10` to capture the current state. Check free disk space with `Get-PSDrive C` and confirm at least 15 percent free space. Review service health before starting so post-patch failures can be compared to a known baseline.

## Installation Steps

In the lab, use Windows Update interactively or PowerShell with the PSWindowsUpdate module if installed from an approved source. A manual path is Settings, Windows Update, Check for updates, Install, then Restart. A command-based validation path after installation is `Get-HotFix`, `systeminfo`, and Event Viewer review under Setup and System logs. Avoid patching every server at exactly the same moment in production; domain controllers, file servers, and application servers should be sequenced.

## Post-Patch Validation

After reboot, sign in and check critical services. On `DC01`, run `dcdiag /q`, `repadmin /replsummary`, `Resolve-DnsName lab.local`, and `Get-Service DNS,NTDS,Netlogon,Kdc`. On `FS01`, test `\\FS01\Sales` from `CLIENT01`. On the client, run `gpupdate /force` and confirm domain sign-in still works. Capture screenshots after the lab run using `![Patch validation](./screenshots/monthly-patch-validation.png)`.

## Troubleshooting

If an update fails, capture the KB number and error code before retrying. Run `Get-WindowsUpdateLog` on newer systems when needed, review `C:\Windows\Logs\CBS\CBS.log`, and use `DISM /Online /Cleanup-Image /RestoreHealth` followed by `sfc /scannow` for component store issues. Do not repeatedly reboot without reading the error; repeated attempts can extend downtime without changing the cause.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `monthly-patch-checklist-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [pre-post-validation.md](pre-post-validation.md), [failed-update-remediation.md](failed-update-remediation.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
