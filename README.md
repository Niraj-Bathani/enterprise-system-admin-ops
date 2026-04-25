# Enterprise System Admin Operations – Portfolio

## Overview

This repository is a production-style Windows system administration portfolio built from a safe lab environment. It demonstrates the daily work expected from an enterprise administrator: Active Directory identity operations, Group Policy control, DNS and DHCP services, file server permissions, PowerShell automation, scheduled reporting, incident response, ticket handling, backup validation, patch operations, and Windows/Linux interoperability. The examples use realistic but non-production values such as `lab.local`, `192.168.100.10`, `CLIENT01`, and `jsmith`.

## Lab Environment

| Role | Operating system | Hostname | IP address | Network |
|---|---|---:|---:|---|
| Domain Controller | Windows Server 2022 | DC01 | 192.168.100.10 | Host-only plus NAT |
| Client Workstation | Windows 10 or Windows 11 | CLIENT01 | 192.168.100.20 | Host-only plus NAT |
| Linux Server | Ubuntu Server 22.04 | UBUNTU01 | 192.168.100.30 | Host-only plus NAT |

All virtual machines are connected to a host-only network for lab service traffic and NAT for internet access. `DC01` provides Active Directory, DNS, and DHCP. `CLIENT01` validates user experience, domain sign-in, policy processing, mapped drives, and service desk incidents. `UBUNTU01` validates cross-platform administration through SSH and Samba file sharing.

## Skills Matrix

| Skill | Repository evidence |
|---|---|
| Active Directory | Domain controller build, OU design, users, groups, account recovery, lifecycle offboarding |
| Group Policy | Password policy, lockout policy, USB restriction, mapped drives, gpupdate troubleshooting |
| DNS | DNS role installation, forward lookup zones, A records, name-resolution troubleshooting |
| DHCP | Scope creation, reservations, lease validation, client troubleshooting |
| File Server | Shared folders, NTFS and share permissions, department access model, mapped drives |
| PowerShell | User automation, reports, health checks, scheduled task runbooks, logging and validation |
| Incident Response | Four complete incident records with issue, diagnosis, root cause, fix, prevention, and lessons learned |
| Ticketing | ITIL-lite priority matrix, templates, sample tickets, escalation workflow |
| Cross-platform | Samba share, SSH key administration, Windows-to-Linux validation |

## Navigation

- [manual-configurations/active-directory](manual-configurations/active-directory/README.md) explains AD DS installation, promotion, OU design, user/group creation, client domain join, password recovery, and disabled-user handling.
- [manual-configurations/group-policy](manual-configurations/group-policy/README.md) covers password policy, lockout policy, USB control, mapped drives, and policy troubleshooting.
- [manual-configurations/dns-dhcp](manual-configurations/dns-dhcp/README.md) builds DNS and DHCP from the server role level through client validation.
- [manual-configurations/file-server](manual-configurations/file-server/README.md) documents share creation, NTFS versus share permissions, department shares, drive mapping, and access denied fixes.
- [manual-configurations/patching](manual-configurations/patching/README.md) provides a monthly patching checklist, validation approach, and failed update remediation.
- [manual-configurations/backup-operations](manual-configurations/backup-operations/README.md) documents backup planning, daily checks, and restore testing.
- [automation/powershell](automation/powershell/README.md) contains operational scripts for account management, inventory, disk reporting, and inactive-user cleanup.
- [automation/reports](automation/reports/README.md) contains scheduled reporting scripts for logon, locked account, and stale computer review.
- [automation/health-checks](automation/health-checks/README.md) contains health checks for domain controllers, DNS, and server uptime.
- [automation/scheduled-tasks](automation/scheduled-tasks/README.md) documents how to schedule recurring cleanup and weekly reports.
- [incidents](incidents/incident-01-login-failure/issue.md) contains incident examples written in a service desk and operations style.
- [ticketing-system](ticketing-system/README.md) contains ticket templates, sample tickets, and escalation guidance.
- [cross-platform](cross-platform/README.md) documents Linux and Windows interoperability.
- [docs](docs/windows-admin-cheatsheet.md) contains cheat sheets, troubleshooting guidance, interview preparation, production comparison, and roadmap.

## How To Use This Repository

Build the lab in the order shown in the navigation. Start with Active Directory, then Group Policy, DNS/DHCP, file services, automation, incidents, ticketing, and cross-platform validation. Run scripts only inside the lab until you understand their parameters and output. Replace screenshot image targets with real captures after each lab execution. Keep command transcripts and screenshots as evidence, because the portfolio is stronger when it shows the result rather than only the intention.

PowerShell examples assume an elevated session and an authorized domain administrator account. No script contains stored credentials. Where a command needs a domain, IP address, username, or OU, use the lab values first and then adapt them to your own isolated environment. In production, place all changes behind change control, peer review, monitoring, and rollback planning.
