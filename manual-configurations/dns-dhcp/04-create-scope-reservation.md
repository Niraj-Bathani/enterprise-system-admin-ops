# Create DHCP Scope And Reservation

## Objective

Create a DHCP scope for lab clients and configure a reservation for `CLIENT01`.

---

# Why It Matters

DHCP scopes define the IP address range available to client systems and ensure devices receive consistent network configuration automatically.

This lab environment uses:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller and DHCP Server | 192.168.100.10 |
| CLIENT01 | Windows Client | DHCP Reservation |
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

- DHCP role installed
- DHCP server authorized
- DNS functioning correctly
- PowerShell running as Administrator

Verify DHCP service:

```powershell
Get-Service DHCPServer
```

Verify authorized DHCP server:

```powershell
Get-DhcpServerInDC
```

---

# GUI Procedure

1. Open:

```text
Server Manager
→ Tools
→ DHCP
```

2. Expand:

```text
DC01.lab.local
→ IPv4
```

3. Right-click:

```text
IPv4
→ New Scope
```

4. Configure the scope:

| Setting | Value |
|---|---|
| Scope Name | Lab Clients |
| Start IP | 192.168.100.100 |
| End IP | 192.168.100.200 |
| Subnet Mask | 255.255.255.0 |

5. Configure DHCP options:

| Option | Value |
|---|---|
| Router | 192.168.100.1 |
| DNS Server | 192.168.100.10 |
| Domain Name | lab.local |

6. Activate the scope.

7. Create reservation:

| Setting | Value |
|---|---|
| Reservation Name | CLIENT01 |
| IP Address | 192.168.100.120 |
| MAC Address | 00-11-22-33-44-55 |

---

# PowerShell Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\create-dhcp-scope-and-reservation.txt -Append
```

Create DHCP scope:

```powershell
Add-DhcpServerv4Scope -Name "Lab Clients" -StartRange 192.168.100.100 -EndRange 192.168.100.200 -SubnetMask 255.255.255.0 -State Active
```

Configure DHCP options:

```powershell
Set-DhcpServerv4OptionValue -ScopeId 192.168.100.0 -DnsServer 192.168.100.10 -DnsDomain "lab.local" -Router 192.168.100.1
```

Create reservation:

```powershell
Add-DhcpServerv4Reservation -ScopeId 192.168.100.0 -IPAddress 192.168.100.120 -ClientId "00-11-22-33-44-55" -Description "CLIENT01 reservation"
```

Stop logging:

```powershell
Stop-Transcript
```

---

# Verification

## Verify DHCP Scope

Run:

```powershell
Get-DhcpServerv4Scope
```

Expected result:

```text
Lab Clients
192.168.100.100 - 192.168.100.200
Active
```

---

## Verify Reservation

Run:

```powershell
Get-DhcpServerv4Reservation -ScopeId 192.168.100.0
```

Expected result:

```text
CLIENT01    192.168.100.120
```

---

## Verify DHCP Lease

On `CLIENT01`, run:

```powershell
ipconfig /release
ipconfig /renew
ipconfig /all
```

Confirm:
- Client receives DHCP address
- DNS server is `192.168.100.10`
- Domain is `lab.local`

---

# Common Issues And Fixes

## Client Receives APIPA Address

Renew DHCP lease:

```powershell
ipconfig /release
ipconfig /renew
```

Verify DHCP service:

```powershell
Get-Service DHCPServer
```

---

## Reservation Not Applied

Verify MAC address format:

```text
00-11-22-33-44-55
```

Confirm the reservation IP is not excluded from the scope.

---

## DHCP Scope Inactive

Activate the scope:

```powershell
Set-DhcpServerv4Scope -ScopeId 192.168.100.0 -State Active
```

---

# Screenshot Capture

![DHCP scope active](/screenshots/dhcp-scope-active.png)
