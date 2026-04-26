# SSH Key Administration For Linux

## Overview

This guide demonstrates how to configure SSH key-based authentication from a Windows system to an Ubuntu server. It improves security by eliminating password-based logins and enables efficient remote administration.

---

## What This Demonstrates

- Secure remote access using SSH keys  
- Cross-platform administration (Windows → Linux)  
- Authentication hardening practices  
- Troubleshooting SSH connectivity  

---

## Objective

Generate SSH keys on Windows and use them to securely connect to an Ubuntu server without using passwords.

---

## Lab Environment

- Windows Client: CLIENT01 (192.168.100.20)  
- Ubuntu Server: UBUNTU01 (192.168.100.30)  

---

## Generate SSH Key (Windows)

Open PowerShell:

```powershell
ssh-keygen -t ed25519 -C "jsmith-lab-admin"

Optional custom path:

ssh-keygen -t ed25519 -f $env:USERPROFILE\.ssh\lab_ed25519

Verify key:

Get-Content $env:USERPROFILE\.ssh\lab_ed25519.pub
Install Public Key (Ubuntu)
mkdir -p ~/.ssh
chmod 700 ~/.ssh

Add public key:

nano ~/.ssh/authorized_keys

Set permissions:

chmod 600 ~/.ssh/authorized_keys
Connect Using SSH Key
ssh -i $env:USERPROFILE\.ssh\lab_ed25519 username@192.168.100.30
Expected Outcome
SSH login works without password
Server accepts key authentication
Connection is secure and repeatable
Validation Checklist
 SSH connection succeeds without password
 .ssh directory permissions are correct
 authorized_keys contains the public key
 No authentication errors occur

📸 Screenshot:

![SSH key login](./screenshots/ssh-key-login.png)
Hardening

After confirming key-based login:

Edit SSH config:

sudo nano /etc/ssh/sshd_config

Set:

PasswordAuthentication no

Restart SSH:

sudo systemctl restart ssh

Always test a second session before closing the first.

Troubleshooting

Client-side:

ssh -vvv username@192.168.100.30

Server-side:

sudo journalctl -u ssh --since "30 minutes ago"

Common issues:

Incorrect permissions on .ssh or authorized_keys
Wrong key file used
SSH service not running
Production Considerations
Disable password authentication
Use strong key types (ed25519 or rsa 4096)
Restrict SSH access via firewall
Monitor authentication logs
Summary

This guide demonstrates secure SSH key-based access from Windows to Linux. It reflects real-world administrative practices focused on security, efficiency, and reliability.