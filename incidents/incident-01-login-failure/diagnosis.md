# Incident 01 Login Failure - Diagnosis

## Objective

Diagnose and identify the root cause of a Windows domain login failure in the `lab.local` environment.

---

# Environment

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| CLIENT01 | Windows Client | 192.168.100.20 |

Domain:

```text
lab.local
```

---

# Incident Summary

The reported issue involved a failed domain login attempt for a standard domain user.  
The investigation focused on:
- DNS validation
- domain controller connectivity
- account lockout status
- authentication logs
- Group Policy processing
- secure channel verification

---

# Step-By-Step Diagnosis

## Verify Client DNS Configuration

Run on `CLIENT01`:

```powershell
ipconfig /all
```

Confirm DNS server:

```text
192.168.100.10
```

---

## Verify Domain Controller Discovery

Run:

```powershell
nltest /dsgetdc:lab.local
```

Expected result:
- successful domain controller discovery
- DC01 returned as available DC

---

## Check Secure Channel

Run:

```powershell
nltest /sc_verify:lab.local
```

Expected result:

```text
NERR_Success
```

---

## Check Locked Accounts

Run:

```powershell
Search-ADAccount -LockedOut
```

Simulate unlock verification:

```powershell
Search-ADAccount -LockedOut |
Unlock-ADAccount -WhatIf
```

---

## Check User Account Status

Run:

```powershell
Get-ADUser -Identity jsmith `
-Properties Enabled,LockedOut,PasswordExpired,LastLogonDate
```

Verify:
- account enabled
- account not locked
- password valid
- recent successful logon exists

---

# Event Log Investigation

Open Event Viewer on `DC01`.

Browse to:

```text
Windows Logs
→ Security
```

Filter for these Event IDs:

| Event ID | Meaning |
|---|---|
| 4740 | Account locked out |
| 4625 | Failed logon |
| 4771 | Kerberos pre-authentication failure |

Verify:
- source workstation
- username
- timestamp
- failure reason

---

# Group Policy Validation

Run on `CLIENT01`:

```powershell
gpresult /r
```

Verify:
- correct OU processing
- expected policies applied
- no access denied processing errors

---

# Common Findings

## Account Locked Out

Unlock account:

```powershell
Unlock-ADAccount -Identity jsmith
```

---

## DNS Misconfiguration

Correct DNS settings to:

```text
192.168.100.10
```

Flush DNS cache:

```powershell
ipconfig /flushdns
```

---

## Broken Secure Channel

Repair trust relationship if verification fails.

Run:

```powershell
Test-ComputerSecureChannel -Repair -Credential lab\Administrator
```

---

# Verification

Confirm successful login using:
- standard domain user
- fresh sign-in session
- normal workstation login

Verify:
- domain authentication successful
- Group Policy refresh successful
- network drives accessible
- no new authentication failures in Security logs

---

# Screenshot Capture

![Incident login diagnosis](/screenshots/incident-01-login-diagnosis.png)

