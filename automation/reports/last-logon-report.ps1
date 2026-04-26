<#
.SYNOPSIS
Exports Active Directory users with last logon information.

.DESCRIPTION
Queries AD users, classifies activity status, and generates a structured report for operational review.

.PARAMETER SearchBase
Distinguished name to search.

.PARAMETER InactiveDays
Threshold for inactivity classification.

.PARAMETER ReportPath
CSV output path.

.PARAMETER LogPath
Log file path.

.EXAMPLE
.\last-logon-report.ps1 -SearchBase 'OU=Users,DC=lab,DC=local' -InactiveDays 30
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory)]
    [string]$SearchBase,

    [int]$InactiveDays = 30,

    [string]$ReportPath='C:\Logs\LastLogonReport.csv',

    [string]$LogPath='C:\Logs\LastLogonReport.log'
)

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('INFO','WARN','ERROR')]
        [string]$Level='INFO'
    )
    $dir = Split-Path $LogPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item $dir -ItemType Directory -Force | Out-Null
    }
    Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message"
}

try {
    Import-Module ActiveDirectory -ErrorAction Stop

    # Domain check
    if (-not (Get-ADDomain -ErrorAction SilentlyContinue)) {
        throw "Unable to connect to Active Directory"
    }

    $cutoff = (Get-Date).AddDays(-$InactiveDays)

    $users = Get-ADUser -SearchBase $SearchBase `
        -Filter * `
        -Properties LastLogonDate,Department,Enabled

    $results = @()
    $inactive = 0
    $neverLogged = 0
    $active = 0

    foreach ($u in $users) {

        if ($null -eq $u.LastLogonDate) {
            $status = "NeverLoggedIn"
            $neverLogged++
        }
        elseif ($u.LastLogonDate -lt $cutoff) {
            $status = "Inactive"
            $inactive++
        }
        else {
            $status = "Active"
            $active++
        }

        $results += [pscustomobject]@{
            SamAccountName = $u.SamAccountName
            Name           = $u.Name
            Department     = $u.Department
            Enabled        = $u.Enabled
            LastLogonDate  = $u.LastLogonDate
            Status         = $status
        }
    }

    # Save report
    $dir = Split-Path $ReportPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item $dir -ItemType Directory -Force | Out-Null
    }

    $results |
        Sort-Object Status, SamAccountName |
        Export-Csv -NoTypeInformation -Path $ReportPath

    Write-Log "Report created: $ReportPath"

    # Summary
    [pscustomobject]@{
        TotalUsers      = $users.Count
        Active          = $active
        Inactive        = $inactive
        NeverLoggedIn   = $neverLogged
        Report          = $ReportPath
    }

} catch {
    Write-Log "Last logon report failed: $($_.Exception.Message)" "ERROR"
    throw
}