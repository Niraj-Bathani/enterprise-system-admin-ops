# Ticketing System

## Philosophy

This repository uses an ITIL-lite ticketing model. The goal is practical operational control, not bureaucracy. Every ticket should explain who is affected, what is broken or requested, how urgent it is, what was done, how it was validated, and what should happen next. Good tickets protect the user, the technician, and the business because work can be reviewed and transferred without losing context.

## Priority Matrix

| Priority | Impact | Response target | Resolution target |
|---|---|---:|---:|
| P1 | Critical service outage or many users blocked | 15 minutes | 4 hours or active bridge |
| P2 | Department or VIP blocked, no easy workaround | 30 minutes | 1 business day |
| P3 | Single user impaired, workaround available | 4 business hours | 3 business days |
| P4 | Standard request or information | 1 business day | 5 business days |

Priority is based on impact and urgency together. A password reset for one user is not automatically P1, but the same symptom affecting all users after a domain controller failure could be P1.

## Tracking Method

Tickets can be tracked in GitHub Issues for a portfolio lab or in a service management platform in production. Use labels for category, priority, service, and status. Link tickets to runbooks such as [../manual-configurations/active-directory/README.md](../manual-configurations/active-directory/README.md) and to incident records when a ticket becomes an incident.

## Templates And Samples

Use [ticket-templates/incident-template.md](ticket-templates/incident-template.md), [ticket-templates/service-request-template.md](ticket-templates/service-request-template.md), and [ticket-templates/change-request-template.md](ticket-templates/change-request-template.md). Review sample tickets for [TKT-001 unlock account](sample-tickets/TKT-001-unlock-account.md), [TKT-002 share permission](sample-tickets/TKT-002-share-permission.md), and [TKT-003 onboarding](sample-tickets/TKT-003-new-user-onboarding.md).

## Closure Rules

A ticket can be closed only after validation. The technician should state the exact fix, the proof, and the user confirmation or technical test. If the work creates a follow-up risk, create a separate task rather than hiding it in closure notes.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `ticketing-system-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [escalation-workflow.md](escalation-workflow.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
