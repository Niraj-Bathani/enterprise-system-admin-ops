# Incident 02 GPO Not Applying - Root Cause

## Root Cause Statement

The root cause was the mapped drive GPO was linked to the Workstations OU instead of the Sales Users OU and security filtering excluded Authenticated Users without adding the Sales group. The immediate symptom was the Sales mapped drive GPO did not apply to several users, but the durable cause was a mismatch between the expected configuration and the actual state of the account, workstation, policy, or service. The incident was not closed until the team could explain why the symptom appeared at that time and why it affected the specific user or system.

## Contributing Factors

Several common enterprise factors can make this type of incident harder to diagnose. Cached credentials can continue to submit an old password. Group Policy can be linked to the wrong OU or blocked by security filtering. DNS caches can keep resolving a stale address. File access can be allowed at the share layer but denied at NTFS, or the reverse. A clear root cause separates the final triggering event from these background conditions.

## Proof

The proof came from the diagnostic evidence: GPMC showed the link on the wrong OU and `gpresult` showed the GPO was not in the user's applied or denied list. The event ID, command output, and client-side reproduction were consistent with the same explanation. No fix was considered permanent until the error stopped recurring after a fresh sign-in or a forced policy refresh. In production, this proof would be attached to the ticket with timestamps and administrator initials.

## What Was Ruled Out

The team ruled out broad domain controller outage by verifying `nltest /dsgetdc:lab.local`. Name resolution was checked with `Resolve-DnsName lab.local`. Network connectivity was checked with `Test-NetConnection DC01 -Port 389` for LDAP and, when relevant, `Test-NetConnection FS01 -Port 445` for SMB. The user was tested from a known-good client where appropriate. These exclusions are important because they prevent the incident record from becoming a guess.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `incident-02-gpo-not-applying-root-cause-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](../../ticketing-system/README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
