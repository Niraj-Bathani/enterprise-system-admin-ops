# Install DNS Role

## Objective

Install the DNS Server role on `DC01` and verify that the DNS service is operational.

---

# Why It Matters

DNS is required for Active Directory authentication, domain controller discovery, Kerberos, LDAP, Group Policy processing, and general name resolution inside the domain environment.

This lab uses:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller and DNS Server | 192.168.100.10 |
| CLIENT01 | Domain Client | 192.168.100.20 |

Domain name:

```text
lab.local
```

---

# Prerequisites

Before starting:

- Windows Server 2022 is installed
- Static IP address is configured
- Server time is synchronized
- Administrator PowerShell session is open
- The server can communicate with the lab network

Verify network configuration:

```powershell
ipconfig /all
```

Verify current installed roles:

```powershell
Get-WindowsFeature
```

---

# GUI Installation Procedure

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
Role-based or feature-based installation
```

4. Select server:

```text
DC01
```

5. Enable:

```text
DNS Server
```

6. Accept required management tools.

7. Complete the installation wizard.

8. Open:

```text
Tools
→ DNS
```

---

# PowerShell Installation Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\install-dns-role.txt -Append
```

Install DNS Server role:

```powershell
Install-WindowsFeature -Name DNS -IncludeManagementTools
```

Stop logging:

```powershell
Stop-Transcript
```

---

# Verification

## Verify DNS Service

Run:

```powershell
Get-Service DNS
```

Expected result:

```text
Status : Running
```

---

## Verify DNS Zones

Run:

```powershell
Get-DnsServerZone
```

Confirm that the following zone exists:

```text
lab.local
```

---

## Client Validation

On `CLIENT01`, run:

```powershell
Resolve-DnsName lab.local
```

Expected result:

- DNS resolution succeeds
- DNS server returned is `192.168.100.10`

---

# Common Issues And Fixes

## DNS Service Not Running

Start the DNS service:

```powershell
Start-Service DNS
```

Verify service state:

```powershell
Get-Service DNS
```

---

## Incorrect Client DNS Configuration

Verify client DNS settings:

```powershell
ipconfig /all
```

Confirm preferred DNS server is:

```text
192.168.100.10
```

---

## DNS Resolution Failure

Flush DNS cache:

```powershell
ipconfig /flushdns
```

Retest:

```powershell
Resolve-DnsName lab.local
```

---

# Screenshot Capture

![DNS installed](/screenshots/dns-zones.png)

```
