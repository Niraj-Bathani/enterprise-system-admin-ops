# Install DHCP Role

## Objective

Install and authorize the DHCP Server role on `DC01`.

---

# Why It Matters

DHCP automatically assigns IP configuration to client systems and helps maintain consistent network settings across the environment.

This lab environment uses:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller and DHCP Server | 192.168.100.10 |
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

- Static IP configured on `DC01`
- DNS role installed
- Domain Controller operational
- PowerShell running as Administrator

Verify current server configuration:

```powershell
ipconfig /all
```

Verify installed roles:

```powershell
Get-WindowsFeature DHCP
```

---

# GUI Procedure

1. Open:

```text
Server Manager
```

2. Select:

```text
Manage
→ Add Roles and Features
```

3. Choose:

```text
DHCP Server
```

4. Install required management tools.

5. Complete installation.

6. After installation, select:

```text
Complete DHCP configuration
```

7. Authorize the DHCP server in Active Directory.

---

# PowerShell Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\install-dhcp-role.txt -Append
```

Install DHCP role:

```powershell
Install-WindowsFeature -Name DHCP -IncludeManagementTools
```

Authorize DHCP server:

```powershell
Add-DhcpServerInDC -DnsName "dc01.lab.local" -IPAddress 192.168.100.10
```

Stop logging:

```powershell
Stop-Transcript
```

---

# Verification

## Verify DHCP Service

Run:

```powershell
Get-Service DHCPServer
```

Expected result:

```text
Status : Running
```

---

## Verify DHCP Authorization

Run:

```powershell
Get-DhcpServerInDC
```

Expected result:

```text
dc01.lab.local    192.168.100.10
```

---

## Verify DHCP Management Console

Open:

```text
Server Manager
→ Tools
→ DHCP
```

Confirm:

- `DC01` appears
- IPv4 section is visible
- No authorization errors exist

---

# Common Issues And Fixes

## DHCP Server Not Authorized

Authorize the server:

```powershell
Add-DhcpServerInDC -DnsName "dc01.lab.local" -IPAddress 192.168.100.10
```

---

## DHCP Service Not Running

Start the service:

```powershell
Start-Service DHCPServer
```

Check service status again:

```powershell
Get-Service DHCPServer
```

---

## DHCP Console Cannot Connect

Verify the server is domain joined and DNS is functioning correctly.

Test DNS resolution:

```powershell
Resolve-DnsName dc01.lab.local
```

---

# Screenshot Capture

![DHCP installed](/screenshots/dhcp-installed.png)
