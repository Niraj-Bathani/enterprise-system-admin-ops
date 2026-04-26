<#
.SYNOPSIS
Exports currently locked Active Directory user accounts.

.DESCRIPTION
Identifies locked user accounts, classifies lockout recency, generates a structured report, and logs results for service desk monitoring.

.PARAMETER ReportPath
CSV output path.

.PARAMETER LogPath
Log file path.

.EXAMPLE
.\locked-accounts-report.ps1
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [string]$ReportPath='C:\Logs\LockedAccountsReport.csv',

    [string]$LogPath='C:\Logs\LockedAccountsReport.log'
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

    $accounts = Search-ADAccount -LockedOut -UsersOnly

    $results = @()
    $recent = 0
    $old = 0

    foreach ($acc in $accounts) {
        try {
            $user = Get-ADUser $acc -Properties Department,LastBadPasswordAttempt

            # Classification (last 1 hour = recent)
            $status = if ($user.LastBadPasswordAttempt -and 
                          ((Get-Date) - $user.LastBadPasswordAttempt).TotalMinutes -lt 60) {
                $recent++
                "RecentLockout"
            } else {
                $old++
                "OlderLockout"
            }

            $results += [pscustomobject]@{
                SamAccountName        = $user.SamAccountName
                Name                  = $user.Name
                Department            = $user.Department
                LastBadPasswordAttempt= $user.LastBadPasswordAttempt
                Status                = $status
            }

        } catch {
            Write-Log "Failed processing account: $($_.Exception.Message)" "ERROR"
        }
    }

    # Ensure directory
    $dir = Split-Path $ReportPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item $dir -ItemType Directory -Force | Out-Null
    }

    # Sort by most recent first
    $results |
        Sort-Object LastBadPasswordAttempt -Descending |
        Export-Csv -NoTypeInformation -Path $ReportPath

    if ($results.Count -eq 0) {
        Write-Log "No locked accounts found" "INFO"
    } else {
        Write-Log "Found $($results.Count) locked accounts" "WARN"
    }

    # Summary output
    [pscustomobject]@{
        TotalLocked   = $results.Count
        Recent        = $recent
        Older         = $old
        Report        = $ReportPath
        Timestamp     = Get-Date
    }

} catch {
    Write-Log "Locked account report failed: $($_.Exception.Message)" "ERROR"
    throw
}