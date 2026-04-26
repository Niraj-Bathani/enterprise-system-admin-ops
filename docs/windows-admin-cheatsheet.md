# Windows Admin Cheatsheet

## Overview

This cheatsheet contains commonly used commands and checks for Windows system administration. It is designed for quick reference during troubleshooting and daily operations.

---

## What This Demonstrates

- Practical system administration skills  
- Efficient troubleshooting using built-in tools  
- Real-world command usage  

---

## Identity (Active Directory)

```powershell
Get-ADUser jsmith -Properties *
Search-ADAccount -LockedOut
Unlock-ADAccount jsmith
Get-ADPrincipalGroupMembership jsmith

Key note:

Users must log out and back in after group changes (Kerberos token refresh)
Domain Controller Health
dcdiag /q
repadmin /replsummary
Get-Service DNS,NTDS,Netlogon,Kdc
Get-SmbShare SYSVOL,NETLOGON

Important:

Missing SYSVOL → GPO will fail
DNS and DHCP
Resolve-DnsName lab.local -Server 192.168.100.10
Get-DnsServerResourceRecord
Test-NetConnection DC01 -Port 53
ipconfig /flushdns
ipconfig /renew
Get-DhcpServerv4Scope
Get-DhcpServerv4Lease

Key note:

Incorrect DNS = most common domain issue
File Services
Get-SmbShare
Get-SmbShareAccess
icacls C:\Folder
whoami /groups

Important:

Effective access = Share + NTFS
Avoid direct user permissions
Event Logs
Get-WinEvent

Common Event IDs:

4740 → Account lockout
4625 → Failed logon
4771 → Kerberos failure
GroupPolicy → Operational log
Real Usage Tips
Always verify before changing configuration
Use logs instead of guessing
Validate from client perspective
Keep commands simple and repeatable
Summary

This cheatsheet provides quick access to essential commands used in daily Windows system administration. It emphasizes efficiency, accuracy, and structured troubleshooting.