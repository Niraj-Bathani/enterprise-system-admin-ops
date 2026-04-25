# Production Versus Lab

## Comparison

| Area | Lab practice | Production practice | How it scales |
|---|---|---|---|
| Backup frequency | Daily or weekly test backups | Policy-driven backups based on RPO | Increase frequency and retention by criticality |
| Change control | Personal notes and markdown | Formal approval, peer review, maintenance windows | Convert runbooks into change templates |
| Monitoring | Manual checks and scripts | Central monitoring with alert routing | Scripts feed dashboards or ticket creation |
| SLA | Best-effort practice | Contracted response and resolution targets | Priority matrix maps to support teams |
| Uptime | Reboots when convenient | Coordinated rolling maintenance | Sequence servers and communicate impact |
| Documentation | Repository markdown | Knowledge base with ownership and review dates | Markdown becomes controlled operational docs |
| Testing | Single-client validation | Pilot groups, staging, and rollback tests | Expand OU scope gradually |

## Scaling Explanation

The lab intentionally uses a small number of systems so the administrator can see cause and effect clearly. Production adds risk because more users, dependencies, compliance requirements, and integrations are involved. A command such as `Set-ADDefaultDomainPasswordPolicy` is technically simple, but production use requires communication, testing, exception handling, and help desk readiness.

## Backup And Restore

In the lab, a weekly system state backup may be enough to practice recovery. In production, backup frequency follows business recovery point objectives. File servers may need hourly snapshots, domain controllers may need system state protection, and critical applications may need application-aware backups. Restore testing must be scheduled because backup success alone does not prove recoverability.

## Monitoring And SLA

Manual health checks are useful for learning, but production services need automated monitoring. DNS, DHCP, replication, disk space, failed backups, and account lockout patterns should alert before users report widespread impact. SLA targets then determine response urgency and escalation.

## Documentation Discipline

The same markdown guides can become production knowledge base articles if owners, review dates, and approval records are added. Commands should be parameterized for production naming standards, and screenshots should come from the real environment only where policy allows.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `production-versus-lab-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [roadmap.md](roadmap.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
