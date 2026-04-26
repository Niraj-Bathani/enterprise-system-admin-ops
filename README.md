# Enterprise System Admin Operations – Portfolio

## Overview

This repository is a production-style Windows system administration portfolio built from a safe lab environment.

It demonstrates real enterprise administration tasks including Active Directory identity management, Group Policy control, DNS and DHCP services, file server permissions, PowerShell automation, incident response, ticket handling, and cross-platform integration.

---

## Key Highlights

- Built a fully functional Active Directory lab with domain controller, DNS, DHCP, and client integration
- Implemented Group Policy for password enforcement, device restrictions, and drive mapping
- Configured file server with NTFS and share permission models for department-based access
- Developed PowerShell automation for user lifecycle management and system reporting
- Documented real incident scenarios with root cause analysis and resolution steps
- Simulated service desk workflows with ticket templates and escalation processes

---

## Lab Environment

| Role | Purpose | Operating System | Hostname | IP Address | Network |
|------|---------|------------------|----------|------------|---------|
| Domain Controller | Identity, DNS, DHCP | Windows Server 2022 | DC01 | 192.168.100.10 | Host-only + NAT |
| Client Workstation | User validation and testing | Windows 10/11 | CLIENT01 | 192.168.100.20 | Host-only + NAT |
| Linux Server | Cross-platform services (SSH, Samba) | Ubuntu Server 22.04 | UBUNTU01 | 192.168.100.30 | Host-only + NAT |

All virtual machines operate on a host-only network for internal communication and NAT for internet access.  
`DC01` provides Active Directory, DNS, and DHCP services.  
`CLIENT01` validates user experience, domain authentication, policy enforcement, and access control.  
`UBUNTU01` enables Linux integration through SSH and Samba.

---

## Skills Matrix

| Skill | Repository Evidence |
|------|---------------------|
| Active Directory | Domain controller setup, OU structure, user/group management, account recovery, user lifecycle |
| Group Policy | Password policies, device restrictions, mapped drives, policy troubleshooting |
| DNS | Role installation, forward lookup zones, A records, resolution troubleshooting |
| DHCP | Scope configuration, reservations, lease validation, client troubleshooting |
| File Server | Shared folders, NTFS vs share permissions, department-based access model |
| PowerShell | Automated user lifecycle, disk usage reporting, system health checks, scheduled scripts |
| Incident Response | Documented incidents with diagnosis, root cause, fix, and prevention |
| Ticketing | ITIL-style ticket templates, sample tickets, escalation workflow |
| Cross-platform | Samba file sharing, SSH access, Linux-Windows integration |

---

## Navigation

### Core Infrastructure
- [Active Directory](manual-configurations/active-directory/README.md)
- [Group Policy](manual-configurations/group-policy/README.md)
- [DNS & DHCP](manual-configurations/dns-dhcp/README.md)
- [File Server](manual-configurations/file-server/README.md)

### Operations & Automation
- [PowerShell Scripts](automation/powershell/README.md)
- [Reports](automation/reports/README.md)
- [Health Checks](automation/health-checks/README.md)
- [Scheduled Tasks](automation/scheduled-tasks/README.md)

### Support & Troubleshooting
- [Incidents](incidents/incident-01-login-failure/issue.md)
- [Ticketing System](ticketing-system/README.md)

### Additional Components
- [Cross-platform Integration](cross-platform/README.md)
- [Documentation](docs/windows-admin-cheatsheet.md)

---

## How To Use This Repository

Follow the implementation order defined in the navigation, starting with Active Directory and progressing through Group Policy, DNS/DHCP, file services, and automation. Each section builds on previous components to simulate a real enterprise environment.

Run all scripts within the lab environment before modifying them. Capture screenshots and command outputs during execution, as this repository emphasizes proof of implementation rather than theoretical documentation.

PowerShell examples assume an elevated session with appropriate administrative privileges. No credentials are stored in scripts. Replace lab-specific values (domain names, IPs, usernames) as needed for your own environment.

---

## Proof of Work

All configurations, scripts, and troubleshooting scenarios in this repository were implemented and tested in a local virtual lab environment. Screenshots and outputs represent real execution, not simulated examples.

---

## Scope

This repository focuses on core system administration tasks within a controlled lab environment. It does not include cloud infrastructure, container orchestration, or large-scale enterprise monitoring systems.

---

## Notes

In production environments, all changes would be performed under change management, peer review, monitoring, and rollback procedures. This lab is designed to safely replicate real-world administrative workflows and troubleshooting scenarios.