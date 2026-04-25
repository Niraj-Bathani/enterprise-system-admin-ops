<#
.SYNOPSIS
Reports installed software from remote Windows computers.

.DESCRIPTION
Reads uninstall registry keys through remote registry/CIM compatible paths without using Win32_Product, which can trigger repair actions.

.PARAMETER ComputerName
Computers to query.
.PARAMETER ReportPath
CSV report path.
.PARAMETER LogPath
Log file path.

.EXAMPLE
./installed-software-report.ps1 -ComputerName CLIENT01,FS01
#>
[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string[]]$ComputerName,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$ReportPath = 'C:\Logs\InstalledSoftwareReport.csv',
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$LogPath = 'C:\Logs\InstalledSoftwareReport.log'
)
function Write-Log { param([string]$Message,[ValidateSet('INFO','WARN','ERROR')]$Level='INFO'); $d=Split-Path $LogPath -Parent; if(-not(Test-Path $d)){New-Item $d -ItemType Directory -Force|Out-Null}; Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message" }
try {
    $paths = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    $results = foreach($computer in $ComputerName){
        try {
            Invoke-Command -ComputerName $computer -ScriptBlock {
                param($paths)
                foreach($p in $paths){ Get-ItemProperty -Path $p -ErrorAction SilentlyContinue | Where-Object DisplayName | Select-Object DisplayName,DisplayVersion,Publisher,InstallDate }
            } -ArgumentList (,$paths) -ErrorAction Stop | ForEach-Object {
                [pscustomobject]@{ ComputerName=$computer; Name=$_.DisplayName; Version=$_.DisplayVersion; Publisher=$_.Publisher; InstallDate=$_.InstallDate }
            }
            Write-Log "Collected software inventory from '$computer'."
        } catch { Write-Log "Failed software inventory for '$computer': $($_.Exception.Message)" 'ERROR' }
    }
    $dir=Split-Path $ReportPath -Parent; if(-not(Test-Path $dir)){New-Item $dir -ItemType Directory -Force|Out-Null}
    $results | Export-Csv -NoTypeInformation -Path $ReportPath
    $results
}
catch { Write-Log "Installed software report failed: $($_.Exception.Message)" 'ERROR'; throw }
