# Incident 03 File Share Access Denied - Diagnosis

## Diagnostic Goal

The goal was to prove the failing layer before applying a fix. For this incident, the suspected area was share permission, NTFS permission, and group membership validation. A disciplined diagnosis prevents temporary workarounds from hiding the actual cause. The technician worked from the client outward: user input, workstation state, DNS, domain controller reachability, account state, policy, then service logs.

## Step-By-Step Checks

1. Confirm the user, computer, and time of failure in the ticket.
2. On `CLIENT01`, run `ipconfig /all` and confirm DNS points to `192.168.100.10`.
3. Run `nltest /dsgetdc:lab.local` to confirm the client can locate a domain controller.
4. Run the incident-specific command: `icacls D:\Shares\Finance`.
5. Open Event Viewer on `DC01` and filter Security logs for the relevant event IDs: Security 4663 when object access auditing is enabled.
6. Compare the event timestamp with the user report and identify the source workstation or service.
7. Document every result before changing account, policy, DNS, or permission state.

## Expected Findings

The investigation should produce a concrete object and a concrete cause: a locked account, a denied group, a bad DNS record, a failed GPO scope, or a stale credential source. If the event logs show no matching activity, widen the time window and confirm the client is authenticating against `DC01` rather than a cached session. If commands return access denied, rerun them from an elevated administrative shell using a domain admin lab account.

## Useful Commands

```powershell
Get-ADUser -Identity mlopez -Properties Enabled,LockedOut,PasswordExpired,LastLogonDate
Search-ADAccount -LockedOut
gpresult /r
nltest /sc_verify:lab.local
```

The output from these commands should be pasted into the ticket summary or saved as a transcript. Avoid relying on memory during incident response; the final post-incident review depends on exact evidence.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `incident-03-file-share-access-denied-diagnosis-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](../../ticketing-system/README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
