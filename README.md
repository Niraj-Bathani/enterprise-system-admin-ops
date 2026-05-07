# Enterprise System Admin Operations – Portfolio

## Overview

This repository is a production-style Windows system administration portfolio built in a controlled enterprise lab environment.

It demonstrates practical enterprise administration workflows including:

- Active Directory administration
- Group Policy management
- DNS and DHCP services
- File server configuration and permissions
- PowerShell automation
- Incident response and troubleshooting
- Ticket handling and operational documentation
- Cross-platform Windows/Linux integration

The project focuses on operational realism, evidence-driven troubleshooting, and enterprise-style documentation standards rather than theoretical walkthroughs.

---

## Key Highlights

- Built and managed a Windows Server 2022 Active Directory environment
- Configured DNS and DHCP infrastructure services
- Implemented Group Policy for password enforcement, device restrictions, and mapped drives
- Configured NTFS and SMB share permissions using security-group-based access control
- Developed PowerShell automation for reporting, user management, and operational tasks
- Documented enterprise-style incidents with diagnosis, remediation, root cause analysis, and prevention guidance
- Simulated IT operations workflows with ticketing procedures and escalation processes
- Performed client-side validation from standard-user workstations

---

## Lab Environment

| Role | Purpose | Operating System | Hostname | IP Address |
|---|---|---|---|---|
| Domain Controller | Active Directory, DNS, DHCP | Windows Server 2022 | DC01 | 192.168.100.10 |
| Client Workstation | User validation and testing | Windows 10/11 | CLIENT01 | 192.168.100.20 |
| File Server | SMB shares and NTFS permissions | Windows Server 2022 | FS01 | 192.168.100.40 |
| Linux Server | SSH and Samba integration | Ubuntu Server 22.04 | UBUNTU01 | 192.168.100.30 |

### Environment Details

- Domain: `lab.local`
- Network Range: `192.168.100.0/24`
- Network Type: Host-only + NAT
- Administrative Validation:
  - RSAT
  - PowerShell
  - Event Viewer
  - Group Policy Management
  - DNS Manager
  - Active Directory Users and Computers

All systems operate in an isolated lab environment designed to simulate enterprise administration and operational troubleshooting workflows safely.

---

## Repository Structure

```text
manual-configurations/
├── active-directory/
├── group-policy/
├── dns-dhcp/
└── file-server/

automation/
├── powershell/
├── reports/
├── health-checks/
└── scheduled-tasks/

incidents/
├── incident-01-login-failure/
├── incident-02-gpo-not-applying/
├── incident-03-file-share-access-denied/
└── incident-04-dns-resolution-failure/

ticketing-system/
screenshots/
docs/
cross-platform/
```

---

## Skills Matrix

| Area | Repository Evidence |
|---|---|
| Active Directory | OU design, user lifecycle management, group administration, account recovery |
| Group Policy | Password policies, mapped drives, USB restrictions, policy troubleshooting |
| DNS | Forward lookup zones, A records, DNS troubleshooting, client resolution validation |
| DHCP | Scope configuration, reservations, lease validation |
| File Server | NTFS permissions, SMB share permissions, department-based access models |
| PowerShell | User automation, reporting, health checks, operational scripting |
| Incident Response | Diagnosis, remediation, root cause analysis, prevention documentation |
| Ticketing | ITIL-style ticket workflows and escalation procedures |
| Cross-platform Integration | Samba, SSH, Linux-Windows interoperability |

---

## Operational Methodology

This repository follows enterprise operational practices including:

- Least privilege administration
- Evidence-first troubleshooting
- Root cause analysis
- Controlled remediation workflows
- Standard-user validation
- Operational documentation standards
- Change verification procedures
- Rollback awareness and validation

All incident documentation follows a repeatable operational structure:

1. Issue Report
2. Diagnosis
3. Root Cause Analysis
4. Fix / Remediation
5. Lessons Learned
6. Prevention

---

## Technologies

### Microsoft Infrastructure

- Windows Server 2022
- Active Directory Domain Services
- Group Policy
- DNS
- DHCP
- SMB File Services
- NTFS Permissions
- RSAT
- Event Viewer

### Automation & Administration

- PowerShell
- PowerShell Remoting
- Scheduled Tasks
- Windows Administrative Tools

### Cross-platform

- Ubuntu Server 22.04
- Samba
- OpenSSH

### Virtualization

- VMware / VirtualBox
- Host-only Networking
- NAT Networking

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

## Proof Of Work

All configurations, scripts, troubleshooting procedures, and incident workflows in this repository were implemented and tested in a live lab environment.

Evidence includes:

- Real PowerShell execution output
- Active Directory administrative validation
- Group Policy testing
- DNS and DHCP validation
- File permission testing
- Event Viewer investigations
- Incident response documentation
- Client-side verification from standard-user workstations

All screenshots included in this repository were captured during live lab execution and validation.

---

## How To Use This Repository

Follow the implementation order defined in the navigation section, beginning with:

1. Active Directory
2. DNS and DHCP
3. Group Policy
4. File Services
5. Automation
6. Incident Response

Each section builds on previous infrastructure components to simulate enterprise operational dependencies.

PowerShell examples assume:
- Elevated administrative privileges
- Domain connectivity
- Windows Server administrative tools installed

Replace lab-specific values as needed for your own environment.

---

## Scope

This repository focuses on core enterprise Windows administration and operational troubleshooting within a controlled lab environment.

Included areas:

- Identity management
- Infrastructure services
- File services
- Policy management
- Automation
- Operational troubleshooting
- Incident response documentation

Excluded areas:

- Cloud infrastructure
- Container orchestration
- Enterprise SIEM deployment
- Production-scale monitoring platforms

---

## Notes

In production environments, all administrative changes would be performed under:

- Change management
- Peer review
- Monitoring and alerting
- Maintenance windows
- Rollback procedures
- Operational validation requirements

This lab environment is designed to safely replicate real-world enterprise administration and troubleshooting workflows.
