# Windows Admin Cheatsheet

## Identity

Use `Get-ADUser jsmith -Properties *` for detailed account review, `Search-ADAccount -LockedOut` for lockouts, `Unlock-ADAccount -Identity jsmith` for unlock, and `Get-ADPrincipalGroupMembership jsmith` for access checks. Always validate group changes by having the user sign out and back in because Kerberos tokens are created at logon.

## Domain Controller Health

Run `dcdiag /q` for quick domain controller diagnostics, `repadmin /replsummary` for replication state, `Get-Service DNS,NTDS,Netlogon,Kdc` for critical services, and `Get-SmbShare SYSVOL,NETLOGON` for policy share availability. If SYSVOL is missing, Group Policy processing will fail even if users can sign in.

## DNS And DHCP

Use `Resolve-DnsName lab.local -Server 192.168.100.10`, `Get-DnsServerResourceRecord`, `ipconfig /flushdns`, and `Test-NetConnection DC01 -Port 53`. For DHCP, use `Get-DhcpServerv4Scope`, `Get-DhcpServerv4Lease`, and `ipconfig /renew` on the client. Wrong DNS settings are a common cause of domain join and GPO issues.

## File Services

Use `Get-SmbShare`, `Get-SmbShareAccess`, `icacls`, `whoami /groups`, and Effective Access in the GUI. Remember that effective access is constrained by both share and NTFS permissions. Avoid direct user ACLs except for rare exceptions with documented approval.

## Event Logs

Use Event Viewer or `Get-WinEvent`. Account lockouts often use event `4740`, failed logons use `4625`, Kerberos pre-authentication failures use `4771`, and Group Policy client events appear under Microsoft, Windows, GroupPolicy, Operational. Always record event ID, time, source, and target account.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `windows-admin-cheatsheet-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [powershell-cheatsheet.md](powershell-cheatsheet.md), [troubleshooting-methodology.md](troubleshooting-methodology.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
