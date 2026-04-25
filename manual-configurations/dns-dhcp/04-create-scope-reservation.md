# Create DHCP Scope And Reservation

## Objective

Create a DHCP scope for lab clients and reserve an address for `CLIENT01`.

## Why It Matters

Scopes define the usable address pool, options, and reservations that keep critical clients predictable. In a real enterprise, this procedure is more than a one-time setup action. It becomes part of the identity, name-resolution, access-control, and audit foundation that help support analysts solve tickets quickly and help administrators make changes without guessing. The lab values in this repository use `lab.local`, `DC01`, `CLIENT01`, and the `192.168.100.0/24` network so that each command can be practiced safely before the same pattern is adapted to a production naming standard.

## Prerequisites

Use a Windows Server 2022 machine with a static management IP, current updates, correct time synchronization, and a local administrator session. Confirm that the server can reach the NAT gateway for updates and that the host-only network is stable for client testing. Run PowerShell as administrator. If the step touches Active Directory, sign in with an account that is a member of Domain Admins in the lab. Before making changes, record the existing state using commands such as `ipconfig /all`, `Get-WindowsFeature`, `Get-ADDomain`, `Get-GPO -All`, or `Get-SmbShare`, depending on the guide.

## GUI Procedure

1. Open DHCP console.
2. Right-click IPv4 and create new scope.
3. Name it `Lab Clients`.
4. Use range `192.168.100.100` to `192.168.100.200`.
5. Set subnet mask `255.255.255.0`.
6. Configure router option if NAT gateway is used.
7. Set DNS option to `192.168.100.10` and domain `lab.local`.
8. Add a reservation for `CLIENT01` using its MAC address.

After each GUI action, pause long enough to confirm the wizard accepted the value you entered. Do not click through warnings without reading them. Many Windows administrative tools allow a change to be submitted even when a dependency is wrong, and the failure only appears later in Event Viewer or in client behavior.

## PowerShell Procedure

The PowerShell path is preferred for repeatability and documentation. Copy commands into an elevated console, adjust only the lab-specific values, and keep the transcript with the change record.

```powershell
Start-Transcript -Path C:\Logs\create-dhcp-scope-and-reservation.txt -Append
```

```powershell
Add-DhcpServerv4Scope -Name 'Lab Clients' -StartRange 192.168.100.100 -EndRange 192.168.100.200 -SubnetMask 255.255.255.0 -State Active
```
```powershell
Set-DhcpServerv4OptionValue -ScopeId 192.168.100.0 -DnsServer 192.168.100.10 -DnsDomain lab.local
```
```powershell
Add-DhcpServerv4Reservation -ScopeId 192.168.100.0 -IPAddress 192.168.100.120 -ClientId '00-11-22-33-44-55' -Description 'CLIENT01 reservation'
```

```powershell
Stop-Transcript
```

## Verification

Run the following checks from the server first, then repeat a client-side validation from `CLIENT01` where appropriate. Expected output should show the feature, policy, record, share, or account in the configured state. If the output is empty, stale, or different from the expected value, do not continue to the next guide until the reason is understood.

```powershell
Get-DhcpServerv4Scope
```
```powershell
Get-DhcpServerv4Lease -ScopeId 192.168.100.0
```

For client-side checks, sign in as a normal lab user such as `lab\jsmith`, open a fresh command prompt, and run the matching command. For policy work, use `gpupdate /force` followed by `gpresult /r`. For DNS work, use `Resolve-DnsName`. For file access, test both browsing and creating a small test file in the approved folder.

## Common Issues And Fixes

- **Client keeps APIPA:** Run `ipconfig /release` and `ipconfig /renew`, then check DHCP service and network adapter mode.
- **Reservation ignored:** Confirm the MAC address format and that no exclusion blocks the address.

- **Replication delay:** If the lab has more than one domain controller, use `repadmin /replsummary` and `repadmin /syncall /AdeP` before concluding that a setting failed.
- **Permissions mismatch:** When a command works for an administrator but not for a user, check group membership, logoff/logon state, and whether the computer has refreshed its Kerberos ticket.
- **Name resolution failure:** Confirm that `CLIENT01` uses `192.168.100.10` as DNS and that the record exists in the expected zone.

## Screenshot Capture

![DHCP scope active](./screenshots/dhcp-scope-active.png)

Capture note: add the real screenshot after lab execution. The image should show the completed wizard page, console state, or verification command output clearly enough that another administrator can audit the result.

## Next Step

Continue with [05-troubleshooting.md](05-troubleshooting.md).
