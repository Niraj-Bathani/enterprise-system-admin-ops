````markdown
# Backup Plan

## Objective

Create a practical backup strategy for the `lab.local` environment that demonstrates enterprise backup planning, recovery preparation, retention management, and restore validation. The goal of this lab is not only to create backups, but also to prove that services and data can be recovered after failure.

This backup workflow protects:

- `DC01` system state and Active Directory
- `FS01` shared folder data
- DHCP configuration
- DNS configuration and zones where applicable
- Group Policy backups and reports
- PowerShell automation scripts
- Repository documentation and operational evidence

The lab environment uses:

- `DC01` — `192.168.100.10`
- `FS01` — file services
- `CLIENT01` — validation workstation
- `lab.local` — Active Directory domain

---

# Backup Scope

## Domain Controller Protection

Domain controllers contain:

- Active Directory database
- SYSVOL
- Group Policy objects
- DNS integration
- Kerberos and authentication services

A system state backup is critical in single-domain-controller environments because there is no second DC available for replication recovery.

Back up:

- System State
- SYSVOL
- Registry
- Boot files
- AD database (`NTDS.dit`)

---

## File Server Protection

Protect:

- Department shares
- User-accessible documents
- Shared scripts
- Configuration exports
- Operational evidence

Recommended folders:

```text
C:\Shares
C:\Scripts
C:\Logs
````

Avoid storing backups on the same disk being protected.

---

## Configuration Backups

Export and retain:

* GPO reports
* DHCP configuration
* DNS zone exports
* Scheduled task exports
* Firewall configurations

Example export commands:

```powershell
Backup-GPO -All -Path C:\Backups\GPO
Export-DhcpServer -File C:\Backups\dhcp.xml -Leases
```

---

# Backup Schedule

| Backup Type          | Frequency | Retention       | Notes                         |
| -------------------- | --------- | --------------- | ----------------------------- |
| File backup          | Daily     | 7 daily copies  | Department shares and scripts |
| System state         | Weekly    | 4 weekly copies | Protect Active Directory      |
| GPO export           | Weekly    | 4 copies        | Track policy changes          |
| DHCP export          | Weekly    | 4 copies        | Preserve reservations/scopes  |
| Documentation backup | Daily     | 14 copies       | Protect operational evidence  |

---

# Backup Storage Design

Use a dedicated backup target such as:

* External disk
* Secondary virtual disk
* NAS share
* Separate datastore

Do NOT store backups only on the source server.

Example:

```text
E:\Backups
```

Production environments should use:

* Immutable storage where possible
* Offsite replication
* Multi-location retention
* Encrypted backup repositories

---

# Install Windows Server Backup

Install the feature on `DC01`:

```powershell
Install-WindowsFeature Windows-Server-Backup
```

Verify installation:

```powershell
Get-WindowsFeature Windows-Server-Backup
```

---

# Perform System State Backup

Run a manual system state backup:

```powershell
wbadmin start systemstatebackup -backupTarget:E: -quiet
```

Expected result:

* Backup starts successfully
* Event logs show completion
* Backup files appear under the target path

Verify backup versions:

```powershell
wbadmin get versions
```

---

# File Backup Example

Copy shared data using `Robocopy`:

```powershell
robocopy C:\Shares E:\Backups\Shares /MIR /R:1 /W:1 /LOG:C:\Logs\Robocopy.log
```

Explanation:

* `/MIR` mirrors folder structure
* `/R:1` retries once
* `/W:1` waits one second between retries
* `/LOG` creates operational evidence

---

# Restore Validation

A backup is incomplete until restore testing succeeds.

Perform these validation tasks:

1. Restore a sample file to an alternate location.
2. Verify restored permissions.
3. Confirm restored file integrity.
4. Validate GPO backup readability.
5. Confirm system state backup versions exist.

Example file restore test:

```powershell
Copy-Item E:\Backups\Shares\Test.txt C:\RestoreTest\
```

---

# Verification

Run the following checks after backup execution:

```powershell
wbadmin get versions
```

```powershell
Get-WinEvent -LogName Application | Where-Object ProviderName -Match 'Backup'
```

```powershell
Get-ChildItem E:\Backups
```

Validation should confirm:

* Backup completed successfully
* Backup target contains data
* No critical errors occurred
* Restore testing succeeded

---

# Common Issues And Fixes

* **Access denied:** Confirm the backup account has administrative rights and access to the target storage.

* **Backup target not found:** Verify the disk is mounted and accessible before execution.

* **Insufficient disk space:** Monitor retention growth and remove expired backups safely.

* **VSS writer failures:** Restart affected services and verify Volume Shadow Copy health using:

```powershell
vssadmin list writers
```

* **Corrupted restore test:** Validate storage health and rerun backup after correcting the issue.

---

# Screenshot Capture

![Backup verification](/screenshots/backup-verify.png)

Capture the following evidence:

* Windows Server Backup success message
* `wbadmin get versions` output
* Restore validation proof
* Backup destination contents

Recommended filename:

```text
backup-verify.png
```

---

# Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named systems such as `DC01`, `FS01`, and `CLIENT01`.

In production:

* Schedule backups during maintenance windows
* Assign ownership for restore testing
* Document retention requirements
* Encrypt backup storage
* Protect backup credentials
* Monitor backup job failures automatically

Backups should support:

* Recovery Point Objective (RPO)
* Recovery Time Objective (RTO)
* Compliance requirements
* Incident response
* Disaster recovery planning

The most important operational rule is:

> A backup that has never been restored is only a theory.

Always validate recovery procedures regularly.
