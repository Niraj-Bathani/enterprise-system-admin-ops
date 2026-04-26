<#
.SYNOPSIS
Validates DNS service and name resolution.

.DESCRIPTION
Checks DNS service status, validates connectivity to DNS server, resolves provided names, and generates a structured report.

.PARAMETER DnsServer
DNS server IP or hostname.

.PARAMETER NamesToResolve
List of DNS names to test.

.PARAMETER ReportPath
Output report file path.

.PARAMETER LogPath
Log file path.

.EXAMPLE
./dns-health-check.ps1 -DnsServer 192.168.100.10 -NamesToResolve lab.local,dc01.lab.local
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory)]
    [string]$DnsServer,

    [Parameter(Mandatory)]
    [string[]]$NamesToResolve,

    [Parameter()]
    [string]$ReportPath='C:\Logs\DnsHealthCheck.txt',

    [Parameter()]
    [string]$LogPath='C:\Logs\DnsHealthCheck.log'
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
    if (-not (Test-Connection -ComputerName $DnsServer -Count 1 -Quiet)) {
        Write-Log "Cannot reach DNS server $DnsServer" "ERROR"
        throw "DNS server unreachable"
    }

    # Prepare output
    $output = @()
    $output += "=== DNS Health Check ==="
    $output += "Server: $DnsServer"
    $output += "Time: $(Get-Date)"
    $output += ""

    # Service Check
    $output += "=== DNS Service Status ==="
    try {
        $svc = Get-Service -ComputerName $DnsServer -Name DNS -ErrorAction Stop
        $output += "DNS Service: $($svc.Status)"

        if ($svc.Status -ne "Running") {
            Write-Log "DNS service is not running" "WARN"
        }
    } catch {
        Write-Log "Failed to check DNS service" "ERROR"
    }

    $output += ""

    # Resolution Tests
    $output += "=== Name Resolution Tests ==="

    $success = 0
    $fail = 0

    foreach ($name in $NamesToResolve) {
        try {
            $answer = Resolve-DnsName -Name $name -Server $DnsServer -ErrorAction Stop
            $ip = ($answer.IPAddress -join ',')

            $output += "$name`tOK`t$ip"
            Write-Log "Resolved '$name' successfully"

            $success++
        } catch {
            $msg = $_.Exception.Message
            $output += "$name`tFAILED`t$msg"
            Write-Log "Failed resolving '$name': $msg" "ERROR"

            $fail++
        }
    }

    $output += ""
    $output += "=== Summary ==="
    $output += "Successful: $success"
    $output += "Failed: $fail"

    # Save report
    $dir = Split-Path $ReportPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item $dir -ItemType Directory -Force | Out-Null
    }

    $output | Set-Content -Path $ReportPath

    Write-Log "DNS health check report written to '$ReportPath'."

    $output

} catch {
    Write-Log "DNS health check failed: $($_.Exception.Message)" 'ERROR'
    throw
}