# Cross-Platform Administration

## Overview

This section demonstrates how Windows and Linux systems are integrated and managed together. It focuses on file sharing and secure remote access between Ubuntu and Windows environments.

---

## What This Section Demonstrates

- Cross-platform system administration (Windows + Linux)  
- File sharing using Samba  
- Secure remote access using SSH keys  
- Validation and troubleshooting across different operating systems  

---

## Why This Matters

Most enterprise environments are not purely Windows or Linux—they are mixed.

System administrators must:

- Access Linux servers from Windows systems  
- Share files between platforms  
- Troubleshoot network and permission issues across OS boundaries  

This section demonstrates those real-world tasks.

---

## Lab Context

- Domain: `lab.local`  
- Windows Client: `CLIENT01 (192.168.100.20)`  
- Ubuntu Server: `UBUNTU01 (192.168.100.30)`  

---

## Tasks Covered

- [samba-file-share.md](samba-file-share.md)  
  Configure a Samba share on Ubuntu and access it from Windows.

- [ssh-key-linux.md](ssh-key-linux.md)  
  Configure SSH key-based authentication for secure remote access.

---

## Example Commands

### Samba (Ubuntu)

```bash
sudo apt install samba -y
sudo systemctl enable smbd
sudo systemctl start smbd
SSH Key (Windows → Linux)
ssh-keygen
ssh-copy-id user@192.168.100.30
Expected Outcome
Windows system can access Linux share via UNC path
SSH login works without password
File permissions behave correctly
Services (Samba, SSH) are running and reachable
Operating Standard

When working across platforms:

Validate configuration on both systems
Check firewall rules on Linux and Windows
Use consistent user permissions
Avoid assumptions about default configurations
Troubleshooting Approach

If access fails:

Verify network connectivity (ping)
Check DNS resolution
Confirm service status (Samba/SSH)
Validate permissions
Review logs (/var/log/ on Linux, Event Viewer on Windows)
Production Considerations
Use secure authentication (SSH keys, not passwords)
Restrict Samba access to specific users or networks
Monitor access logs
Apply least privilege principles
Summary

This section demonstrates how to manage and integrate Windows and Linux systems in a shared environment. It reflects real-world administrative tasks where cross-platform compatibility and troubleshooting are essential.