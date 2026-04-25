<#
.SYNOPSIS
Reports Active Directory computer objects inactive for a threshold.

.DESCRIPTION
Finds computers with LastLogonDate older than the threshold and exports them for cleanup review.

.PARAMETER DaysInactive
Inactive threshold.
.PARAMETER SearchBase
Computer OU or domain DN.
.PARAMETER ReportPath
CSV path.
.PARAMETER LogPath
Log path.

.EXAMPLE
./stale-computers-report.ps1 -DaysInactive 60 -SearchBase 'DC=lab,DC=local'
#>
[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [Parameter()][ValidateRange(30,3650)][int]$DaysInactive=90,
    [Parameter(Mandatory)][ValidatePattern('^(OU|DC)=')][string]$SearchBase,
    [Parameter()][ValidateNotNullOrEmpty()][string]$ReportPath='C:\Logs\StaleComputersReport.csv',
    [Parameter()][ValidateNotNullOrEmpty()][string]$LogPath='C:\Logs\StaleComputersReport.log'
)
function Write-Log { param([string]$Message,[ValidateSet('INFO','WARN','ERROR')]$Level='INFO'); $d=Split-Path $LogPath -Parent; if(-not(Test-Path $d)){New-Item $d -ItemType Directory -Force|Out-Null}; Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message" }
try{
    Import-Module ActiveDirectory -ErrorAction Stop
    $cutoff=(Get-Date).AddDays(-$DaysInactive)
    $rows=Get-ADComputer -SearchBase $SearchBase -Filter * -Properties LastLogonDate,OperatingSystem -ErrorAction Stop |
        Where-Object { $null -eq $_.LastLogonDate -or $_.LastLogonDate -lt $cutoff } |
        Select-Object Name,DNSHostName,OperatingSystem,LastLogonDate,Enabled
    $dir=Split-Path $ReportPath -Parent; if(-not(Test-Path $dir)){New-Item $dir -ItemType Directory -Force|Out-Null}
    $rows | Export-Csv -NoTypeInformation -Path $ReportPath
    Write-Log "Wrote $($rows.Count) stale computers to '$ReportPath'."
    $rows
} catch { Write-Log "Stale computer report failed: $($_.Exception.Message)" 'ERROR'; throw }
