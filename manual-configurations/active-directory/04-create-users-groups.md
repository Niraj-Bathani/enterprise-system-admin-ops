# Create Users And Groups

## Objective

Create sample users and role-based security groups for department access.

## Why It Matters

Users represent identities and groups represent access decisions. Group-based access is easier to audit and safer than assigning permissions directly to individuals. In a real enterprise, this procedure is more than a one-time setup action. It becomes part of the identity, name-resolution, access-control, and audit foundation that help support analysts solve tickets quickly and help administrators make changes without guessing. The lab values in this repository use `lab.local`, `DC01`, `CLIENT01`, and the `192.168.100.0/24` network so that each command can be practiced safely before the same pattern is adapted to a production naming standard.

## Prerequisites

Use a Windows Server 2022 machine with a static management IP, current updates, correct time synchronization, and a local administrator session. Confirm that the server can reach the NAT gateway for updates and that the host-only network is stable for client testing. Run PowerShell as administrator. If the step touches Active Directory, sign in with an account that is a member of Domain Admins in the lab. Before making changes, record the existing state using commands such as `ipconfig /all`, `Get-WindowsFeature`, `Get-ADDomain`, `Get-GPO -All`, or `Get-SmbShare`, depending on the guide.

## GUI Procedure

1. Open Active Directory Users and Computers.
2. Create global security groups such as `GG_Sales_Users`, `GG_IT_Admins`, and `GG_Finance_Users` under `OU=Groups`.
3. Create users such as `John Smith` with username `jsmith` under the matching department OU.
4. Add users to the correct department group.
5. Require password change at next logon.

After each GUI action, pause long enough to confirm the wizard accepted the value you entered. Do not click through warnings without reading them. Many Windows administrative tools allow a change to be submitted even when a dependency is wrong, and the failure only appears later in Event Viewer or in client behavior.

## PowerShell Procedure

The PowerShell path is preferred for repeatability and documentation. Copy commands into an elevated console, adjust only the lab-specific values, and keep the transcript with the change record.

```powershell
Start-Transcript -Path C:\Logs\create-users-and-groups.txt -Append
```

```powershell
New-ADGroup -Name 'GG_Sales_Users' -GroupScope Global -GroupCategory Security -Path 'OU=Groups,DC=lab,DC=local'
```
```powershell
$pw = Read-Host 'Temporary password' -AsSecureString
New-ADUser -Name 'John Smith' -GivenName 'John' -Surname 'Smith' -SamAccountName 'jsmith' -UserPrincipalName 'jsmith@lab.local' -Path 'OU=Sales,OU=Users,DC=lab,DC=local' -AccountPassword $pw -Enabled $true -ChangePasswordAtLogon $true
```
```powershell
Add-ADGroupMember -Identity 'GG_Sales_Users' -Members 'jsmith'
```

```powershell
Stop-Transcript
```

## Verification

Run the following checks from the server first, then repeat a client-side validation from `CLIENT01` where appropriate. Expected output should show the feature, policy, record, share, or account in the configured state. If the output is empty, stale, or different from the expected value, do not continue to the next guide until the reason is understood.

```powershell
Get-ADUser jsmith -Properties Department,Enabled,PasswordLastSet
```
```powershell
Get-ADGroupMember GG_Sales_Users
```

For client-side checks, sign in as a normal lab user such as `lab\jsmith`, open a fresh command prompt, and run the matching command. For policy work, use `gpupdate /force` followed by `gpresult /r`. For DNS work, use `Resolve-DnsName`. For file access, test both browsing and creating a small test file in the approved folder.

## Common Issues And Fixes

- **User logon name conflict:** Choose a consistent naming standard such as first initial plus last name and handle duplicates with a number.
- **Group membership not visible immediately:** Have the user sign out and sign back in to refresh the Kerberos token.

- **Replication delay:** If the lab has more than one domain controller, use `repadmin /replsummary` and `repadmin /syncall /AdeP` before concluding that a setting failed.
- **Permissions mismatch:** When a command works for an administrator but not for a user, check group membership, logoff/logon state, and whether the computer has refreshed its Kerberos ticket.
- **Name resolution failure:** Confirm that `CLIENT01` uses `192.168.100.10` as DNS and that the record exists in the expected zone.

## Screenshot Capture

![AD users console](/screenshots/ou-structure.png)



