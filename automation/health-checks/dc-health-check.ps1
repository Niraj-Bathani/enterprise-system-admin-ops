<#
.SYNOPSIS
Runs basic domain controller health checks.

.DESCRIPTION
Checks critical services, SYSVOL/NETLOGON shares, replication summary, and dcdiag availability. Logs all findings and exports a structured text report.

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
    [Parameter(Mandatory)]
    [ValidatePattern('^[a-zA-Z0-9.-]+$')]
    [string]$DomainController,

    [Parameter()]
    [string]$ReportPath='C:\Logs\DcHealthCheck.txt',

    [Parameter()]
    [string]$LogPath='C:\Logs\DcHealthCheck.log'
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
    # Connectivity Check
    if (-not (Test-Connection -ComputerName $DomainController -Count 1 -Quiet)) {
        Write-Log "Cannot reach $DomainController" "ERROR"
        throw "Domain Controller unreachable"
    }

    $dir = Split-Path $ReportPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item $dir -ItemType Directory -Force | Out-Null
    }

    $output = @()
    $output += "=== Domain Controller Health Check ==="
    $output += "Server: $DomainController"
    $output += "Time: $(Get-Date)"
    $output += ""

    # Service Check
    $output += "=== Service Status ==="
    $services = 'NTDS','DNS','DFSR','Netlogon','Kdc'

    foreach ($svc in $services) {
        try {
            $s = Get-Service -ComputerName $DomainController -Name $svc -ErrorAction Stop
            $status = "$svc`t$($s.Status)"
            $output += $status

            if ($s.Status -ne "Running") {
                Write-Log "Service $svc is not running" "WARN"
            }
        } catch {
            Write-Log "Failed to check service $svc" "ERROR"
        }
    }

    $output += ""

    # Share Check
    $output += "=== SYSVOL / NETLOGON Shares ==="
    try {
        $shares = Get-SmbShare -CimSession $DomainController -Name SYSVOL,NETLOGON -ErrorAction Stop |
                  Select-Object Name, Path
        $output += ($shares | Format-Table -AutoSize | Out-String)
    } catch {
        Write-Log "Failed to check SMB shares" "WARN"
    }

    $output += ""

    # Replication Check
    $output += "=== Replication Summary ==="
    if (Get-Command repadmin -ErrorAction SilentlyContinue) {
        $output += (& repadmin /replsummary 2>&1 | Out-String)
    } else {
        Write-Log "repadmin not found" "WARN"
    }

    $output += ""

    # DCDiag Check
    $output += "=== DCDiag Results ==="
    if (Get-Command dcdiag -ErrorAction SilentlyContinue) {
        $output += (& dcdiag /s:$DomainController /q 2>&1 | Out-String)
    } else {
        Write-Log "dcdiag not found" "WARN"
    }

    # Save Report
    $output | Set-Content -Path $ReportPath

    Write-Log "Domain controller health report written to '$ReportPath'."
    $output

} catch {
    Write-Log "DC health check failed: $($_.Exception.Message)" 'ERROR'
    throw
}