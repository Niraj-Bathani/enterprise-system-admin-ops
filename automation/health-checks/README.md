# Health Checks

## Overview

This section provides operational health checks for critical infrastructure components including domain controllers, DNS, and server uptime.

The goal is to detect issues early, before they impact users, and to provide repeatable checks that can be used in daily operations or weekly reviews.

---

## What This Section Demonstrates

- Proactive system monitoring and validation  
- Ability to identify service failures before user impact  
- Structured troubleshooting and verification workflow  
- Real-world operational runbooks used by system administrators  

---

## Lab Context

Examples in this section use:

- Domain: `lab.local`  
- Domain Controller: `DC01 (192.168.100.10)`  
- Client: `CLIENT01 (192.168.100.20)`  
- Linux Server: `UBUNTU01 (192.168.100.30)`  

---

## Recommended Order

Run these checks in sequence to isolate issues efficiently:

- [dc-health-check.ps1](dc-health-check.ps1)  
  Validates domain controller services, SYSVOL/NETLOGON shares, replication, and directory health.

- [dns-health-check.ps1](dns-health-check.ps1)  
  Verifies DNS service status and ensures critical records resolve correctly.

- [server-uptime-check.ps1](server-uptime-check.ps1)  
  Identifies unexpected restarts and system stability issues.

The order matters because many services depend on DNS and Active Directory. Resolving foundational issues first reduces troubleshooting complexity.

---

## Expected Output

Each script should provide:

- Clear pass/fail results  
- Service status information  
- Error messages when failures occur  
- A log file for audit or review  

Example:


Service: DNS Running
dcdiag: Passed
Replication: Healthy


---

## Example Usage

```powershell
.\dc-health-check.ps1 -DomainController DC01
.\dns-health-check.ps1 -DnsServer 192.168.100.10 -NamesToResolve lab.local,dc01.lab.local
Operating Standard

Health checks should:

Produce clear, readable output
Write logs for traceability
Be repeatable and safe to run regularly

Before making any changes:

Record current configuration
Capture PowerShell output
Take screenshots for GUI actions

All evidence should be stored in the screenshots/ directory and referenced in documentation.

Validation Pattern

Every check follows this process:

Verify server-side configuration
Test from a client system
Review event logs if needed
Document the result

This ensures changes are validated from both administrative and user perspectives.

Troubleshooting Approach

When a failure occurs, validate in this order:

Identity (user/account)
Network connectivity
DNS resolution
Time synchronization
Permissions
Group Policy
Service status

Avoid making multiple changes at once. Use logs and error messages to guide decisions.

Production Notes

In a production environment:

Changes require approval and peer review
Test changes in a pilot environment first
Schedule work during maintenance windows
Communicate with the service desk before and after changes
Always prepare rollback steps

Summary

This section demonstrates how to move from reactive troubleshooting to proactive system monitoring. The scripts and validation steps reflect real-world administrative workflows used to maintain system reliability.