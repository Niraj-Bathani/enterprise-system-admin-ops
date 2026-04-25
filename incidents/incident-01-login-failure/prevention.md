# Incident 01 Login Failure - Prevention

## Preventive Controls

To reduce recurrence, implement controls that detect the same failure earlier and make the affected configuration easier to audit. For this incident, the recommended prevention is a lockout notification scheduled task that emails administrators when event 4740 appears. The control should be scheduled, owned, and reviewed; otherwise it becomes another undocumented script that future administrators hesitate to trust.

## Monitoring

Create a scheduled task or monitoring rule that watches the relevant Windows event IDs: 4740, 4625, 4771. For account lockouts, watch Security event `4740`. For GPO failures, collect client-side GroupPolicy operational events. For file server access problems, enable object access auditing only for the folders where the business value justifies the log volume. For DNS, monitor service health, zone replication, and failed lookup trends.

## Documentation And Training

Add a knowledge base article that describes the symptom, first checks, escalation point, and recovery command. Service desk staff should know which details to collect before escalating: username, computer, timestamp, exact error, and whether the issue follows the user. End users should receive short guidance only when it helps, such as how to update saved credentials after a password change.

## Control Review

Review the preventive control monthly. Confirm the script still runs, logs are still written, alerts reach the correct group, and the owner is current. If the organization adds a second domain controller, changes OU design, deploys endpoint management, or migrates to cloud identity, update the prevention guidance so it does not drift from reality.

## Operational Quality Notes

This procedure is written for a controlled lab using `lab.local`, `192.168.100.0/24`, and named servers such as `DC01`, `FS01`, and `CLIENT01`. In production, treat the same workflow as a controlled change. Record the request number, the business owner, the maintenance window, the rollback decision, and the validation owner before making changes. Even when a command is safe, the operational risk comes from scope. A policy linked at the domain root affects far more users than a policy linked to a test OU, and a file permission change inherited by child folders can expose or block many departments at once.

When following this guide, capture evidence at three points: the starting state, the configuration change, and the final verification. Evidence can be a PowerShell transcript, an Event Viewer screenshot, a `gpresult` HTML report, or a console screenshot saved under the matching `screenshots` folder. Keep screenshots named after the action they prove, such as `incident-01-login-failure-prevention-verification.png`, so reviewers can connect the image to the step. The screenshot image tags in this document are intentional capture targets; add the actual images after the lab run instead of using mock pictures.

For troubleshooting, work outward from the most local dependency. Confirm the command ran under the expected account, confirm the target computer can resolve `lab.local`, confirm time is synchronized, confirm Windows Firewall is not blocking the management path, and only then escalate to service-level causes. A useful operator habit is to write down the exact command, the exact error text, and the exact time. That makes event log searches much easier and keeps handoffs clean during an incident bridge.

After completing the procedure, compare the outcome with [README.md](../../ticketing-system/README.md). If the change touches identity, DNS, DHCP, or file access, wait long enough for replication or client refresh and then test from a normal user workstation instead of only from the server console. A configuration that succeeds for a domain administrator can still fail for a standard employee because of security filtering, missing group membership, user profile state, or cached credentials. Close the work only after a standard-user validation has passed and the rollback path has been confirmed.
