<#
.SYNOPSIS
Validates DNS service and common records.

.DESCRIPTION
Checks DNS service status, resolves requested names against a specified server, and logs failures for operational review.

.PARAMETER DnsServer
DNS server IP or name.
.PARAMETER NamesToResolve
DNS names to test.
.PARAMETER LogPath
Log file path.

.EXAMPLE
./dns-health-check.ps1 -DnsServer 192.168.100.10 -NamesToResolve lab.local,dc01.lab.local
#>
[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$DnsServer,
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string[]]$NamesToResolve,
    [Parameter()][ValidateNotNullOrEmpty()][string]$LogPath='C:\Logs\DnsHealthCheck.log'
)
function Write-Log { param([string]$Message,[ValidateSet('INFO','WARN','ERROR')]$Level='INFO'); $d=Split-Path $LogPath -Parent; if(-not(Test-Path $d)){New-Item $d -ItemType Directory -Force|Out-Null}; Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message" }
try{
    $results=foreach($name in $NamesToResolve){
        try{
            $answer=Resolve-DnsName -Name $name -Server $DnsServer -ErrorAction Stop
            Write-Log "Resolved '$name' using '$DnsServer'."
            [pscustomobject]@{Name=$name;Status='OK';Answer=($answer.IPAddress -join ',')}
        } catch { Write-Log "Failed resolving '$name': $($_.Exception.Message)" 'ERROR'; [pscustomobject]@{Name=$name;Status='Failed';Answer=$_.Exception.Message} }
    }
    $results
} catch { Write-Log "DNS health check failed: $($_.Exception.Message)" 'ERROR'; throw }
