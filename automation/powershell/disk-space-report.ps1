<#
.SYNOPSIS
Collects disk free-space information from servers.

.DESCRIPTION
Queries Win32_LogicalDisk for fixed drives, calculates free space, flags warning/critical levels, logs results, and generates a structured report.

.PARAMETER ComputerName
Servers to query.

.PARAMETER ThresholdPercent
Warning threshold.

.PARAMETER ReportPath
CSV report path.

.PARAMETER LogPath
Log file path.

.EXAMPLE
./disk-space-report.ps1 -ComputerName DC01,FS01 -ThresholdPercent 15
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory)]
    [string[]]$ComputerName,

    [ValidateRange(1,90)]
    [int]$ThresholdPercent = 15,

    [string]$ReportPath = 'C:\Logs\DiskSpaceReport.csv',

    [string]$LogPath = 'C:\Logs\DiskSpaceReport.log'
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
    $results = @()
    $total = 0
    $warnings = 0
    $critical = 0
    $failed = 0

    foreach ($computer in $ComputerName) {
        $total++

        # Connectivity check
        if (-not (Test-Connection -ComputerName $computer -Count 1 -Quiet)) {
            Write-Log "Cannot reach $computer" "ERROR"
            $results += [pscustomobject]@{
                ComputerName = $computer
                Drive        = "N/A"
                SizeGB       = 0
                FreeGB       = 0
                FreePercent  = 0
                Status       = "UNREACHABLE"
            }
            $failed++
            continue
        }

        try {
            $disks = Get-CimInstance -ClassName Win32_LogicalDisk `
                -Filter "DriveType=3" `
                -ComputerName $computer -ErrorAction Stop

            foreach ($disk in $disks) {
                $freePct = if ($disk.Size -gt 0) {
                    [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)
                } else { 0 }

                if ($freePct -lt ($ThresholdPercent / 2)) {
                    $status = "CRITICAL"
                    $critical++
                    Write-Log "$computer $($disk.DeviceID) critical: $freePct%" "ERROR"
                }
                elseif ($freePct -lt $ThresholdPercent) {
                    $status = "WARNING"
                    $warnings++
                    Write-Log "$computer $($disk.DeviceID) low space: $freePct%" "WARN"
                }
                else {
                    $status = "OK"
                }

                $results += [pscustomobject]@{
                    ComputerName = $computer
                    Drive        = $disk.DeviceID
                    SizeGB       = [math]::Round($disk.Size/1GB,2)
                    FreeGB       = [math]::Round($disk.FreeSpace/1GB,2)
                    FreePercent  = $freePct
                    Status       = $status
                }
            }

            Write-Log "Collected disk data from '$computer'"

        } catch {
            Write-Log "Failed querying '$computer': $($_.Exception.Message)" "ERROR"
            $failed++
        }
    }

    # Save report
    $dir = Split-Path $ReportPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item $dir -ItemType Directory -Force | Out-Null
    }

    $results | Export-Csv -NoTypeInformation -Path $ReportPath

    Write-Log "Disk report written to '$ReportPath'"

    # Summary output
    [pscustomobject]@{
        TotalServers = $total
        Warnings     = $warnings
        Critical     = $critical
        Failed       = $failed
        Report       = $ReportPath
    }

} catch {
    Write-Log "Disk report failed: $($_.Exception.Message)" "ERROR"
    throw
}