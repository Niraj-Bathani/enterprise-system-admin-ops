# Samba File Share From Ubuntu To Windows

## Objective

Share a folder from Ubuntu Server 22.04 to a Windows client using Samba. This demonstrates Windows/Linux interoperability, SMB troubleshooting, and service validation. The lab uses `UBUNTU01` at `192.168.100.30` and a share named `public`.

## Ubuntu Steps

Install Samba with `sudo apt update && sudo apt install samba -y`. Create the folder with `sudo mkdir -p /srv/shares/public`. For lab-only open access testing, set `sudo chmod 777 /srv/shares/public`; in production, use Linux groups and tighter permissions. Create a Linux user if needed with `sudo adduser username`, then add the Samba password with `sudo smbpasswd -a username`.

## Samba Configuration

Edit `/etc/samba/smb.conf` with `sudo nano /etc/samba/smb.conf` and add a share definition: `[public]`, `path = /srv/shares/public`, `browseable = yes`, `read only = no`, `guest ok = no`, and `valid users = username`. Test syntax with `testparm`. Restart with `sudo systemctl restart smbd` and confirm status using `systemctl status smbd`.

## Windows Steps

On `CLIENT01`, open File Explorer and browse to `\\192.168.100.30\public`. Authenticate with the Samba username and password. To map a drive, use `net use Z: \\192.168.100.30\public /user:username` and enter the password when prompted. Create a small test file and confirm it appears on Ubuntu with `ls -l /srv/shares/public`.

## Troubleshooting

Check service state with `systemctl status smbd`. Check firewall with `sudo ufw status` and allow Samba or TCP 139 and 445 as appropriate. List shares locally with `smbclient -L localhost -U username`. If Windows prompts repeatedly, confirm the Samba user exists and the password was set with `smbpasswd`. Capture `![Samba share in Windows](./screenshots/samba-share.png)` after lab execution.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `samba-file-share-from-ubuntu-to-windows-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
