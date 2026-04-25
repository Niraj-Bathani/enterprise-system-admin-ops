# Scheduled Tasks

## Purpose

Scheduled tasks run reports and cleanup jobs consistently without relying on a person to remember them. This section is designed as a practical runbook set, not a theory-only reference. Each guide starts with the business reason, walks through both GUI and PowerShell approaches when appropriate, and finishes with verification and troubleshooting. The examples assume `lab.local`, `DC01` at `192.168.100.10`, `CLIENT01` at `192.168.100.20`, and an Ubuntu host at `192.168.100.30` where cross-platform validation is needed.

## Recommended Order

- [nightly-cleanup.md](nightly-cleanup.md) - Create a nightly cleanup scheduled task.
- [weekly-report.md](weekly-report.md) - Create a weekly report scheduled task.

Follow the numbered documents in order unless you are responding to a specific incident. The order matters because later procedures often rely on earlier ones. For example, a mapped drive GPO is easier to validate after the file server permissions are known-good, and DHCP troubleshooting is easier after DNS has already been verified. When a guide references another folder, use the relative links rather than searching manually; this mirrors the way production runbooks should direct technicians to the next trusted source of information.

## Operating Standard

Use managed service accounts or dedicated least-privilege task accounts in production. In the lab, run tasks under an authorized administrator and document the trigger, action, and log path.

Before changing a domain, policy, DNS zone, DHCP scope, share, backup job, or patch state, record the current value and the reason for the change. Use PowerShell transcripts for commands and capture screenshots for GUI actions. Save evidence with a consistent name under the local `screenshots` directory, then update the markdown image tag after the lab execution. Do not use mock screenshots; the point of this repository is to show real operational work.

## Validation Pattern

Every guide follows the same validation pattern. First, verify the server-side configuration with an administrative tool. Second, test from a client computer using a standard account. Third, review the relevant event log if the behavior does not match the expected state. Fourth, document the result in the ticket or change record. This pattern keeps troubleshooting disciplined and reduces the chance that a change is declared complete simply because it looked correct on the server.

## Troubleshooting Mindset

When something fails, avoid changing several settings at once. Check identity, network, name resolution, time, permissions, policy scope, and service state in that order. A locked account, stale DNS cache, missing OU link, stopped service, or inherited deny permission can create symptoms that look much larger than the actual root cause. Keep the exact error message in the notes because Windows administrative errors are often searchable and event IDs provide strong clues.

## Production Notes

In production, add peer review and change approval before applying these steps. Test policy and script changes against a pilot OU, schedule disruptive work outside business hours, and confirm rollback instructions. For shared services such as DNS, DHCP, file services, and domain controllers, notify the service desk before work begins so incoming calls can be correlated with the change window. The lab is intentionally small, but the habits practiced here scale to larger environments.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `scheduled-tasks-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [nightly-cleanup.md](nightly-cleanup.md), [weekly-report.md](weekly-report.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
