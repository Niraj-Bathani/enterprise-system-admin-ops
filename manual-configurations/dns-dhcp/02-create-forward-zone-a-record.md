# Create Forward Zone And A Record

## Objective

Create a forward lookup zone and configure a host A record for lab resources.

---

# Why It Matters

Forward lookup zones translate hostnames into IP addresses and are required for reliable communication inside an Active Directory environment.

This lab uses:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller and DNS Server | 192.168.100.10 |
| FS01 | File Server | 192.168.100.40 |
| CLIENT01 | Domain Client | 192.168.100.20 |

Domain name:

```text
lab.local
```

---

# Prerequisites

Before starting:

- DNS Server role is installed
- Static IP address is configured
- DNS service is running
- Administrator PowerShell session is open

Verify DNS service:

```powershell
Get-Service DNS
```

Verify existing DNS zones:

```powershell
Get-DnsServerZone
```

---

# GUI Procedure

1. Open:

```text
DNS Manager
```

2. Expand:

```text
DC01
→ Forward Lookup Zones
```

3. Right-click:

```text
Forward Lookup Zones
→ New Zone
```

4. Create primary zone:

```text
lab.local
```

5. Right-click the zone and select:

```text
New Host (A or AAAA)
```

6. Configure the host record:

| Name | IP Address |
|---|---|
| fs01 | 192.168.100.40 |

7. Save the record.

---

# PowerShell Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\create-forward-zone-and-a-record.txt -Append
```

Create the forward lookup zone:

```powershell
Add-DnsServerPrimaryZone -Name "lab.local" -ReplicationScope Domain
```

Create the A record:

```powershell
Add-DnsServerResourceRecordA -ZoneName "lab.local" -Name "fs01" -IPv4Address "192.168.100.40"
```

Stop logging:

```powershell
Stop-Transcript
```

---

# Verification

## Verify DNS Record Resolution

Run:

```powershell
Resolve-DnsName fs01.lab.local -Server 192.168.100.10
```

Expected result:

```text
Name       : fs01.lab.local
IPAddress  : 192.168.100.40
```

---

## Verify DNS Record Exists

Run:

```powershell
Get-DnsServerResourceRecord -ZoneName "lab.local" -Name "fs01"
```

Confirm that the A record exists and points to:

```text
192.168.100.40
```

---

## Client Validation

On `CLIENT01`, run:

```powershell
Resolve-DnsName fs01.lab.local
```

Expected result:

- DNS lookup succeeds
- IP address returned is `192.168.100.40`

---

# Common Issues And Fixes

## Record Exists With Incorrect IP

Remove the incorrect record:

```powershell
Remove-DnsServerResourceRecord -ZoneName "lab.local" -RRType "A" -Name "fs01"
```

Recreate the record with the correct IP address.

---

## Client DNS Cache Contains Old Record

Flush the DNS cache:

```powershell
ipconfig /flushdns
```

Retest name resolution:

```powershell
Resolve-DnsName fs01.lab.local
```

---

## DNS Resolution Failure

Verify that the client uses the correct DNS server:

```powershell
ipconfig /all
```

Confirm preferred DNS server is:

```text
192.168.100.10
```

---

# Screenshot Capture

![DNS A record](/screenshots/dns-a-record.png)
