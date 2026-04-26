# PowerShell Automation

## Overview

This section contains PowerShell scripts used to automate common Windows administration tasks such as user management, reporting, and system monitoring.

The scripts are designed to reflect real enterprise practices, including validation, logging, error handling, and safe execution using `-WhatIf`.

---

## What This Section Demonstrates

- Automation of repetitive administrative tasks
- Safe execution using `ShouldProcess` and `-WhatIf`
- Input validation and error handling
- Logging and reporting for operational visibility
- Practical scripting aligned with real sysadmin workflows

---

## Lab Context

Examples in this section use:

- Domain: `lab.local`  
- Domain Controller: `DC01 (192.168.100.10)`  
- Client: `CLIENT01 (192.168.100.20)`  
- Linux Server: `UBUNTU01 (192.168.100.30)`  

---

## Script Overview

- [bulk-user-create.ps1](bulk-user-create.ps1)  
  Creates Active Directory users from a CSV file with validation and logging.

- [reset-password.ps1](reset-password.ps1)  
  Resets user passwords and optionally unlocks accounts.

- [disable-inactive-users.ps1](disable-inactive-users.ps1)  
  Identifies and disables inactive accounts with reporting.

- [disk-space-report.ps1](disk-space-report.ps1)  
  Collects disk usage data and flags low space conditions.

- [installed-software-report.ps1](installed-software-report.ps1)  
  Safely inventories installed applications without triggering repairs.

---

## Example Usage

```powershell
.\bulk-user-create.ps1 -CsvPath .\users.csv -DomainName lab.local -UserBaseOu 'OU=Users,DC=lab,DC=local' -WhatIf
.\disable-inactive-users.ps1 -DaysInactive 90 -SearchBase 'OU=Users,DC=lab,DC=local'
.\disk-space-report.ps1 -ComputerName DC01,FS01