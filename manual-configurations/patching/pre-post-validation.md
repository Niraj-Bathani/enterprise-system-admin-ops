# Pre And Post Patch Validation

## Objective

Perform validation checks before and after patching systems in the `lab.local` environment to confirm services remain operational after updates and reboot cycles.

---

# Environment

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| FS01 | File Server | 192.168.100.40 |
| CLIENT01 | Windows Client | 192.168.100.20 |

Domain:

```text
lab.local
```

---

# Pre-Patch Validation

## Check System Uptime

```powershell
Get-CimInstance Win32_OperatingSystem |
Select-Object LastBootUpTime
```

---

## Check Installed Updates

```powershell
Get-HotFix
```

---

## Verify Disk Space

```powershell
Get-PSDrive
```

---

# Domain Controller Validation

Run on `DC01`:

```powershell
dcdiag /q
```

```powershell
repadmin /replsummary
```

```powershell
Get-Service DNS,NTDS,Netlogon,Kdc
```

```powershell
Get-SmbShare SYSVOL,NETLOGON
```

---

# File Server Validation

Run on `FS01`:

```powershell
Get-SmbShare
```

```powershell
Get-SmbSession
```

Test file share access from `CLIENT01`:

```powershell
Test-Path '\\FS01\Sales'
```

---

# DHCP Validation

Run:

```powershell
Get-DhcpServerv4Scope
```

```powershell
Get-DhcpServerv4Lease
```

---

# Post-Patch Validation

After updates and reboot:

- repeat all previous validation commands
- confirm services are running
- confirm DNS resolution works
- confirm SMB shares are accessible
- confirm Group Policy refresh succeeds
- confirm no replication failures exist

Run:

```powershell
gpupdate /force
```

```powershell
Resolve-DnsName lab.local
```

---

# Escalation

Escalate immediately if:
- DNS service fails
- replication errors appear
- SMB shares unavailable
- domain authentication fails
- DHCP leases stop issuing

Capture:
- failed command output
- event IDs
- reboot time
- KB numbers
- affected systems

---

# Screenshot Capture

![Patch pre check](/screenshots/patch-pre-check.png)

![Patch post check](/screenshots/patch-post-check.png)

