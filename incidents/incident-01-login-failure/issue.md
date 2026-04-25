# Incident 01 Login Failure - Issue Report

## Incident Summary

On 2026-04-25 09:00, John Smith from Sales reported that user `jsmith` could not log in after vacation. The priority was classified as P2 because the user or service was blocked from normal work but the wider business remained operational. The affected environment was `lab.local`, with primary investigation on `DC01` and client validation from `CLIENT01`. The visible error was: `The referenced account is currently locked out.`.

## Business Impact

The immediate impact was loss of productivity for the affected user group and increased service desk volume. The symptom was simple from the user's perspective, but it touched identity, workstation state, policy refresh, and audit logging. The ticket was opened with enough detail to avoid repeated questions: username, computer name, last successful sign-in time, exact error text, network location, and whether the issue followed the user to another computer.

## Initial Triage

The service desk confirmed the user was on the corporate network, had not recently changed departments, and was using the expected domain sign-in format. The technician checked whether the problem occurred in a browser, in Windows sign-in, or only when accessing a specific network resource. That distinction matters because a Windows logon failure points toward AD, Kerberos, account state, workstation trust, or password status, while a file-share-only failure points toward group membership or ACLs.

## Evidence To Collect

Record the ticket number, reporter, affected asset, error message, and timestamps. Capture screenshots only after reproducing the failure in the lab. Useful evidence includes Event Viewer entries, ADUC account properties, `gpresult /r`, `ipconfig /all`, `whoami /groups`, or `Resolve-DnsName lab.local`, depending on the symptom. Evidence should be attached to the ticket and referenced in the final resolution notes.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `incident-01-login-failure-issue-report-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](../../ticketing-system/README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
