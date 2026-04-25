<#
.SYNOPSIS
Disables Active Directory users inactive for a specified number of days.

.DESCRIPTION
Finds enabled users with LastLogonDate older than the threshold, excludes protected accounts, disables them, and writes a CSV report. Use WhatIf before production execution.

.PARAMETER DaysInactive
Inactive threshold in days.
.PARAMETER SearchBase
OU or domain DN to search.
.PARAMETER ExcludeSamAccountName
Accounts to exclude.
.PARAMETER ReportPath
CSV report path.
.PARAMETER LogPath
Log file path.

.EXAMPLE
./disable-inactive-users.ps1 -DaysInactive 90 -SearchBase 'OU=Users,DC=lab,DC=local' -WhatIf
#>
[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [Parameter()]
    [ValidateRange(30,3650)]
    [int]$DaysInactive = 90,
    [Parameter(Mandatory)]
    [ValidatePattern('^(OU|DC)=')]
    [string]$SearchBase,
    [Parameter()]
    [string[]]$ExcludeSamAccountName = @('administrator','krbtgt'),
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ReportPath = 'C:\Logs\InactiveUsers.csv',
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$LogPath = 'C:\Logs\DisableInactiveUsers.log'
)
function Write-Log { param([string]$Message,[ValidateSet('INFO','WARN','ERROR')]$Level='INFO'); $d=Split-Path $LogPath -Parent; if(-not(Test-Path $d)){New-Item $d -ItemType Directory -Force|Out-Null}; Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message" }
try {
    Import-Module ActiveDirectory -ErrorAction Stop
    $cutoff = (Get-Date).AddDays(-$DaysInactive)
    $users = Get-ADUser -SearchBase $SearchBase -Filter { Enabled -eq $true } -Properties LastLogonDate,Department -ErrorAction Stop |
        Where-Object { $_.SamAccountName -notin $ExcludeSamAccountName -and ($null -eq $_.LastLogonDate -or $_.LastLogonDate -lt $cutoff) }
    $outDir = Split-Path $ReportPath -Parent; if(-not(Test-Path $outDir)){New-Item $outDir -ItemType Directory -Force|Out-Null}
    $users | Select-Object SamAccountName,Name,Department,LastLogonDate | Export-Csv -NoTypeInformation -Path $ReportPath
    foreach($u in $users){
        if($PSCmdlet.ShouldProcess($u.SamAccountName, "Disable inactive user")){
            Disable-ADAccount -Identity $u -ErrorAction Stop
            Write-Log "Disabled inactive user '$($u.SamAccountName)' last logon '$($u.LastLogonDate)'."
        }
    }
    Write-Log "Processed $($users.Count) inactive users. Report: $ReportPath"
}
catch { Write-Log "Inactive user disable failed: $($_.Exception.Message)" 'ERROR'; throw }
