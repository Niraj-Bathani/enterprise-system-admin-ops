# GPUpdate Troubleshooting

## Objective

Diagnose Group Policy processing failures on clients.

## Why It Matters

Policy troubleshooting is essential because GPO symptoms can come from scope, security filtering, WMI filters, replication, DNS, or client health. In a real enterprise, this procedure is more than a one-time setup action. It becomes part of the identity, name-resolution, access-control, and audit foundation that help support analysts solve tickets quickly and help administrators make changes without guessing. The lab values in this repository use `lab.local`, `DC01`, `CLIENT01`, and the `192.168.100.0/24` network so that each command can be practiced safely before the same pattern is adapted to a production naming standard.

## Prerequisites

Use a Windows Server 2022 machine with a static management IP, current updates, correct time synchronization, and a local administrator session. Confirm that the server can reach the NAT gateway for updates and that the host-only network is stable for client testing. Run PowerShell as administrator. If the step touches Active Directory, sign in with an account that is a member of Domain Admins in the lab. Before making changes, record the existing state using commands such as `ipconfig /all`, `Get-WindowsFeature`, `Get-ADDomain`, `Get-GPO -All`, or `Get-SmbShare`, depending on the guide.

## GUI Procedure

1. Run `gpupdate /force` on the client.
2. Run `gpresult /r` for a quick summary.
3. Generate `gpresult /h C:\Logs\gpresult.html`.
4. Open Event Viewer, Applications and Services Logs, Microsoft, Windows, GroupPolicy, Operational.
5. Check GPMC Group Policy Results from the server.

After each GUI action, pause long enough to confirm the wizard accepted the value you entered. Do not click through warnings without reading them. Many Windows administrative tools allow a change to be submitted even when a dependency is wrong, and the failure only appears later in Event Viewer or in client behavior.

## PowerShell Procedure

The PowerShell path is preferred for repeatability and documentation. Copy commands into an elevated console, adjust only the lab-specific values, and keep the transcript with the change record.

```powershell
Start-Transcript -Path C:\Logs\gpupdate-troubleshooting.txt -Append
```

```powershell
gpupdate /force
```
```powershell
gpresult /h C:\Logs\gpresult.html
```
```powershell
Get-GPResultantSetOfPolicy -ReportType Html -Path C:\Logs\rsop.html
```

```powershell
Stop-Transcript
```

## Verification

Run the following checks from the server first, then repeat a client-side validation from `CLIENT01` where appropriate. Expected output should show the feature, policy, record, share, or account in the configured state. If the output is empty, stale, or different from the expected value, do not continue to the next guide until the reason is understood.

```powershell
Test-ComputerSecureChannel -Verbose
```
```powershell
Resolve-DnsName lab.local
```
```powershell
repadmin /replsummary
```

For client-side checks, sign in as a normal lab user such as `lab\jsmith`, open a fresh command prompt, and run the matching command. For policy work, use `gpupdate /force` followed by `gpresult /r`. For DNS work, use `Resolve-DnsName`. For file access, test both browsing and creating a small test file in the approved folder.

## Common Issues And Fixes

- **Access denied processing policy:** Check permissions on SYSVOL and the GPO security filtering.
- **Wrong GPO version:** Check replication between domain controllers and run `dfsrdiag backlog` if DFSR is used.

- **Replication delay:** If the lab has more than one domain controller, use `repadmin /replsummary` and `repadmin /syncall /AdeP` before concluding that a setting failed.
- **Permissions mismatch:** When a command works for an administrator but not for a user, check group membership, logoff/logon state, and whether the computer has refreshed its Kerberos ticket.
- **Name resolution failure:** Confirm that `CLIENT01` uses `192.168.100.10` as DNS and that the record exists in the expected zone.

## Screenshot Capture

![Group Policy troubleshooting](./screenshots/gpupdate-troubleshooting.png)

Capture note: add the real screenshot after lab execution. The image should show the completed wizard page, console state, or verification command output clearly enough that another administrator can audit the result.

## Next Step

Continue to [../dns-dhcp/README.md](../dns-dhcp/README.md).
