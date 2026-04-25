<#
.SYNOPSIS
Reports server uptime from CIM operating system data.

.DESCRIPTION
Collects LastBootUpTime from one or more servers, calculates uptime, logs failures, and returns objects suitable for scheduled reports.

.PARAMETER ComputerName
Servers to query.
.PARAMETER MinimumHours
Minimum expected uptime before warning.
.PARAMETER LogPath
Log file path.

.EXAMPLE
./server-uptime-check.ps1 -ComputerName DC01,FS01 -MinimumHours 24
#>
[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string[]]$ComputerName,
    [Parameter()][ValidateRange(1,8760)][int]$MinimumHours=24,
    [Parameter()][ValidateNotNullOrEmpty()][string]$LogPath='C:\Logs\ServerUptimeCheck.log'
)
function Write-Log { param([string]$Message,[ValidateSet('INFO','WARN','ERROR')]$Level='INFO'); $d=Split-Path $LogPath -Parent; if(-not(Test-Path $d)){New-Item $d -ItemType Directory -Force|Out-Null}; Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message" }
try{
    foreach($computer in $ComputerName){
        try{
            $os=Get-CimInstance Win32_OperatingSystem -ComputerName $computer -ErrorAction Stop
            $uptime=(Get-Date)-$os.LastBootUpTime
            $status=if($uptime.TotalHours -lt $MinimumHours){'RecentlyRestarted'}else{'OK'}
            Write-Log "Checked uptime for '$computer': $([math]::Round($uptime.TotalHours,2)) hours."
            [pscustomobject]@{ComputerName=$computer;LastBootUpTime=$os.LastBootUpTime;UptimeHours=[math]::Round($uptime.TotalHours,2);Status=$status}
        } catch { Write-Log "Failed uptime check for '$computer': $($_.Exception.Message)" 'ERROR' }
    }
} catch { Write-Log "Server uptime check failed: $($_.Exception.Message)" 'ERROR'; throw }
