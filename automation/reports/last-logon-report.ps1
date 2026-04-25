<#
.SYNOPSIS
Exports Active Directory users with last logon information.

.DESCRIPTION
Queries AD users in a search base, includes enabled state and department, and writes a CSV for operational review.

.PARAMETER SearchBase
Distinguished name to search.
.PARAMETER ReportPath
CSV path.
.PARAMETER LogPath
Log file path.

.EXAMPLE
./last-logon-report.ps1 -SearchBase 'OU=Users,DC=lab,DC=local'
#>
[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [Parameter(Mandatory)][ValidatePattern('^(OU|DC)=')][string]$SearchBase,
    [Parameter()][ValidateNotNullOrEmpty()][string]$ReportPath='C:\Logs\LastLogonReport.csv',
    [Parameter()][ValidateNotNullOrEmpty()][string]$LogPath='C:\Logs\LastLogonReport.log'
)
function Write-Log { param([string]$Message,[ValidateSet('INFO','WARN','ERROR')]$Level='INFO'); $d=Split-Path $LogPath -Parent; if(-not(Test-Path $d)){New-Item $d -ItemType Directory -Force|Out-Null}; Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message" }
try{
    Import-Module ActiveDirectory -ErrorAction Stop
    $rows = Get-ADUser -SearchBase $SearchBase -Filter * -Properties LastLogonDate,Department,Enabled -ErrorAction Stop |
        Select-Object SamAccountName,Name,Department,Enabled,LastLogonDate
    $dir=Split-Path $ReportPath -Parent; if(-not(Test-Path $dir)){New-Item $dir -ItemType Directory -Force|Out-Null}
    $rows | Export-Csv -NoTypeInformation -Path $ReportPath
    Write-Log "Wrote $($rows.Count) last-logon rows to '$ReportPath'."
    $rows
} catch { Write-Log "Last logon report failed: $($_.Exception.Message)" 'ERROR'; throw }
