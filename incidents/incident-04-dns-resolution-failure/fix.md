# Incident 04 DNS Resolution Failure - Fix

## Resolution Objective

The fix restored service while preserving auditability. The administrator applied the smallest change that addressed the proven root cause: create the A record in the correct zone and flush client DNS cache. No broad permissions, domain-wide policy edits, or service restarts were used unless the diagnostic evidence showed they were required.

## Fix Procedure

1. Notify the requester that remediation is starting.
2. Start an elevated PowerShell transcript on `DC01`.
3. Run the fix command or GUI action: `Add-DnsServerResourceRecordA -ZoneName lab.local -Name fs01 -IPv4Address 192.168.100.40`.
4. Refresh the affected client state with `gpupdate /force`, sign out and sign back in, or clear the relevant cache.
5. Ask the requester to repeat the original action while the technician observes.
6. Confirm the related event logs no longer show the failure.
7. Update the ticket with the exact change, validation result, and resolution time.

## GUI Path

Use the matching Microsoft management console when a GUI audit screenshot is useful. For account issues, open Active Directory Users and Computers, locate the user, review the Account tab, and apply the account-specific action. For GPO issues, open Group Policy Management Console, confirm link and security filtering, then run Group Policy Results. For file access, open the folder's Advanced Security settings and review effective access.

## Validation

Validation must happen from the user's perspective. A domain admin test is not enough because administrators bypass many restrictions. Have the affected user sign in again, access the same application or share, and confirm normal work can continue. Capture the successful command output or console view after the lab run and store it in the incident evidence folder.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `incident-04-dns-resolution-failure-fix-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](../../ticketing-system/README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
