<#
.SYNOPSIS
Runs basic domain controller health checks.

.DESCRIPTION
Checks critical services, SYSVOL/NETLOGON shares, replication summary, and dcdiag availability. Logs all findings and exports a text report.

.PARAMETER DomainController
Domain controller to check.
.PARAMETER ReportPath
Text report path.
.PARAMETER LogPath
Log file path.

.EXAMPLE
./dc-health-check.ps1 -DomainController DC01
#>
[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [Parameter(Mandatory)][ValidatePattern('^[a-zA-Z0-9.-]+$')][string]$DomainController,
    [Parameter()][ValidateNotNullOrEmpty()][string]$ReportPath='C:\Logs\DcHealthCheck.txt',
    [Parameter()][ValidateNotNullOrEmpty()][string]$LogPath='C:\Logs\DcHealthCheck.log'
)
function Write-Log { param([string]$Message,[ValidateSet('INFO','WARN','ERROR')]$Level='INFO'); $d=Split-Path $LogPath -Parent; if(-not(Test-Path $d)){New-Item $d -ItemType Directory -Force|Out-Null}; Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message" }
try{
    $dir=Split-Path $ReportPath -Parent; if(-not(Test-Path $dir)){New-Item $dir -ItemType Directory -Force|Out-Null}
    $services='NTDS','DNS','DFSR','Netlogon','Kdc'
    $output=@()
    foreach($svc in $services){ $s=Get-Service -ComputerName $DomainController -Name $svc -ErrorAction Stop; $output += "$svc`t$($s.Status)" }
    $shares = Get-SmbShare -CimSession $DomainController -Name SYSVOL,NETLOGON -ErrorAction Stop | Select-Object Name,Path
    $output += ($shares | Format-Table -AutoSize | Out-String)
    $output += (& repadmin /replsummary 2>&1 | Out-String)
    $output += (& dcdiag /s:$DomainController /q 2>&1 | Out-String)
    $output | Set-Content -Path $ReportPath
    Write-Log "Domain controller health report written to '$ReportPath'."
    $output
} catch { Write-Log "DC health check failed: $($_.Exception.Message)" 'ERROR'; throw }
