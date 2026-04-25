# PowerShell Cheatsheet

## Help And Discovery

Use `Get-Help Get-ADUser -Full`, `Get-Command -Module ActiveDirectory`, and `Get-Member` to explore objects. Good administrators learn object properties instead of parsing formatted text. Use `Select-Object`, `Where-Object`, and `Sort-Object` to shape output before exporting.

## Active Directory

Common commands include `Get-ADUser`, `New-ADUser`, `Set-ADUser`, `Disable-ADAccount`, `Unlock-ADAccount`, `Get-ADGroupMember`, and `Add-ADGroupMember`. Use `-ErrorAction Stop` inside scripts so failures enter `catch` blocks. Use distinguished names for OU paths and test with `Get-ADOrganizationalUnit` before creating users.

## Reporting

Export objects with `Export-Csv -NoTypeInformation`. Avoid screenshots as the only report format because CSV can be searched, filtered, and compared. Include timestamps in filenames for scheduled reports, such as `LastLogon-2026-04-25.csv`.

## Remoting

Use `Invoke-Command`, `Enter-PSSession`, and CIM cmdlets for remote administration. Validate WinRM with `Test-WSMan`. Scheduled tasks may not have interactive profile paths, so scripts should use absolute paths and create their log directory if missing.

## Script Quality

Production scripts should include comment-based help, `[CmdletBinding()]`, validated parameters, `try/catch`, logging, and safe defaults. Never hard-code credentials. Use `SupportsShouldProcess` for scripts that change state so `-WhatIf` can preview actions.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `powershell-cheatsheet-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](../automation/powershell/README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
