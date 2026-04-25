# Active Directory Manual Configuration

## Purpose

Active Directory is the identity backbone for this lab. These runbooks show how to install the role, promote a domain controller, design OUs, create users and groups, join clients, and perform account support tasks safely. This section is designed as a practical runbook set, not a theory-only reference. Each guide starts with the business reason, walks through both GUI and PowerShell approaches when appropriate, and finishes with verification and troubleshooting. The examples assume `lab.local`, `DC01` at `192.168.100.10`, `CLIENT01` at `192.168.100.20`, and an Ubuntu host at `192.168.100.30` where cross-platform validation is needed.

## Recommended Order

- [01-install-ad-ds.md](01-install-ad-ds.md) - Install the AD DS role on Windows Server 2022.
- [02-promote-to-dc.md](02-promote-to-dc.md) - Promote DC01 into the first domain controller for lab.local.
- [03-create-ous.md](03-create-ous.md) - Create an OU model for users, computers, servers, and departments.
- [04-create-users-groups.md](04-create-users-groups.md) - Create sample users and role-based security groups.
- [05-join-client-to-domain.md](05-join-client-to-domain.md) - Join CLIENT01 to lab.local and validate sign-in.
- [06-password-reset-unlock.md](06-password-reset-unlock.md) - Reset passwords and unlock accounts using ADUC and PowerShell.
- [07-disable-terminated-user.md](07-disable-terminated-user.md) - Disable and document terminated user access.

Follow the numbered documents in order unless you are responding to a specific incident. The order matters because later procedures often rely on earlier ones. For example, a mapped drive GPO is easier to validate after the file server permissions are known-good, and DHCP troubleshooting is easier after DNS has already been verified. When a guide references another folder, use the relative links rather than searching manually; this mirrors the way production runbooks should direct technicians to the next trusted source of information.

## Operating Standard

Identity work should be handled as an auditable workflow. Confirm the request, identify the exact object, make the smallest required change, validate from a client, and record the outcome.

Before changing a domain, policy, DNS zone, DHCP scope, share, backup job, or patch state, record the current value and the reason for the change. Use PowerShell transcripts for commands and capture screenshots for GUI actions. Save evidence with a consistent name under the local `screenshots` directory, then update the markdown image tag after the lab execution. Do not use mock screenshots; the point of this repository is to show real operational work.

## Validation Pattern

Every guide follows the same validation pattern. First, verify the server-side configuration with an administrative tool. Second, test from a client computer using a standard account. Third, review the relevant event log if the behavior does not match the expected state. Fourth, document the result in the ticket or change record. This pattern keeps troubleshooting disciplined and reduces the chance that a change is declared complete simply because it looked correct on the server.

## Troubleshooting Mindset

When something fails, avoid changing several settings at once. Check identity, network, name resolution, time, permissions, policy scope, and service state in that order. A locked account, stale DNS cache, missing OU link, stopped service, or inherited deny permission can create symptoms that look much larger than the actual root cause. Keep the exact error message in the notes because Windows administrative errors are often searchable and event IDs provide strong clues.

## Production Notes

In production, add peer review and change approval before applying these steps. Test policy and script changes against a pilot OU, schedule disruptive work outside business hours, and confirm rollback instructions. For shared services such as DNS, DHCP, file services, and domain controllers, notify the service desk before work begins so incoming calls can be correlated with the change window. The lab is intentionally small, but the habits practiced here scale to larger environments.
