# GPUpdate Troubleshooting

## Objective

Diagnose and resolve Group Policy processing failures on domain clients in the `lab.local` environment.

---

## Why It Matters

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
Prerequisites

Before starting:

Active Directory operational
DNS functioning correctly
Group Policy Management installed
Domain Admin privileges available
PowerShell running as Administrator

Verify Group Policy tools:

Get-WindowsFeature GPMC

Verify domain connectivity:

Get-ADDomain
GUI Procedure
Run Group Policy Update
Sign in to CLIENT01.
Open Command Prompt as Administrator.
Run:
gpupdate /force
Verify applied policies:
gpresult /r
Generate a detailed policy report:
gpresult /h C:\Logs\gpresult.html
Review Group Policy Logs

Open:

Event Viewer
→ Applications and Services Logs
→ Microsoft
→ Windows
→ GroupPolicy
→ Operational

Review:

policy processing events
warnings
errors
failed extensions
PowerShell Procedure

Start logging:

Start-Transcript -Path C:\Logs\gpupdate-troubleshooting.txt -Append

Run policy update:

gpupdate /force

Generate GPResult report:

gpresult /h C:\Logs\gpresult.html

Generate RSOP report:

Get-GPResultantSetOfPolicy `
-ReportType Html `
-Path C:\Logs\rsop.html

Verify secure channel:

Test-ComputerSecureChannel -Verbose

Verify DNS:

Resolve-DnsName lab.local

Check replication:

repadmin /replsummary

Stop logging:

Stop-Transcript
Verification

Run the following checks on CLIENT01:

Update policies:

gpupdate /force

View applied GPOs:

gpresult /r

Verify DNS resolution:

Resolve-DnsName lab.local

Expected results:

Group Policy updates successfully
required GPOs appear in gpresult
DNS resolution works correctly
secure channel validation succeeds
no Group Policy errors appear in Event Viewer
Common Issues And Fixes
GPO Not Applying

Verify:

computer is in correct OU
GPO linked properly
security filtering allows the client

Run:

gpupdate /force
DNS Resolution Failure

Verify DNS settings:

ipconfig /all

Ensure the client uses:

192.168.100.10

as its DNS server.

Secure Channel Broken

Verify trust relationship:

Test-ComputerSecureChannel -Verbose

Rejoin the domain if validation fails.

Replication Problems

Check replication status:

repadmin /replsummary

Force replication if necessary:

repadmin /syncall /AdeP

Screenshot Capture

![Group Policy troubleshooting](/screenshots/gpupdate-troubleshooting.png)
