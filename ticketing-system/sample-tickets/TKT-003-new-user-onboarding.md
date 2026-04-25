# TKT-003 - New User Onboarding

## Ticket Metadata

- **Opened:** 2026-04-25 09:10
- **Requester:** HR Operations
- **Affected environment:** `lab.local`
- **Priority:** P4
- **Status:** Resolved
- **Assigned team:** Service Desk / Windows Operations
- **Resolution time:** 45 minutes

## Description

HR requested a new Sales user account for Priya Shah with access to standard Sales resources before start of business Monday. The requester provided the affected username, workstation name, and exact time of failure. The service desk confirmed that the user was connected to the lab network and that no planned maintenance window was active. The ticket was logged using the incident template in [../ticket-templates/incident-template.md](../ticket-templates/incident-template.md) so the diagnostic notes stayed consistent.

## Impact

The issue affected one user and did not appear to affect the entire department. The impact was still operationally important because the requester could not complete normal work. Priority was selected using the matrix in [../README.md](../README.md): single-user interruption, no broad outage, and a clear workaround path through service desk intervention.

## Troubleshooting Performed

Verified request approval, confirmed department, manager, username format, required groups, mailbox handoff outside this lab scope, and workstation assignment. Checked that `pshah` did not already exist.

The technician recorded exact command output and timestamps in the work notes. No unrelated changes were made while troubleshooting. This kept the resolution easy to audit and prevented a small service request from turning into an undocumented configuration change.

## Resolution

Created `pshah` in `OU=Sales,OU=Users,DC=lab,DC=local`, set a temporary password with change required at logon, added `GG_Sales_Users` and `GG_Sales_Share_Modify`, and validated group membership.

The requester repeated the original task successfully while the technician remained on the ticket. The technician then updated the closure notes with the action taken, validation method, and any user guidance. Where the fix depended on group membership or credential refresh, the user was asked to sign out and sign back in to receive a new Kerberos token.

## Root Cause

Standard onboarding request completed according to the access matrix.

## Closure Notes

The ticket was closed as resolved after validation. The incident did not require a formal problem record because the scope was limited and the root cause was understood. If two or more similar tickets are opened in the same week, the service desk lead should review the pattern and consider a knowledge base update, user communication, or monitoring rule.

## Evidence

Attach screenshots after the lab execution. Suggested evidence includes command output, ADUC account state, share permissions, or the completed onboarding checklist. Do not use mock screenshots; real lab evidence is part of the portfolio value.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `new-user-onboarding-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](../README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
