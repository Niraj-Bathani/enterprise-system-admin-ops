<#
.SYNOPSIS
Reports stale Active Directory computer objects.

.DESCRIPTION
Identifies inactive and unused computer accounts, classifies them, and generates a structured report for cleanup review.

.PARAMETER DaysInactive
Inactive threshold in days.

.PARAMETER SearchBase
OU or domain DN.

.PARAMETER ReportPath
CSV output path.

.PARAMETER LogPath
Log file path.

.EXAMPLE
.\stale-computers-report.ps1 -DaysInactive 60 -SearchBase 'DC=lab,DC=local'
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [ValidateRange(30,3650)]
    [int]$DaysInactive=90,

    [Parameter(Mandatory)]
    [string]$SearchBase,

    [string]$ReportPath='C:\Logs\StaleComputersReport.csv',

    [string]$LogPath='C:\Logs\StaleComputersReport.log'
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

    $cutoff = (Get-Date).AddDays(-$DaysInactive)

    $computers = Get-ADComputer -SearchBase $SearchBase `
        -Filter * `
        -Properties LastLogonDate,OperatingSystem,Enabled

    $results = @()
    $inactive = 0
    $never = 0
    $disabled = 0

    foreach ($c in $computers) {

        if (-not $c.Enabled) {
            $status = "Disabled"
            $disabled++
        }
        elseif ($null -eq $c.LastLogonDate) {
            $status = "NeverLoggedIn"
            $never++
        }
        elseif ($c.LastLogonDate -lt $cutoff) {
            $status = "Inactive"
            $inactive++
        }
        else {
            continue
        }

        $results += [pscustomobject]@{
            Name            = $c.Name
            DNSHostName     = $c.DNSHostName
            OperatingSystem = $c.OperatingSystem
            LastLogonDate   = $c.LastLogonDate
            Enabled         = $c.Enabled
            Status          = $status
        }
    }

    # Ensure directory exists
    $dir = Split-Path $ReportPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item $dir -ItemType Directory -Force | Out-Null
    }

    # Sort: most critical first
    $results |
        Sort-Object Status, LastLogonDate |
        Export-Csv -NoTypeInformation -Path $ReportPath

    Write-Log "Stale computer report created: $ReportPath"

    # Summary output
    [pscustomobject]@{
        TotalReviewed = $computers.Count
        Inactive      = $inactive
        NeverLoggedIn = $never
        Disabled      = $disabled
        Report        = $ReportPath
        Timestamp     = Get-Date
    }

} catch {
    Write-Log "Stale computer report failed: $($_.Exception.Message)" "ERROR"
    throw
}