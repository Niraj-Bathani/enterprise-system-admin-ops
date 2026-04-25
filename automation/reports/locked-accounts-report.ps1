<#
.SYNOPSIS
Exports currently locked Active Directory user accounts.

.DESCRIPTION
Uses Search-ADAccount to identify locked accounts, writes a report, and logs the count for service desk monitoring.

.PARAMETER ReportPath
CSV path.
.PARAMETER LogPath
Log file path.

.EXAMPLE
./locked-accounts-report.ps1
#>
[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [Parameter()][ValidateNotNullOrEmpty()][string]$ReportPath='C:\Logs\LockedAccountsReport.csv',
    [Parameter()][ValidateNotNullOrEmpty()][string]$LogPath='C:\Logs\LockedAccountsReport.log'
)
function Write-Log { param([string]$Message,[ValidateSet('INFO','WARN','ERROR')]$Level='INFO'); $d=Split-Path $LogPath -Parent; if(-not(Test-Path $d)){New-Item $d -ItemType Directory -Force|Out-Null}; Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message" }
try{
    Import-Module ActiveDirectory -ErrorAction Stop
    $rows = Search-ADAccount -LockedOut -UsersOnly -ErrorAction Stop | Get-ADUser -Properties Department,LockedOut,LastBadPasswordAttempt |
        Select-Object SamAccountName,Name,Department,LockedOut,LastBadPasswordAttempt
    $dir=Split-Path $ReportPath -Parent; if(-not(Test-Path $dir)){New-Item $dir -ItemType Directory -Force|Out-Null}
    $rows | Export-Csv -NoTypeInformation -Path $ReportPath
    Write-Log "Wrote $($rows.Count) locked accounts to '$ReportPath'."
    $rows
} catch { Write-Log "Locked account report failed: $($_.Exception.Message)" 'ERROR'; throw }
