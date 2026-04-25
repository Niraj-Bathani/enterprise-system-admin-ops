# Escalation Workflow

## Objective

Define when and how tickets move from service desk to Windows operations, network operations, security, or management. Escalation is not failure; it is a control that gets the right expertise involved before the user impact grows.

## Functional Escalation

Escalate to Windows operations when the ticket involves domain controller health, GPO design, DNS/DHCP service state, file server permissions beyond standard group membership, or script failures. Escalate to network operations when connectivity, VLAN, firewall, or routing evidence points outside the server. Escalate to security when there is suspicious authentication behavior, unexpected privilege, data exposure, or malware indicators.

## Hierarchical Escalation

Escalate to management when SLA targets are at risk, a P1 or P2 incident affects business operations, a change requires approval, or user communication must be coordinated. The escalation note should include impact, timeline, current evidence, actions taken, owner, and next decision needed.

## Required Handoff Detail

A handoff should include the ticket ID, user, asset, exact error, timestamps, commands run, output summary, screenshots after lab execution, and the reason for escalation. Do not send only `please check`; that makes the next tier repeat basic work.

## Closure After Escalation

The original ticket owner remains responsible for user communication unless ownership is formally transferred. After the escalated team resolves the issue, the service desk validates with the requester and updates the final closure notes.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `escalation-workflow-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
