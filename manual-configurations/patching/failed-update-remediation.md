# Failed Update Remediation

## Objective

Resolve failed Windows updates using a careful sequence that preserves evidence and avoids unnecessary rebuilds. The goal is to identify whether the failure is caused by connectivity, insufficient disk, component store corruption, pending reboot, service state, or update applicability.

## Triage

Record the KB number, error code, operating system version, and time of failure. Run `Get-HotFix -Id KB5000000` with the real KB number to confirm whether the update installed despite the UI error. Check `Settings > Windows Update > Update history`, Event Viewer Setup log, and `C:\Windows\Logs\CBS\CBS.log`. Confirm free disk space with `Get-PSDrive C` and restart once if a pending reboot is clearly indicated.

## Remediation Commands

Start with service and component health. Run `DISM /Online /Cleanup-Image /ScanHealth`, then `DISM /Online /Cleanup-Image /RestoreHealth`, then `sfc /scannow`. If Windows Update cache corruption is suspected in the lab, stop update services, rename `C:\Windows\SoftwareDistribution` to `SoftwareDistribution.old`, start services, and retry. Use this carefully in production and document the reason.

## Validation

Retry the update, reboot if required, and run `Get-HotFix` again. Check application and service health rather than only the update screen. Capture `![Failed update remediation](./screenshots/failed-update-remediation.png)` after lab execution, showing either the successful update history or the command output that proves repair completed.

## When To Escalate

Escalate when DISM cannot repair the component store, the same update fails on many machines, the server hosts a critical service, or rollback would affect business operations. Include logs, command output, and the exact KB number so the next tier can continue without repeating basic checks.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `failed-update-remediation-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [monthly-patch-checklist.md](monthly-patch-checklist.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
