# Windows Sysadmin Interview Questions

## Questions And Answers

1. **Explain FSMO roles and why they matter.** FSMO roles are specialized Active Directory roles that prevent conflicting changes for certain operations. Schema Master and Domain Naming Master are forest-wide, while RID Master, PDC Emulator, and Infrastructure Master are domain-wide. The PDC Emulator is especially visible because it handles time priority, password changes, and lockout behavior.

2. **How do you force a GPO update on all domain computers?** Locally, run `gpupdate /force`. Remotely, use Group Policy Management Console to run Group Policy Update against an OU, or use PowerShell remoting with care. I verify with `gpresult /r` or an HTML report because triggering refresh does not prove the intended policy applied.

3. **Write a PowerShell script to find users who have not logged in for 90 days.** Use `Get-ADUser -Filter * -Properties LastLogonDate`, compare `LastLogonDate` to `(Get-Date).AddDays(-90)`, and export results to CSV. In production I exclude service accounts and privileged accounts from automatic disablement until owners approve.

4. **What is the difference between a security group and a distribution group?** A security group can be used in ACLs to grant access to resources and can also be mail-enabled. A distribution group is intended for email distribution and cannot grant file or application permissions.

5. **How do you recover a deleted AD object?** If the AD Recycle Bin is enabled, use Active Directory Administrative Center or `Restore-ADObject`. Without it, recovery may require authoritative restore from backup. I first confirm the object, deletion time, and dependencies such as group membership.

6. **How do NTFS and share permissions combine?** The most restrictive effective permission wins when accessing over the network. I usually set share permissions broadly and enforce detailed access with NTFS groups.

7. **What causes account lockouts?** Common causes include old saved credentials, mapped drives, mobile email clients, scheduled tasks, services, and repeated user mistakes. Event `4740` on the domain controller helps identify the source workstation.

8. **How do you troubleshoot DNS in an AD domain?** I check client DNS server, resolve the domain and SRV records, test port 53, inspect zone records, and confirm AD replication. Many domain issues are really DNS misconfiguration.

9. **What is SYSVOL used for?** SYSVOL stores domain public files including Group Policy templates and scripts replicated to domain controllers. If SYSVOL or NETLOGON shares are missing, policy and logon script processing can fail.

10. **How do you safely patch domain controllers?** Patch one at a time where multiple DCs exist, verify replication and health before and after, and ensure backups are current. In a single-DC lab, I snapshot or back up first and schedule downtime.

11. **What is Kerberos token bloat?** Token bloat happens when a user belongs to too many groups, increasing the Kerberos token size and potentially causing authentication failures. It is mitigated by group cleanup and better role design.

12. **How do you map a drive with GPO?** Use User Configuration, Preferences, Windows Settings, Drive Maps. Link the GPO to the user OU and validate with `gpresult` and `net use`.

13. **How do you identify stale computers?** Query `Get-ADComputer` with `LastLogonDate`, compare against a threshold, and validate with endpoint inventory before disabling. Some systems may be offline for legitimate reasons.

14. **What is the difference between a lab and production change?** A lab change proves the technical steps. A production change adds approval, communication, rollback, monitoring, and business validation.

15. **How do you respond to a P1 outage?** Establish impact, start an incident bridge, assign roles, preserve evidence, restore service using the safest known path, and communicate regularly. Root cause analysis follows after service is restored.
