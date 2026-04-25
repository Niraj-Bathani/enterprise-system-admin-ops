# Troubleshooting Methodology

## Start With Scope

Ask who is affected, what changed, when it started, and whether the issue follows the user, computer, location, or application. Scope prevents overreaction. One user with a locked account requires a different response than every user failing to authenticate.

## Preserve Evidence

Record exact error text, screenshots after lab execution, event IDs, commands, and timestamps. Start a PowerShell transcript for command-heavy work. Evidence supports handoff, root cause analysis, and training.

## Work The Stack

For Windows domain issues, check client network configuration, DNS, time sync, domain controller discovery, secure channel, account state, group membership, policy, and service logs. For file access, check path, authentication, share permission, NTFS permission, group token, and inheritance. For DNS/DHCP, check client configuration before changing server settings.

## Change One Thing

Make one change at a time and retest. Multiple simultaneous changes can restore service but hide the actual fix, which weakens prevention. If an emergency requires several changes, document them separately and follow up with root cause analysis.

## Close With Validation

The final test should match the original failure. If the user could not map a drive, test mapping the drive. If DNS failed, test the exact name from the exact client resolver. Close the ticket only when the business function works again.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `troubleshooting-methodology-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [common-errors.md](common-errors.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
