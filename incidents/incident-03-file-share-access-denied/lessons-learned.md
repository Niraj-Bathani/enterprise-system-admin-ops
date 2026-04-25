# Incident 03 File Share Access Denied - Lessons Learned

## What Went Well

The incident was handled effectively because the team followed a repeatable diagnostic path and recorded evidence before applying changes. The technician did not assume the first visible symptom was the root cause. Communication stayed clear: the requester received updates, the ticket captured the actions, and the validation was performed from the affected user's point of view.

## What Can Improve

The main improvement is earlier detection. Access requests should reference the approved group name, not only the department name. A small monitoring rule or scheduled report would have shortened the time between the first failed event and the support response. The team should also improve knowledge base linking so that common fixes are not rediscovered by each shift.

## Runbook Updates

Update the relevant operational guide and link it from the ticket. If the incident involved identity, reference [Active Directory procedures](../../manual-configurations/active-directory/README.md). If it involved policy, reference [Group Policy procedures](../../manual-configurations/group-policy/README.md). If it involved access, reference [File Server procedures](../../manual-configurations/file-server/README.md). If it involved name resolution, reference [DNS and DHCP procedures](../../manual-configurations/dns-dhcp/README.md).

## Follow-Up Actions

Create a follow-up task for prevention, assign an owner, set a due date, and review completion at the next operations meeting. A lesson learned is only valuable if it changes behavior. In the lab, repeat the incident after remediation to confirm the detection and documentation are useful to another technician who did not work the original ticket.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `incident-03-file-share-access-denied-lessons-learned-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](../../ticketing-system/README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
