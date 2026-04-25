# Backup Operations

## Purpose

Backup operations protect directory services, file data, configuration, and recovery confidence. These guides cover planning, daily checks, and restore tests. This section is designed as a practical runbook set, not a theory-only reference. Each guide starts with the business reason, walks through both GUI and PowerShell approaches when appropriate, and finishes with verification and troubleshooting. The examples assume `lab.local`, `DC01` at `192.168.100.10`, `CLIENT01` at `192.168.100.20`, and an Ubuntu host at `192.168.100.30` where cross-platform validation is needed.

## Recommended Order

- [backup-plan.md](backup-plan.md) - Define a practical lab backup plan.
- [daily-checklist.md](daily-checklist.md) - Check backup status and evidence daily.
- [restore-test.md](restore-test.md) - Perform and document restore testing.

Follow the numbered documents in order unless you are responding to a specific incident. The order matters because later procedures often rely on earlier ones. For example, a mapped drive GPO is easier to validate after the file server permissions are known-good, and DHCP troubleshooting is easier after DNS has already been verified. When a guide references another folder, use the relative links rather than searching manually; this mirrors the way production runbooks should direct technicians to the next trusted source of information.

## Operating Standard

A backup is only useful when restore has been tested. The lab runbooks emphasize verification evidence rather than assuming a successful job means recoverability.

Before changing a domain, policy, DNS zone, DHCP scope, share, backup job, or patch state, record the current value and the reason for the change. Use PowerShell transcripts for commands and capture screenshots for GUI actions. Save evidence with a consistent name under the local `screenshots` directory, then update the markdown image tag after the lab execution. Do not use mock screenshots; the point of this repository is to show real operational work.

## Validation Pattern

Every guide follows the same validation pattern. First, verify the server-side configuration with an administrative tool. Second, test from a client computer using a standard account. Third, review the relevant event log if the behavior does not match the expected state. Fourth, document the result in the ticket or change record. This pattern keeps troubleshooting disciplined and reduces the chance that a change is declared complete simply because it looked correct on the server.

## Troubleshooting Mindset

When something fails, avoid changing several settings at once. Check identity, network, name resolution, time, permissions, policy scope, and service state in that order. A locked account, stale DNS cache, missing OU link, stopped service, or inherited deny permission can create symptoms that look much larger than the actual root cause. Keep the exact error message in the notes because Windows administrative errors are often searchable and event IDs provide strong clues.

## Production Notes

In production, add peer review and change approval before applying these steps. Test policy and script changes against a pilot OU, schedule disruptive work outside business hours, and confirm rollback instructions. For shared services such as DNS, DHCP, file services, and domain controllers, notify the service desk before work begins so incoming calls can be correlated with the change window. The lab is intentionally small, but the habits practiced here scale to larger environments.
