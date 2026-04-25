<#
.SYNOPSIS
Collects disk free-space information from one or more servers.

.DESCRIPTION
Queries CIM Win32_LogicalDisk for fixed drives, exports CSV, logs failures, and flags volumes below a configurable free-space threshold.

.PARAMETER ComputerName
Server names to query.
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
    [ValidateNotNullOrEmpty()]
    [string[]]$ComputerName,
    [Parameter()]
    [ValidateRange(1,90)]
    [int]$ThresholdPercent = 15,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ReportPath = 'C:\Logs\DiskSpaceReport.csv',
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$LogPath = 'C:\Logs\DiskSpaceReport.log'
)
function Write-Log { param([string]$Message,[ValidateSet('INFO','WARN','ERROR')]$Level='INFO'); $d=Split-Path $LogPath -Parent; if(-not(Test-Path $d)){New-Item $d -ItemType Directory -Force|Out-Null}; Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message" }
try {
    $results = foreach($computer in $ComputerName){
        try {
            Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $computer -ErrorAction Stop | ForEach-Object {
                $freePct = if ($_.Size -gt 0) { [math]::Round(($_.FreeSpace / $_.Size) * 100, 2) } else { 0 }
                [pscustomobject]@{ ComputerName=$computer; Drive=$_.DeviceID; SizeGB=[math]::Round($_.Size/1GB,2); FreeGB=[math]::Round($_.FreeSpace/1GB,2); FreePercent=$freePct; Status= if($freePct -lt $ThresholdPercent){'Warning'}else{'OK'} }
            }
            Write-Log "Collected disk data from '$computer'."
        }
        catch { Write-Log "Failed querying '$computer': $($_.Exception.Message)" 'ERROR' }
    }
    $dir=Split-Path $ReportPath -Parent; if(-not(Test-Path $dir)){New-Item $dir -ItemType Directory -Force|Out-Null}
    $results | Export-Csv -NoTypeInformation -Path $ReportPath
    Write-Log "Disk report written to '$ReportPath'."
    $results
}
catch { Write-Log "Disk report failed: $($_.Exception.Message)" 'ERROR'; throw }
