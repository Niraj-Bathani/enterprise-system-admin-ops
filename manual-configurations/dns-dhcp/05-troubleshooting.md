# DNS And DHCP Troubleshooting

## Objective

Diagnose common name resolution and address assignment problems.

## Why It Matters

DNS and DHCP failures often appear as application or domain problems, so administrators need a structured network service workflow. In a real enterprise, this procedure is more than a one-time setup action. It becomes part of the identity, name-resolution, access-control, and audit foundation that help support analysts solve tickets quickly and help administrators make changes without guessing. The lab values in this repository use `lab.local`, `DC01`, `CLIENT01`, and the `192.168.100.0/24` network so that each command can be practiced safely before the same pattern is adapted to a production naming standard.

## Prerequisites

Use a Windows Server 2022 machine with a static management IP, current updates, correct time synchronization, and a local administrator session. Confirm that the server can reach the NAT gateway for updates and that the host-only network is stable for client testing. Run PowerShell as administrator. If the step touches Active Directory, sign in with an account that is a member of Domain Admins in the lab. Before making changes, record the existing state using commands such as `ipconfig /all`, `Get-WindowsFeature`, `Get-ADDomain`, `Get-GPO -All`, or `Get-SmbShare`, depending on the guide.

## GUI Procedure

1. Check client IP configuration.
2. Confirm DNS server assignment.
3. Test name resolution.
4. Check DHCP leases.
5. Review DNS and DHCP event logs.
6. Restart services only after evidence points to service state.

After each GUI action, pause long enough to confirm the wizard accepted the value you entered. Do not click through warnings without reading them. Many Windows administrative tools allow a change to be submitted even when a dependency is wrong, and the failure only appears later in Event Viewer or in client behavior.

## PowerShell Procedure

The PowerShell path is preferred for repeatability and documentation. Copy commands into an elevated console, adjust only the lab-specific values, and keep the transcript with the change record.

```powershell
Start-Transcript -Path C:\Logs\dns-and-dhcp-troubleshooting.txt -Append
```

```powershell
ipconfig /all
```
```powershell
Resolve-DnsName lab.local -Server 192.168.100.10
```
```powershell
Get-DhcpServerv4Lease -ScopeId 192.168.100.0
```
```powershell
Get-EventLog -LogName System -Source 'Microsoft-Windows-DHCP-Server' -Newest 20
```

```powershell
Stop-Transcript
```

## Verification

Run the following checks from the server first, then repeat a client-side validation from `CLIENT01` where appropriate. Expected output should show the feature, policy, record, share, or account in the configured state. If the output is empty, stale, or different from the expected value, do not continue to the next guide until the reason is understood.

```powershell
Test-NetConnection 192.168.100.10 -Port 53
```
```powershell
Test-NetConnection 192.168.100.10 -Port 67
```

For client-side checks, sign in as a normal lab user such as `lab\jsmith`, open a fresh command prompt, and run the matching command. For policy work, use `gpupdate /force` followed by `gpresult /r`. For DNS work, use `Resolve-DnsName`. For file access, test both browsing and creating a small test file in the approved folder.

## Common Issues And Fixes

- **Wrong DNS server:** Correct DHCP option 006 or the static adapter setting.
- **Scope exhausted:** Review leases, shorten duration in lab, or expand the scope after confirming address plan.

- **Replication delay:** If the lab has more than one domain controller, use `repadmin /replsummary` and `repadmin /syncall /AdeP` before concluding that a setting failed.
- **Permissions mismatch:** When a command works for an administrator but not for a user, check group membership, logoff/logon state, and whether the computer has refreshed its Kerberos ticket.
- **Name resolution failure:** Confirm that `CLIENT01` uses `192.168.100.10` as DNS and that the record exists in the expected zone.

## Screenshot Capture

![DNS DHCP troubleshooting](./screenshots/dns-dhcp-troubleshooting.png)

Capture note: add the real screenshot after lab execution. The image should show the completed wizard page, console state, or verification command output clearly enough that another administrator can audit the result.


