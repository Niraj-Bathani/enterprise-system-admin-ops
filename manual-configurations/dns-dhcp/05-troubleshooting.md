# DNS And DHCP Troubleshooting

## Objective

Diagnose and resolve common DNS and DHCP issues in the `lab.local` environment.

---

# Why It Matters

DNS and DHCP problems commonly appear as domain login failures, application connectivity issues, Group Policy failures, or network access problems.

This lab environment uses:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller, DNS, DHCP | 192.168.100.10 |
| CLIENT01 | Windows Client | DHCP |
| FS01 | File Server | 192.168.100.40 |

Network:

```text
192.168.100.0/24
```

Domain:

```text
lab.local
```

---

# Prerequisites

Before starting:

- DNS Server role installed
- DHCP Server role installed
- DHCP scope configured
- PowerShell running as Administrator

Verify DNS service:

```powershell
Get-Service DNS
```

Verify DHCP service:

```powershell
Get-Service DHCPServer
```

---

# GUI Troubleshooting Procedure

1. Open:

```text
Server Manager
→ Tools
→ DNS
```

2. Verify:
- Forward lookup zone exists
- A records exist
- DNS service is running

3. Open:

```text
Server Manager
→ Tools
→ DHCP
```

4. Verify:
- DHCP server is authorized
- IPv4 scope is active
- Address leases exist

5. On `CLIENT01`, verify:
- correct IP address
- correct DNS server
- successful domain connectivity

---

# PowerShell Troubleshooting Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\dns-and-dhcp-troubleshooting.txt -Append
```

Review client configuration:

```powershell
ipconfig /all
```

Test DNS resolution:

```powershell
Resolve-DnsName lab.local -Server 192.168.100.10
```

Review DHCP leases:

```powershell
Get-DhcpServerv4Lease -ScopeId 192.168.100.0
```

Review recent DHCP events:

```powershell
Get-EventLog -LogName System -Source "Microsoft-Windows-DHCP-Server" -Newest 20
```

Stop logging:

```powershell
Stop-Transcript
```

---

# Verification

## Verify DNS Connectivity

Run:

```powershell
Test-NetConnection 192.168.100.10 -Port 53
```

Expected result:

```text
TcpTestSucceeded : True
```

---

## Verify DHCP Connectivity

Run:

```powershell
Test-NetConnection 192.168.100.10 -Port 67
```

Expected result:

```text
TcpTestSucceeded : True
```

---

## Verify Client Configuration

On `CLIENT01`, run:

```powershell
ipconfig /all
```

Confirm:
- valid IP address assigned
- DNS server is `192.168.100.10`
- DHCP enabled is `Yes`

---

## Verify Name Resolution

Run:

```powershell
Resolve-DnsName fs01.lab.local
```

Expected result:

```text
192.168.100.40
```

---

# Common Issues And Fixes

## Client Receives APIPA Address

Renew the DHCP lease:

```powershell
ipconfig /release
ipconfig /renew
```

Verify DHCP service:

```powershell
Get-Service DHCPServer
```

---

## Incorrect DNS Server Assigned

Verify DHCP option values:

```powershell
Get-DhcpServerv4OptionValue -ScopeId 192.168.100.0
```

Confirm DNS server:

```text
192.168.100.10
```

---

## DNS Resolution Failure

Flush client DNS cache:

```powershell
ipconfig /flushdns
```

Retest resolution:

```powershell
Resolve-DnsName lab.local
```

---

## DHCP Scope Exhausted

Review leases:

```powershell
Get-DhcpServerv4Lease -ScopeId 192.168.100.0
```

Expand the scope or remove unused leases if necessary.

---

## DNS Service Not Running

Start DNS service:

```powershell
Start-Service DNS
```

Verify status:

```powershell
Get-Service DNS
```
