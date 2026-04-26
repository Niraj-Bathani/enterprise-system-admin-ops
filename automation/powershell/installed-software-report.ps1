<#
.SYNOPSIS
Reports installed software from remote Windows computers.

.DESCRIPTION
Queries uninstall registry keys remotely (avoiding Win32_Product), validates connectivity and WinRM, logs results, and generates a structured CSV report.

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
    [string[]]$ComputerName,

    [string]$ReportPath = 'C:\Logs\InstalledSoftwareReport.csv',

    [string]$LogPath = 'C:\Logs\InstalledSoftwareReport.log'
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
    $success = 0
    $failed = 0

    $paths = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )

    foreach ($computer in $ComputerName) {
        $total++

        # Connectivity check
        if (-not (Test-Connection -ComputerName $computer -Count 1 -Quiet)) {
            Write-Log "Cannot reach $computer" "ERROR"
            $results += [pscustomobject]@{
                ComputerName = $computer
                Name         = "N/A"
                Version      = ""
                Publisher    = ""
                InstallDate  = ""
                Status       = "UNREACHABLE"
            }
            $failed++
            continue
        }

        try {
            # WinRM test
            if (-not (Test-WSMan -ComputerName $computer -ErrorAction SilentlyContinue)) {
                throw "WinRM not available"
            }

            $data = Invoke-Command -ComputerName $computer -ScriptBlock {
                param($paths)
                foreach ($p in $paths) {
                    Get-ItemProperty -Path $p -ErrorAction SilentlyContinue |
                        Where-Object { $_.DisplayName -and $_.DisplayName -ne "" } |
                        Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
                }
            } -ArgumentList (,$paths) -ErrorAction Stop

            foreach ($item in $data) {
                $results += [pscustomobject]@{
                    ComputerName = $computer
                    Name         = $item.DisplayName
                    Version      = $item.DisplayVersion
                    Publisher    = $item.Publisher
                    InstallDate  = $item.InstallDate
                    Status       = "OK"
                }
            }

            Write-Log "Collected software inventory from '$computer'"
            $success++

        } catch {
            Write-Log "Failed software inventory for '$computer': $($_.Exception.Message)" "ERROR"

            $results += [pscustomobject]@{
                ComputerName = $computer
                Name         = "ERROR"
                Version      = ""
                Publisher    = ""
                InstallDate  = ""
                Status       = "FAILED"
            }

            $failed++
        }
    }

    # Save report
    $dir = Split-Path $ReportPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item $dir -ItemType Directory -Force | Out-Null
    }

    $results |
        Sort-Object ComputerName, Name |
        Export-Csv -NoTypeInformation -Path $ReportPath

    Write-Log "Software report written to '$ReportPath'"

    # Summary
    [pscustomobject]@{
        Total   = $total
        Success = $success
        Failed  = $failed
        Report  = $ReportPath
    }

} catch {
    Write-Log "Installed software report failed: $($_.Exception.Message)" "ERROR"
    throw
}