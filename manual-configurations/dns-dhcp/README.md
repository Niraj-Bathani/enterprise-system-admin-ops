# DNS And DHCP Manual Configuration

## Purpose

This section documents the installation, configuration, validation, and troubleshooting of DNS and DHCP services in the `lab.local` environment.

The procedures use:

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

DNS and DHCP are required for:
- domain authentication
- Group Policy processing
- hostname resolution
- automatic client IP assignment
- network service discovery

---

# Recommended Order

| File | Description |
|---|---|
| [01-install-dns.md](01-install-dns.md) | Install and validate the DNS role |
| [02-create-forward-zone-a-record.md](02-create-forward-zone-a-record.md) | Create DNS zone and A record |
| [03-install-dhcp.md](03-install-dhcp.md) | Install and authorize DHCP |
| [04-create-scope-reservation.md](04-create-scope-reservation.md) | Create DHCP scope and reservation |
| [05-troubleshooting.md](05-troubleshooting.md) | Troubleshoot DNS and DHCP issues |

Complete the procedures in sequence because later configurations depend on earlier services functioning correctly.

---

# Operating Standard

Before making changes:

- verify server network configuration
- verify DNS service status
- verify DHCP authorization
- record current settings
- use administrative PowerShell sessions

Use PowerShell transcripts for configuration changes:

```powershell
Start-Transcript -Path C:\Logs\dns-dhcp-config.txt -Append
```

Stop transcripts after completion:

```powershell
Stop-Transcript
```

---

# Validation Standard

After each configuration:

1. Verify service status
2. Verify DNS records or DHCP scopes
3. Validate client connectivity
4. Test DNS resolution
5. Test DHCP lease assignment

Common validation commands:

```powershell
Get-Service DNS,DHCPServer
```

```powershell
Resolve-DnsName lab.local
```

```powershell
Get-DhcpServerv4Scope
```

```powershell
ipconfig /all
```

---

# Troubleshooting Workflow

When diagnosing DNS or DHCP problems:

1. Verify client IP configuration
2. Verify DNS server assignment
3. Verify DHCP scope status
4. Verify DNS records
5. Verify service status
6. Review event logs
7. Retest connectivity

Common troubleshooting commands:

```powershell
Test-NetConnection 192.168.100.10 -Port 53
```

```powershell
Test-NetConnection 192.168.100.10 -Port 67
```

```powershell
ipconfig /flushdns
```

```powershell
ipconfig /release
ipconfig /renew
```

---

# Common Problems

| Issue | Cause |
|---|---|
| APIPA address | DHCP unavailable |
| DNS resolution failure | Incorrect DNS server |
| DHCP authorization error | DHCP not authorized in AD |
| Name resolution delay | Cached DNS records |
| Clients cannot join domain | DNS configuration incorrect |

---

# Verification Goals

The environment is considered operational when:

- DNS service is running
- DHCP service is running
- DNS records resolve correctly
- DHCP clients receive valid leases
- Clients can communicate with domain resources
- Domain name resolution succeeds from clients
