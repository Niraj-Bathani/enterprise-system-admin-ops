# Join Client To Domain

## Objective

Join `CLIENT01` to the `lab.local` domain and validate domain authentication.

## Why It Matters

Domain join places the workstation under centralized identity and policy management, making it eligible for GPOs, domain sign-in, and inventory. In a real enterprise, this procedure is more than a one-time setup action. It becomes part of the identity, name-resolution, access-control, and audit foundation that help support analysts solve tickets quickly and help administrators make changes without guessing. The lab values in this repository use `lab.local`, `DC01`, `CLIENT01`, and the `192.168.100.0/24` network so that each command can be practiced safely before the same pattern is adapted to a production naming standard.

## Prerequisites

Use a Windows Server 2022 machine with a static management IP, current updates, correct time synchronization, and a local administrator session. Confirm that the server can reach the NAT gateway for updates and that the host-only network is stable for client testing. Run PowerShell as administrator. If the step touches Active Directory, sign in with an account that is a member of Domain Admins in the lab. Before making changes, record the existing state using commands such as `ipconfig /all`, `Get-WindowsFeature`, `Get-ADDomain`, `Get-GPO -All`, or `Get-SmbShare`, depending on the guide.

## GUI Procedure

1. On `CLIENT01`, set DNS server to `192.168.100.10`.
2. Open Settings, System, About, and select Rename this PC advanced.
3. Click Change, choose Domain, and enter `lab.local`.
4. Provide authorized domain admin credentials when prompted.
5. Restart the workstation.
6. Sign in as `LAB\jsmith`.

After each GUI action, pause long enough to confirm the wizard accepted the value you entered. Do not click through warnings without reading them. Many Windows administrative tools allow a change to be submitted even when a dependency is wrong, and the failure only appears later in Event Viewer or in client behavior.

## PowerShell Procedure

The PowerShell path is preferred for repeatability and documentation. Copy commands into an elevated console, adjust only the lab-specific values, and keep the transcript with the change record.

```powershell
Start-Transcript -Path C:\Logs\join-client-to-domain.txt -Append
```

```powershell
Set-DnsClientServerAddress -InterfaceAlias 'Ethernet' -ServerAddresses 192.168.100.10
```
```powershell
Add-Computer -DomainName 'lab.local' -OUPath 'OU=Workstations,OU=Computers,DC=lab,DC=local' -Restart
```

```powershell
Stop-Transcript
```

## Verification

Run the following checks from the server first, then repeat a client-side validation from `CLIENT01` where appropriate. Expected output should show the feature, policy, record, share, or account in the configured state. If the output is empty, stale, or different from the expected value, do not continue to the next guide until the reason is understood.

```powershell
whoami
```
```powershell
nltest /sc_verify:lab.local
```
```powershell
Get-ADComputer CLIENT01 -Properties DistinguishedName
```

For client-side checks, sign in as a normal lab user such as `lab\jsmith`, open a fresh command prompt, and run the matching command. For policy work, use `gpupdate /force` followed by `gpresult /r`. For DNS work, use `Resolve-DnsName`. For file access, test both browsing and creating a small test file in the approved folder.

## Common Issues And Fixes

- **Domain not found:** Confirm DNS points to `192.168.100.10` and run `Resolve-DnsName lab.local`.
- **Access denied during join:** Use a domain admin lab account or delegate join rights to the target OU.

- **Replication delay:** If the lab has more than one domain controller, use `repadmin /replsummary` and `repadmin /syncall /AdeP` before concluding that a setting failed.
- **Permissions mismatch:** When a command works for an administrator but not for a user, check group membership, logoff/logon state, and whether the computer has refreshed its Kerberos ticket.
- **Name resolution failure:** Confirm that `CLIENT01` uses `192.168.100.10` as DNS and that the record exists in the expected zone.

## Screenshot Capture

![Client domain join](./screenshots/client-domain-join.png)

Capture note: add the real screenshot after lab execution. The image should show the completed wizard page, console state, or verification command output clearly enough that another administrator can audit the result.

## Next Step

Continue with [06-password-reset-unlock.md](06-password-reset-unlock.md).
