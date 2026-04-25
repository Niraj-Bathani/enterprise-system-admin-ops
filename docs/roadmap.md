# Roadmap

## Completed Core Projects

| Project | Status | Description |
|---|---|---|
| Active Directory build | Completed | Installed AD DS, promoted `DC01`, created OUs, users, groups, and account support runbooks. |
| Group Policy baseline | Completed | Documented password, lockout, USB restriction, mapped drive, and troubleshooting workflows. |
| DNS services | Completed | Installed DNS, created zones and records, and documented resolution troubleshooting. |
| DHCP services | Completed | Installed DHCP, created a lab scope and reservation, and documented lease troubleshooting. |
| File server | Completed | Built shared folder, permission model, mapped drive, and access denied resolution guides. |
| Basic automation | Completed | Added PowerShell scripts for user creation, password reset, inactive users, disk space, inventory, reports, and health checks. |
| Incident examples | Completed | Added four realistic incidents with diagnosis, root cause, fix, prevention, and lessons learned. |
| Ticketing workflow | Completed | Added priority matrix, templates, sample tickets, and escalation process. |

## Planned Advanced Projects

| Project | Status | Description |
|---|---|---|
| WSUS | Planned | Add Windows Server Update Services for centralized patch approval and reporting. |
| Azure AD Connect | Planned | Demonstrate hybrid identity synchronization concepts using a safe lab tenant where available. |
| MDT or deployment automation | Planned | Build a workstation imaging workflow with drivers, task sequences, and post-deployment domain join. |
| Intune | Planned | Add modern endpoint management policies, compliance checks, and application deployment. |
| LAPS or Windows LAPS | Planned | Manage local administrator passwords securely and document recovery workflow. |
| Certificate Services | Planned | Build AD CS basics for internal certificates, auto-enrollment, and certificate troubleshooting. |
| Monitoring dashboard | Planned | Send health check outputs to a dashboard or notification channel. |

## Execution Approach

Future work should keep the same standard used in the completed sections: step-by-step instructions, PowerShell where appropriate, validation from a client, troubleshooting, screenshot capture targets, and production notes. Advanced projects should be added only after the core services remain stable, because WSUS, Intune, and hybrid identity depend on reliable DNS, identity, and client management.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `roadmap-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [production-vs-lab.md](production-vs-lab.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
