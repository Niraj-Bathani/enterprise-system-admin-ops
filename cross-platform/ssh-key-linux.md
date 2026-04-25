# SSH Key Administration For Linux

## Objective

Create and use SSH keys from Windows to administer Ubuntu Server 22.04 securely. SSH keys reduce password exposure and support repeatable administration from Windows Terminal or PowerShell.

## Generate Key On Windows

On `CLIENT01`, open PowerShell and run `ssh-keygen -t ed25519 -C "jsmith-lab-admin"`. Accept the default path or use a lab-specific file such as `$env:USERPROFILE\.ssh\lab_ed25519`. Use a passphrase for realistic practice. Confirm the public key exists with `Get-Content $env:USERPROFILE\.ssh\lab_ed25519.pub`.

## Install Public Key On Ubuntu

On Ubuntu, create the `.ssh` directory with `mkdir -p ~/.ssh && chmod 700 ~/.ssh`. Append the public key to `~/.ssh/authorized_keys` and run `chmod 600 ~/.ssh/authorized_keys`. From Windows, connect with `ssh -i $env:USERPROFILE\.ssh\lab_ed25519 username@192.168.100.30`.

## Hardening Notes

After key authentication is confirmed, production systems often disable password authentication in `/etc/ssh/sshd_config` with `PasswordAuthentication no`, then restart `sshd`. In the lab, keep console access available before changing this setting. Always test a second session before closing the first administrative connection.

## Troubleshooting

Use `ssh -vvv` for verbose client diagnostics. On Ubuntu, check `sudo journalctl -u ssh --since "30 minutes ago"`. Permission errors usually come from loose permissions on the home directory, `.ssh`, or `authorized_keys`. Capture `![SSH key login](./screenshots/ssh-key-login.png)` after lab execution.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `ssh-key-administration-for-linux-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [samba-file-share.md](samba-file-share.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
