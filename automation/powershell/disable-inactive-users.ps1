<#
.SYNOPSIS
Disables inactive Active Directory users.

.DESCRIPTION
Identifies enabled users who have not logged in within a specified number of days. Excludes protected accounts, disables inactive users, logs actions, and generates a structured report.

.PARAMETER DaysInactive
Threshold in days.

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
    [ValidateRange(30,3650)]
    [int]$DaysInactive = 90,

    [Parameter(Mandatory)]
    [string]$SearchBase,

    [string[]]$ExcludeSamAccountName = @('administrator','krbtgt'),

    [string]$ReportPath = 'C:\Logs\InactiveUsers.csv',

    [string]$LogPath = 'C:\Logs\DisableInactiveUsers.log'
)

function Write-Log {
    param([string]$Message, [ValidateSet('INFO','WARN','ERROR')] [string]$Level='INFO')
    $dir = Split-Path $LogPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item $dir -ItemType Directory -Force | Out-Null
    }
    Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message"
}

try {
    Import-Module ActiveDirectory -ErrorAction Stop

    # Domain validation
    if (-not (Get-ADDomain -ErrorAction SilentlyContinue)) {
        throw "Unable to connect to Active Directory"
    }

    $cutoff = (Get-Date).AddDays(-$DaysInactive)

    $users = Get-ADUser -SearchBase $SearchBase `
        -Filter { Enabled -eq $true } `
        -Properties LastLogonDate,Department |
        Where-Object {
            $_.SamAccountName -notin $ExcludeSamAccountName -and
            ($null -eq $_.LastLogonDate -or $_.LastLogonDate -lt $cutoff)
        }

    $results = @()
    $disabled = 0
    $skipped = 0

    $outDir = Split-Path $ReportPath -Parent
    if (-not (Test-Path $outDir)) {
        New-Item $outDir -ItemType Directory -Force | Out-Null
    }

    foreach ($u in $users) {
        try {
            $status = if ($null -eq $u.LastLogonDate) {
                "NeverLoggedIn"
            } else {
                "Inactive"
            }

            if ($PSCmdlet.ShouldProcess($u.SamAccountName, "Disable inactive user")) {
                Disable-ADAccount -Identity $u -ErrorAction Stop
                Write-Log "Disabled '$($u.SamAccountName)' ($status)" "WARN"
                $disabled++
            } else {
                $skipped++
            }

            $results += [pscustomobject]@{
                SamAccountName = $u.SamAccountName
                Name           = $u.Name
                Department     = $u.Department
                LastLogonDate  = $u.LastLogonDate
                Status         = $status
            }

        } catch {
            Write-Log "Failed: $($u.SamAccountName) - $($_.Exception.Message)" "ERROR"
        }
    }

    $results | Export-Csv -NoTypeInformation -Path $ReportPath

    Write-Log "Completed. Disabled: $disabled, Skipped: $skipped, Total: $($users.Count)"

    [pscustomobject]@{
        Disabled = $disabled
        Skipped  = $skipped
        Total    = $users.Count
        Report   = $ReportPath
    }

} catch {
    Write-Log "Script failed: $($_.Exception.Message)" "ERROR"
    throw
}