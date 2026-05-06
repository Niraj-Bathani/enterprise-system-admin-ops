````markdown
# Mapped Drive Policy

## Objective

Deploy a mapped network drive for the Sales department share using Group Policy.

---

## Prerequisites

- Domain controller: `DC01`
- Domain: `lab.local`
- File share: `\\FS01\Sales`
- User OU: `OU=Sales,OU=Users,DC=lab,DC=local`
- Security group: `GG_Sales_Users`
- Administrative access to Group Policy Management Console

---

## GUI Procedure

1. Open **Group Policy Management** on `DC01`.
2. Right-click the Sales users OU and select:

   ```text
   Create a GPO in this domain, and Link it here
````

3. Name the GPO:

   ```text
   USR - Map Sales Drive
   ```

4. Edit the new GPO.

5. Navigate to:

   ```text
   User Configuration
    └─ Preferences
       └─ Windows Settings
          └─ Drive Maps
   ```

6. Right-click and select:

   ```text
   New → Mapped Drive
   ```

7. Configure the mapped drive:

   | Setting      | Value          |
   | ------------ | -------------- |
   | Action       | Update         |
   | Location     | `\\FS01\Sales` |
   | Label        | Sales          |
   | Drive Letter | `S:`           |
   | Reconnect    | Enabled        |

8. Click **OK**.

9. Run policy update on `CLIENT01`.

---

## PowerShell Procedure

```powershell
Start-Transcript -Path C:\Logs\mapped-drive-policy.txt -Append
```

```powershell
New-GPO -Name 'USR - Map Sales Drive'
```

```powershell
New-GPLink -Name 'USR - Map Sales Drive' -Target 'OU=Sales,OU=Users,DC=lab,DC=local'
```

```powershell
gpupdate /force
```

```powershell
Stop-Transcript
```

---

## Verification

Run the following commands on `CLIENT01`:

```powershell
gpupdate /force
```

```powershell
gpresult /r
```

```powershell
net use
```

Expected result:

* Drive `S:` appears in File Explorer
* `\\FS01\Sales` is mapped successfully
* User can access and create files in the share

---

## Common Issues And Fixes

| Issue                    | Resolution                                           |
| ------------------------ | ---------------------------------------------------- |
| Drive does not appear    | Confirm the user account is located in the linked OU |
| Access denied            | Verify NTFS and share permissions                    |
| GPO not applying         | Run `gpupdate /force` and verify with `gpresult /r`  |
| Network path unavailable | Confirm DNS resolution and SMB connectivity          |

---

## Screenshot Capture

![Mapped drive policy](/screenshots/mapped-drive-policy.png)



