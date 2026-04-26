# Samba File Share From Ubuntu To Windows

## Overview

This guide demonstrates how to configure a Samba file share on Ubuntu and access it from a Windows client. It shows cross-platform file sharing, authentication, and troubleshooting.

---

## What This Demonstrates

- Linux file sharing using Samba (SMB)
- Windows access to Linux resources
- Cross-platform authentication and permissions
- Troubleshooting SMB connectivity issues

---

## Objective

Share a directory from Ubuntu Server and access it from a Windows client using SMB.

---

## Lab Environment

- Ubuntu Server: `UBUNTU01 (192.168.100.30)`
- Windows Client: `CLIENT01 (192.168.100.20)`
- Share Name: `public`

---

## Ubuntu Setup

### Install Samba

```bash
sudo apt update
sudo apt install samba -y
Create Share Directory
sudo mkdir -p /srv/shares/public
sudo chmod 777 /srv/shares/public   # Lab only
Create User (if needed)
sudo adduser username
sudo smbpasswd -a username
Samba Configuration

Edit config file:

sudo nano /etc/samba/smb.conf

Add:

[public]
   path = /srv/shares/public
   browseable = yes
   read only = no
   guest ok = no
   valid users = username

Validate and restart:

testparm
sudo systemctl restart smbd
sudo systemctl status smbd
Windows Access

Open File Explorer:

\\192.168.100.30\public

Or map drive:

net use Z: \\192.168.100.30\public /user:username

Create a test file and verify on Ubuntu:

ls -l /srv/shares/public
Expected Outcome
Windows can access the shared folder
Authentication works using Samba credentials
Files created on Windows appear on Ubuntu
Samba service is running and accessible
Validation Checklist
 Samba service is active (systemctl status smbd)
 Share appears from Windows
 Authentication succeeds
 File creation works both ways

📸 Screenshot:

![Samba share in Windows](./screenshots/samba-share.png)
Troubleshooting

If access fails:

Check Samba service:

systemctl status smbd

Check firewall:

sudo ufw status

List shares:

smbclient -L localhost -U username

Verify credentials:

sudo smbpasswd -a username
Production Considerations
Use proper Linux group permissions instead of 777
Restrict access using valid users or groups
Disable guest access
Monitor Samba logs
Apply firewall restrictions
Summary

This guide demonstrates how to configure and validate a Samba file share between Linux and Windows systems. It reflects real-world cross-platform administration and troubleshooting skills.