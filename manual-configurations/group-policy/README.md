# Group Policy Manual Configuration

## Purpose

This section covers practical Group Policy administration in the `lab.local` environment using Windows Server 2022 and domain-joined Windows clients.

The procedures focus on:

- password and lockout policy management
- USB storage restrictions
- mapped drive deployment
- Group Policy troubleshooting
- policy validation and verification

Lab systems used throughout this section:

| System | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| CLIENT01 | Windows Client | 192.168.100.20 |
| UBUNTU01 | Ubuntu Test Host | 192.168.100.30 |

Domain:

```text
lab.local
```

---

## Recommended Order

1. [01-password-policy.md](01-password-policy.md)  
   Configure domain password and account lockout policies.

2. [02-usb-restriction.md](02-usb-restriction.md)  
   Restrict removable USB storage devices on managed clients.

3. [03-mapped-drive.md](03-mapped-drive.md)  
   Deploy department mapped drives using Group Policy.

4. [04-gpupdate-troubleshooting.md](04-gpupdate-troubleshooting.md)  
   Diagnose and resolve Group Policy processing issues.

---

## Operating Standard

When working with Group Policy:

- use clear naming standards
- link GPOs only where required
- test changes in a pilot OU first
- verify policy application using `gpresult`
- collect screenshots and logs after validation
- document all policy changes

Store screenshots inside:

```text
/screenshots/
```

Use consistent filenames matching the procedure being validated.

---

## Validation Pattern

Each procedure follows the same validation workflow:

1. Configure the policy.
2. Force Group Policy update.
3. Verify policy application.
4. Test the expected client behavior.
5. Review logs and reports if issues occur.

Common validation commands:

```powershell
gpupdate /force
```

```powershell
gpresult /r
```

```powershell
gpresult /h C:\Logs\gpresult.html
```

---

## Troubleshooting Mindset

When troubleshooting Group Policy:

- verify DNS first
- confirm OU placement
- confirm security filtering
- verify domain connectivity
- check replication health
- review Event Viewer logs
- verify SYSVOL access

Useful validation commands:

```powershell
Resolve-DnsName lab.local
```

```powershell
repadmin /replsummary
```

```powershell
Test-ComputerSecureChannel -Verbose
```

---

## Production Notes

In production environments:

- use change approval processes
- test policies in pilot groups
- schedule deployments during maintenance windows
- maintain rollback procedures
- document all policy modifications
- notify support teams before rollout

The lab environment is intentionally simplified, but the same operational workflow applies to enterprise deployments.
