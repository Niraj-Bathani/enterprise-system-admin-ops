````markdown
# GPUpdate Troubleshooting

## Objective

Diagnose and resolve Group Policy processing failures on domain clients in the `lab.local` environment.

---

# Why It Matters

Group Policy issues can be caused by:
- DNS failures
- replication delays
- OU placement issues
- security filtering problems
- SYSVOL access problems
- broken secure channels

This lab environment uses:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| CLIENT01 | Windows Client | 192.168.100.20 |

Domain:

```text
lab.local
```

---

# Prerequisites

Before starting:

- Active Directory operational
- DNS functioning correctly
- Group Policy Management installed
- Domain Admin privileges available
- PowerShell running as Administrator

Verify Group Policy tools:

```powershell
Get-WindowsFeature GPMC
```

Verify domain connectivity:

```powershell
Get-ADDomain
```

---

# GUI Procedure

## Run Group Policy Update

1. Sign in to `CLIENT01`.

2. Open Command Prompt as Administrator.

3. Run:

```powershell
gpupdate /force
```

4. Verify applied policies:

```powershell
gpresult /r
```

5. Generate a detailed policy report:

```powershell
gpresult /h C:\Logs\gpresult.html
```

---

# Review Group Policy Logs

Open:

```text
Event Viewer
→ Applications and Services Logs
→ Microsoft
→ Windows
→ GroupPolicy
→ Operational
```

Review:
- policy processing events
- warnings
- errors
- failed extensions

---

# PowerShell Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\gpupdate-troubleshooting.txt -Append
```

Run policy update:

```powershell
gpupdate /force
```

Generate GPResult report:

```powershell
gpresult /h C:\Logs\gpresult.html
```

Generate RSOP report:

```powershell
Get-GPResultantSetOfPolicy `
-ReportType Html `
-Path C:\Logs\rsop.html
```

Verify secure channel:

```powershell
Test-ComputerSecureChannel -Verbose
```

Verify DNS:

```powershell
Resolve-DnsName lab.local
```

Check replication:

```powershell
repadmin /replsummary
```

Stop logging:

```powershell
Stop-Transcript
```

---

# Verification

Run the following checks on `CLIENT01`:

Update policies:

```powershell
gpupdate /force
```

View applied GPOs:

```powershell
gpresult /r
```

Verify DNS resolution:

```powershell
Resolve-DnsName lab.local
```

Expected results:
- Group Policy updates successfully
- required GPOs appear in gpresult
- DNS resolution works correctly
- secure channel validation succeeds
- no Group Policy errors appear in Event Viewer

---

# Common Issues And Fixes

## GPO Not Applying

Verify:
- computer is in correct OU
- GPO linked properly
- security filtering allows the client

Run:

```powershell
gpupdate /force
```

---

## DNS Resolution Failure

Verify DNS settings:

```powershell
ipconfig /all
```

Ensure the client uses:

```text
192.168.100.10
```

as its DNS server.

---

## Secure Channel Broken

Verify trust relationship:

```powershell
Test-ComputerSecureChannel -Verbose
```

Rejoin the domain if validation fails.

---

## Replication Problems

Check replication status:

```powershell
repadmin /replsummary
```

Force replication if necessary:

```powershell
repadmin /syncall /AdeP
```

---

# Screenshot Capture

![Group Policy troubleshooting](/screenshots/gpupdate-troubleshooting.png)
