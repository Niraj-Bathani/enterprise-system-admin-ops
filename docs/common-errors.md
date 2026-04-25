# Common Errors

## The Referenced Account Is Locked Out

This usually means repeated bad passwords triggered lockout policy. Check ADUC or `Search-ADAccount -LockedOut`, then review event `4740` on the domain controller for the source. Fix by unlocking the account and clearing saved credentials on the source device.

## The Network Path Was Not Found

This may be DNS, SMB, firewall, or server state. Test `Resolve-DnsName FS01`, `Test-NetConnection FS01 -Port 445`, and `Get-SmbShare` on the file server. Do not change permissions until the path is reachable.

## Access Is Denied

Access denied means authentication succeeded but authorization failed, or the token lacks required membership. Check `whoami /groups`, `Get-SmbShareAccess`, NTFS ACLs with `icacls`, and Effective Access. Have the user sign out and back in after group changes.

## Group Policy Did Not Apply

Run `gpupdate /force`, `gpresult /r`, and `gpresult /h`. Check OU link, security filtering, WMI filters, SYSVOL access, DNS, and replication. A GPO linked to a computer OU will not apply user settings unless loopback processing is configured.

## DNS Name Does Not Exist

Use `Resolve-DnsName name -Server 192.168.100.10` and confirm the record exists in the correct zone. Flush client cache with `ipconfig /flushdns`. If AD-integrated DNS is used, check replication before assuming the record is missing everywhere.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `common-errors-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [troubleshooting-methodology.md](troubleshooting-methodology.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
