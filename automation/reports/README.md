# Operational Reports

## Overview

This section provides reporting tools used to analyze user activity, account lockouts, and system hygiene within an Active Directory environment.

The purpose of these reports is not just to collect data, but to support operational decisions such as identifying inactive accounts, investigating lockouts, and maintaining directory health.

---

## What This Section Demonstrates

- Ability to transform raw data into actionable insights  
- Monitoring of user and system activity  
- Support for service desk troubleshooting and audits  
- Practical reporting aligned with real-world sysadmin workflows  

---

## Lab Context

Examples in this section use:

- Domain: `lab.local`  
- Domain Controller: `DC01 (192.168.100.10)`  
- Client: `CLIENT01 (192.168.100.20)`  
- Linux Server: `UBUNTU01 (192.168.100.30)`  

---

## Report Overview

- [last-logon-report.ps1](last-logon-report.ps1)  
  Classifies users as Active, Inactive, or NeverLoggedIn to support account review.

- [locked-accounts-report.ps1](locked-accounts-report.ps1)  
  Identifies locked accounts and highlights recent lockout activity.

- [stale-computers-report.ps1](stale-computers-report.ps1)  
  Detects unused computer objects for cleanup and security.

---

## Example Usage

```powershell
.\last-logon-report.ps1 -SearchBase 'OU=Users,DC=lab,DC=local'
.\locked-accounts-report.ps1
.\stale-computers-report.ps1 -DaysInactive 60