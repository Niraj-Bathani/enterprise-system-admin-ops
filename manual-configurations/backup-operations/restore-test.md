# Restore Test

## Objective

The purpose of this procedure is to validate that backups can be restored successfully. A backup is not considered operationally valid until a restore test has been completed and verified.

This restore test is performed in the `lab.local` environment using:

| Server | Role | IP Address |
|---|---|---|
| DC01 | Domain Controller | 192.168.100.10 |
| FS01 | File Server | 192.168.100.20 |
| CLIENT01 | Validation Workstation | 192.168.100.30 |

---

# Restore Test Preparation

## 1. Create Test File

Create the following test file:

```text
D:\Shares\Sales\restore-test.txt
```

Add sample content to the file:

```text
Restore validation test file
```

---

## 2. Run Backup Job

Run the scheduled backup job or manual backup operation.

Verify backup completion:

```powershell
wbadmin get versions
```

Confirm that a recent backup version exists before continuing.

---

## 3. Remove Original File

Delete or rename the original file after backup validation.

Example:

```powershell
Rename-Item 'D:\Shares\Sales\restore-test.txt' 'restore-test-old.txt'
```

---

# Restore Procedure

## Restore Using Windows Server Backup

Open:

```text
Server Manager
→ Tools
→ Windows Server Backup
```

Select:

```text
Recover
```

Complete the following steps:

1. Select backup location
2. Select backup date
3. Choose:
   - Files and folders
4. Select:
   - restore-test.txt
5. Restore to:

```text
D:\RestoreTest
```

---

# Restore Validation

## 1. Verify Restored File Exists

Run:

```powershell
Get-ChildItem D:\RestoreTest
```

Confirm:

- restore-test.txt exists
- restore completed successfully

---

## 2. Verify File Contents

Run:

```powershell
Get-Content D:\RestoreTest\restore-test.txt
```

Expected output:

```text
Restore validation test file
```

---

## 3. Verify File Hash

Run:

```powershell
Get-FileHash D:\RestoreTest\restore-test.txt
```

Confirm the restored file hash matches the original file hash recorded before deletion.

---

# Validation Criteria

The restore test passes when:

- backup version exists
- restore completed successfully
- restored file exists
- file contents match
- file hash matches
- restore location is accessible

Record:

- restore date
- restore time
- backup version used
- restore target location
- validation result

---

# Troubleshooting

## Verify Backup Versions

```powershell
wbadmin get versions
```

---

## Verify Backup Feature

```powershell
Get-WindowsFeature Windows-Server-Backup
```

---

## Verify Backup Services

```powershell
Get-Service wbengine,VSS
```

Expected service state:

```text
Running
```

---

## Verify Restore Location

```powershell
Test-Path D:\RestoreTest
```

Expected result:

```text
True
```

---

# Screenshot Capture

![Restore test](/screenshots/restore-test.png)

