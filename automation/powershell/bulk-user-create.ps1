<#
.SYNOPSIS
Creates Active Directory users from a CSV file.

.DESCRIPTION
Reads a CSV containing FirstName, LastName, Department, and Password columns. Creates users in department OUs under the supplied base OU, ensures unique usernames, logs all actions, and produces a summary report.

.PARAMETER CsvPath
Path to CSV file.

.PARAMETER DomainName
DNS domain name (e.g., lab.local).

.PARAMETER UserBaseOu
Base OU (e.g., OU=Users,DC=lab,DC=local).

.PARAMETER LogPath
Log file path.

.EXAMPLE
./bulk-user-create.ps1 -CsvPath .\new-users.csv -DomainName lab.local -UserBaseOu 'OU=Users,DC=lab,DC=local'
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$CsvPath,

    [Parameter(Mandatory)]
    [string]$DomainName,

    [Parameter(Mandatory)]
    [string]$UserBaseOu,

    [Parameter()]
    [string]$LogPath = 'C:\Logs\BulkUserCreate.log'
)

function Write-Log {
    param([string]$Message, [ValidateSet('INFO','WARN','ERROR')] [string]$Level = 'INFO')
    $dir = Split-Path $LogPath -Parent
    if (-not (Test-Path $dir)) { New-Item $dir -ItemType Directory -Force | Out-Null }
    Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message"
}

function Get-UniqueSamAccountName {
    param($baseSam)
    $sam = $baseSam
    $i = 1
    while (Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue) {
        $sam = "$baseSam$i"
        $i++
    }
    return $sam
}

try {
    Import-Module ActiveDirectory -ErrorAction Stop

    # Domain check
    if (-not (Get-ADDomain -ErrorAction SilentlyContinue)) {
        throw "Unable to connect to Active Directory domain."
    }

    $required = 'FirstName','LastName','Department','Password'
    $users = Import-Csv -Path $CsvPath

    if (-not $users) { throw "CSV is empty." }

    foreach ($col in $required) {
        if ($users[0].PSObject.Properties.Name -notcontains $col) {
            throw "Missing column: $col"
        }
    }

    $created = 0
    $failed = 0

    # Cache OUs
    $ouCache = @{}

    foreach ($row in $users) {
        try {
            $first = $row.FirstName.Trim()
            $last = $row.LastName.Trim()
            $dept = $row.Department.Trim()

            if ([string]::IsNullOrWhiteSpace($first) -or [string]::IsNullOrWhiteSpace($last)) {
                throw "Invalid name data"
            }

            $baseSam = ("{0}{1}" -f $first.Substring(0,1), $last).ToLower()
            $sam = Get-UniqueSamAccountName -baseSam $baseSam
            $upn = "$sam@$DomainName"

            $targetOu = "OU=$dept,$UserBaseOu"

            if (-not $ouCache.ContainsKey($targetOu)) {
                Get-ADOrganizationalUnit -Identity $targetOu -ErrorAction Stop | Out-Null
                $ouCache[$targetOu] = $true
            }

            $securePassword = ConvertTo-SecureString $row.Password -AsPlainText -Force

            if ($PSCmdlet.ShouldProcess($sam, "Create AD user")) {
                New-ADUser `
                    -Name "$first $last" `
                    -GivenName $first `
                    -Surname $last `
                    -SamAccountName $sam `
                    -UserPrincipalName $upn `
                    -Department $dept `
                    -Path $targetOu `
                    -AccountPassword $securePassword `
                    -Enabled $true `
                    -ChangePasswordAtLogon $true

                Write-Log "Created user '$sam'"
                $created++
            }

        } catch {
            Write-Log "Failed: $($row.FirstName) $($row.LastName) - $($_.Exception.Message)" "ERROR"
            $failed++
        }
    }

    Write-Log "Completed. Created: $created, Failed: $failed"

    [pscustomobject]@{
        Created = $created
        Failed  = $failed
        Total   = $users.Count
    }

} catch {
    Write-Log "Script failed: $($_.Exception.Message)" "ERROR"
    throw
}