# USB Storage Restriction

## Objective

Restrict removable storage access on managed workstations.

## Why It Matters

USB control reduces data leakage and malware risk while allowing exceptions through OU scope or security filtering. In a real enterprise, this procedure is more than a one-time setup action. It becomes part of the identity, name-resolution, access-control, and audit foundation that help support analysts solve tickets quickly and help administrators make changes without guessing. The lab values in this repository use `lab.local`, `DC01`, `CLIENT01`, and the `192.168.100.0/24` network so that each command can be practiced safely before the same pattern is adapted to a production naming standard.

## Prerequisites

Use a Windows Server 2022 machine with a static management IP, current updates, correct time synchronization, and a local administrator session. Confirm that the server can reach the NAT gateway for updates and that the host-only network is stable for client testing. Run PowerShell as administrator. If the step touches Active Directory, sign in with an account that is a member of Domain Admins in the lab. Before making changes, record the existing state using commands such as `ipconfig /all`, `Get-WindowsFeature`, `Get-ADDomain`, `Get-GPO -All`, or `Get-SmbShare`, depending on the guide.

## GUI Procedure

1. Open Group Policy Management Console.
2. Create a GPO named `SEC - Restrict USB Storage`.
3. Link it to the Workstations OU.
4. Edit Computer Configuration, Policies, Administrative Templates, System, Removable Storage Access.
5. Enable `All Removable Storage classes: Deny all access`.
6. Run gpupdate on a pilot workstation.

After each GUI action, pause long enough to confirm the wizard accepted the value you entered. Do not click through warnings without reading them. Many Windows administrative tools allow a change to be submitted even when a dependency is wrong, and the failure only appears later in Event Viewer or in client behavior.

## PowerShell Procedure

The PowerShell path is preferred for repeatability and documentation. Copy commands into an elevated console, adjust only the lab-specific values, and keep the transcript with the change record.

```powershell
Start-Transcript -Path C:\Logs\usb-storage-restriction.txt -Append
```

```powershell
New-GPO -Name 'SEC - Restrict USB Storage'
```
```powershell
New-GPLink -Name 'SEC - Restrict USB Storage' -Target 'OU=Workstations,OU=Computers,DC=lab,DC=local'
```

```powershell
Stop-Transcript
```

## Verification

Run the following checks from the server first, then repeat a client-side validation from `CLIENT01` where appropriate. Expected output should show the feature, policy, record, share, or account in the configured state. If the output is empty, stale, or different from the expected value, do not continue to the next guide until the reason is understood.

```powershell
gpupdate /force
```
```powershell
gpresult /h C:\Logs\usb-policy.html
```

For client-side checks, sign in as a normal lab user such as `lab\jsmith`, open a fresh command prompt, and run the matching command. For policy work, use `gpupdate /force` followed by `gpresult /r`. For DNS work, use `Resolve-DnsName`. For file access, test both browsing and creating a small test file in the approved folder.

## Common Issues And Fixes

- **Policy too broad:** Move test computers into a pilot OU and link the GPO there before wider rollout.
- **User needs exception:** Use security filtering with a clearly named exception group and document approval.

- **Replication delay:** If the lab has more than one domain controller, use `repadmin /replsummary` and `repadmin /syncall /AdeP` before concluding that a setting failed.
- **Permissions mismatch:** When a command works for an administrator but not for a user, check group membership, logoff/logon state, and whether the computer has refreshed its Kerberos ticket.
- **Name resolution failure:** Confirm that `CLIENT01` uses `192.168.100.10` as DNS and that the record exists in the expected zone.

## Screenshot Capture

![USB restriction policy](./screenshots/usb-restriction-policy.png)

Capture note: add the real screenshot after lab execution. The image should show the completed wizard page, console state, or verification command output clearly enough that another administrator can audit the result.


