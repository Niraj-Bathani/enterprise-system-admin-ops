# Incident Template

## Purpose

This template standardizes how the service desk records a incident. A good ticket lets another technician understand the request, reproduce the issue, see what has already been tried, and continue the work without calling the requester again for basic details. The format is intentionally ITIL-lite: enough structure to support accountability and trend analysis, but not so heavy that technicians avoid using it during busy periods.

## Required Fields

- Ticket ID
- Opened date and time
- Requester name, department, and contact method
- Affected user, device, service, or application
- Priority and impact
- Urgency and business deadline
- Current status
- Short description
- Detailed description
- Troubleshooting performed
- Resolution notes
- Root cause category
- Validation evidence
- Closure time

## Intake Guidance

Start by capturing the user's words, then translate them into technical details. For example, `I cannot get into my files` should become the exact share path, username, computer name, error message, and last known working time. Ask whether the issue affects one user, one computer, one location, or everyone. This difference drives priority. A single account lockout is usually P3 or P4, while multiple departments unable to access file shares can become P1.

## Work Notes

Use chronological work notes. Each note should include the time, action, result, and next step. Avoid vague statements such as `checked settings`; write the actual command or console path. Example: `10:15 - Ran gpresult /r on CLIENT01 as lab\jsmith. Mapped Drive Policy was denied due to security filtering.` This makes handoff easier and protects the team during audits.

## Resolution Standard

Do not close a ticket only because a command completed. Close it when the requester or a valid technical test confirms service has been restored. Record the final state and any follow-up action. If the issue was fixed by changing group membership, note that the user may need to sign out and back in to refresh tokens. If the issue was fixed by DNS cache clearing, note whether the server-side record was corrected.

## Example Markdown Structure

```markdown
## Ticket
ID:
Opened:
Requester:
Priority:
Status:

## Description

## Impact

## Troubleshooting

## Resolution

## Validation

## Closure Notes
```

## Quality Check

Before closure, confirm that the ticket includes enough information for reporting. The priority should match the matrix in [../README.md](../README.md). The resolution should name the exact action, not just the outcome. The root cause should use a consistent category such as account state, credentials, GPO scope, DNS record, DHCP lease, NTFS permissions, endpoint state, or user education. Consistent categories make monthly trend reviews useful.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `incident-template-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](../README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
