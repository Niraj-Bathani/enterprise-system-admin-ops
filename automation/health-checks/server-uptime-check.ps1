<#
.SYNOPSIS
Reports server uptime and detects recent restarts.

.DESCRIPTION
Collects LastBootUpTime from one or more servers, calculates uptime, checks connectivity, logs failures, and generates a structured report.

.PARAMETER ComputerName
Servers to query.

.PARAMETER MinimumHours
Minimum expected uptime before warning.

.PARAMETER ReportPath
Output report path.

.PARAMETER LogPath
Log file path.

.EXAMPLE
./server-uptime-check.ps1 -ComputerName DC01,FS01 -MinimumHours 24
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory)]
    [string[]]$ComputerName,

    [Parameter()]
    [ValidateRange(1,8760)]
    [int]$MinimumHours=24,

    [Parameter()]
    [string]$ReportPath='C:\Logs\ServerUptimeCheck.txt',

    [Parameter()]
    [string]$LogPath='C:\Logs\ServerUptimeCheck.log'
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
    $output = @()
    $output += "=== Server Uptime Check ==="
    $output += "Time: $(Get-Date)"
    $output += ""

    $total = 0
    $healthy = 0
    $warning = 0
    $failed = 0

    foreach ($computer in $ComputerName) {
        $total++

        # Connectivity check
        if (-not (Test-Connection -ComputerName $computer -Count 1 -Quiet)) {
            Write-Log "Cannot reach $computer" "ERROR"
            $output += "$computer`tUNREACHABLE"
            $failed++
            continue
        }

        try {
            $os = Get-CimInstance Win32_OperatingSystem -ComputerName $computer -ErrorAction Stop
            $uptime = (Get-Date) - $os.LastBootUpTime
            $hours = [math]::Round($uptime.TotalHours,2)

            if ($hours -lt $MinimumHours) {
                $status = "WARNING"
                Write-Log "$computer uptime low: $hours hours" "WARN"
                $warning++
            } else {
                $status = "OK"
                $healthy++
            }

            $output += "$computer`t$status`t$hours hours`tLast Boot: $($os.LastBootUpTime)"

        } catch {
            Write-Log "Failed uptime check for '$computer': $($_.Exception.Message)" "ERROR"
            $output += "$computer`tFAILED"
            $failed++
        }
    }

    $output += ""
    $output += "=== Summary ==="
    $output += "Total Servers: $total"
    $output += "Healthy: $healthy"
    $output += "Warnings: $warning"
    $output += "Failed: $failed"

    # Save report
    $dir = Split-Path $ReportPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item $dir -ItemType Directory -Force | Out-Null
    }

    $output | Set-Content -Path $ReportPath

    Write-Log "Server uptime report written to '$ReportPath'."

    $output

} catch {
    Write-Log "Server uptime check failed: $($_.Exception.Message)" 'ERROR'
    throw
}