# Password And Lockout Policy

## Objective

Configure the default domain password policy and account lockout policy in the `lab.local` environment.

---

# Why It Matters

Password and lockout policies help protect domain accounts from weak passwords and brute-force attacks.

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

- Active Directory Domain Services installed
- Domain controller operational
- Group Policy Management installed
- PowerShell running as Administrator
- Domain Admin account available

Verify domain connectivity:

```powershell
Get-ADDomain
```

Verify Group Policy Management:

```powershell
Get-WindowsFeature GPMC
```

---

# GUI Procedure

## Open Group Policy Management

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

3. Right-click:

```text
Default Domain Policy
→ Edit
```

---

# Configure Password Policy

Browse to:

```text
Computer Configuration
→ Policies
→ Windows Settings
→ Security Settings
→ Account Policies
→ Password Policy
```

Configure:

| Setting | Value |
|---|---|
| Enforce password history | 24 passwords |
| Maximum password age | 90 days |
| Minimum password length | 8 characters |
| Password complexity | Enabled |

---

# Configure Account Lockout Policy

Browse to:

```text
Computer Configuration
→ Policies
→ Windows Settings
→ Security Settings
→ Account Policies
→ Account Lockout Policy
```

Configure:

| Setting | Value |
|---|---|
| Account lockout threshold | 5 invalid attempts |
| Account lockout duration | 30 minutes |
| Reset account lockout counter | 30 minutes |

---

# PowerShell Procedure

Start logging:

```powershell
Start-Transcript -Path C:\Logs\password-and-lockout-policy.txt -Append
```

Configure password policy:

```powershell
Set-ADDefaultDomainPasswordPolicy `
-Identity lab.local `
-PasswordHistoryCount 24 `
-MaxPasswordAge 90.00:00:00 `
-MinPasswordLength 8 `
-ComplexityEnabled $true `
-LockoutThreshold 5 `
-LockoutDuration 00:30:00 `
-LockoutObservationWindow 00:30:00
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

Verify local policy settings:

```powershell
net accounts
```

Verify Active Directory password policy:

```powershell
Get-ADDefaultDomainPasswordPolicy -Identity lab.local
```

Expected results:
- password complexity enabled
- minimum password length configured
- lockout threshold configured
- lockout duration configured

---

# Common Issues And Fixes

## Group Policy Not Applying

Run:

```powershell
gpresult /r
```

Verify:
- Default Domain Policy linked correctly
- client can contact domain controller
- DNS functioning properly

---

## Unexpected Account Lockouts

Review security event logs:

```text
Event ID 4740
```

Check for:
- cached passwords
- mapped drives
- old credentials
- scheduled tasks

---

## DNS Or Connectivity Issues

Verify DNS configuration:

```powershell
Resolve-DnsName lab.local
```

Verify domain controller connectivity:

```powershell
Test-NetConnection DC01 -Port 389
```

---

# Screenshot Capture

![Password GPO](/screenshots/gpo-password-policy.png)
