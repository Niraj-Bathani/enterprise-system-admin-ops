# PowerShell Cheatsheet

## Overview

This cheatsheet contains commonly used PowerShell commands for Windows system administration. It focuses on practical usage, not theory.

---

## Help and Discovery

```powershell
Get-Help Get-ADUser -Full
Get-Command -Module ActiveDirectory
Get-Member

Use these to understand commands, modules, and object properties.

Object Filtering and Output
Select-Object Name, SamAccountName
Where-Object { $_.Enabled -eq $true }
Sort-Object Name
Active Directory
Get Users
Get-ADUser -Filter *
Get-ADUser -Identity jsmith
Create User
New-ADUser -Name "John Smith" -SamAccountName jsmith
Modify User
Set-ADUser jsmith -Department IT
Disable / Unlock
Disable-ADAccount jsmith
Unlock-ADAccount jsmith
Group Management
Get-ADGroupMember "IT Team"
Add-ADGroupMember "IT Team" jsmith
Reporting
Get-ADUser -Filter * |
Export-Csv C:\Logs\users.csv -NoTypeInformation

Best practice:

Always export to CSV
Include timestamps in filenames
Remoting
Enter-PSSession -ComputerName DC01
Invoke-Command -ComputerName DC01 -ScriptBlock { Get-Service }
Test-WSMan
File and System Operations
Get-Service
Restart-Service Spooler
Get-Process
Stop-Process -Name notepad
Script Best Practices
Use [CmdletBinding()]
Validate parameters
Use try/catch
Log outputs
Avoid hard-coded credentials
Safe Execution
-WhatIf
-Confirm

Use these to preview changes before execution.

Real Usage Tips
Always test commands in a safe environment first
Use absolute paths in scripts
Validate output before making changes
Prefer automation over manual repetition
Summary

This cheatsheet provides quick access to essential PowerShell commands used in daily system administration tasks. It emphasizes efficiency, accuracy, and safe execution.