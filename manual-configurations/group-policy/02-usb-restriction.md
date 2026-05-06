# USB Storage Restriction

## Objective

Restrict removable USB storage access on domain-managed workstations in the `lab.local` environment.

---

# Why It Matters

USB storage restrictions help prevent:
- unauthorized data transfers
- malware introduction
- policy violations
- accidental data exposure

This lab environment uses:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| CLIENT01 | Windows Client | 192.168.100.20 |

Domain:

```text
lab.local
```

---

# Prerequisites

Before starting:

- Active Directory operational
- Group Policy Management installed
- Workstations OU available
- Domain Admin privileges available
- PowerShell running as Administrator

Verify GPMC installation:

```powershell
Get-WindowsFeature GPMC
```

Verify domain connectivity:

```powershell
Get-ADDomain
```

---

# GUI Procedure

## Create The GPO

1. Open:

```text
Server Manager
→ Tools
→ Group Policy Management
```

2. Expand:

```text
Forest: lab.local
→ Domains
→ lab.local
```

3. Right-click the Workstations OU.

4. Select:

```text
Create a GPO in this domain, and Link it here
```

5. Name the policy:

```text
SEC - Restrict USB Storage
```

---

# Configure USB Restriction Policy

Edit the GPO and browse to:

```text
Computer Configuration
→ Policies
→ Administrative Templates
→ System
→ Removable Storage Access
```

Open:

```text
All Removable Storage classes: Deny all access
```

Set the policy to:

```text
Enabled
```

Apply the policy.

---

# PowerShell Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\usb-storage-restriction.txt -Append
```

Create the GPO:

```powershell
New-GPO -Name 'SEC - Restrict USB Storage'
```

Link the GPO:

```powershell
New-GPLink `
-Name 'SEC - Restrict USB Storage' `
-Target 'OU=Workstations,OU=Computers,DC=lab,DC=local'
```

Stop logging:

```powershell
Stop-Transcript
```

---

# Verification

Update Group Policy:

```powershell
gpupdate /force
```

Generate Group Policy report:

```powershell
gpresult /h C:\Logs\usb-policy.html
```

Verify the policy is applied:

```powershell
gpresult /r
```

Test USB restriction on `CLIENT01`:
- insert USB storage device
- confirm access is blocked
- verify Windows displays restriction message

---

# Common Issues And Fixes

## GPO Not Applying

Verify:
- workstation located in correct OU
- GPO linked properly
- client can contact domain controller

Run:

```powershell
gpupdate /force
```

---

## USB Device Still Accessible

Verify policy setting:

```text
All Removable Storage classes: Deny all access
```

Ensure the policy is:

```text
Enabled
```

Restart the client if needed.

---

## DNS Or Domain Connectivity Problems

Verify DNS:

```powershell
Resolve-DnsName lab.local
```

Verify domain controller connectivity:

```powershell
Test-NetConnection DC01 -Port 389
```

---

# Screenshot Capture

![USB restriction policy](/screenshots/usb-restriction-policy.png)
