<#
.SYNOPSIS
Creates Active Directory users from a CSV file.

.DESCRIPTION
Reads a CSV containing FirstName, LastName, Department, and Password columns, creates users in department OUs under the supplied base OU, and logs every action. The script assumes it is run by an authorized domain administrator and never stores credentials.

.PARAMETER CsvPath
Path to a CSV with headers FirstName, LastName, Department, Password.
.PARAMETER DomainName
DNS domain name such as lab.local.
.PARAMETER UserBaseOu
Base OU that contains department OUs, such as OU=Users,DC=lab,DC=local.
.PARAMETER LogPath
Log file path. Defaults to C:\Logs\BulkUserCreate.log.

.EXAMPLE
./bulk-user-create.ps1 -CsvPath .\new-users.csv -DomainName lab.local -UserBaseOu 'OU=Users,DC=lab,DC=local'
#>
[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$CsvPath,

    [Parameter(Mandatory)]
    [ValidatePattern('^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')]
    [string]$DomainName,

    [Parameter(Mandatory)]
    [ValidatePattern('^OU=.*DC=.*')]
    [string]$UserBaseOu,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$LogPath = 'C:\Logs\BulkUserCreate.log'
)

function Write-Log {
    param([string]$Message, [ValidateSet('INFO','WARN','ERROR')] [string]$Level = 'INFO')
    $dir = Split-Path -Path $LogPath -Parent
    if (-not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory -Force | Out-Null }
    Add-Content -Path $LogPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message"
}

try {
    Import-Module ActiveDirectory -ErrorAction Stop
    $required = 'FirstName','LastName','Department','Password'
    $users = Import-Csv -Path $CsvPath -ErrorAction Stop
    if (-not $users) { throw "CSV file '$CsvPath' contains no rows." }
    foreach ($column in $required) {
        if ($users[0].PSObject.Properties.Name -notcontains $column) { throw "CSV is missing required column '$column'." }
    }
    foreach ($row in $users) {
        try {
            $first = $row.FirstName.Trim()
            $last = $row.LastName.Trim()
            $dept = $row.Department.Trim()
            if ([string]::IsNullOrWhiteSpace($first) -or [string]::IsNullOrWhiteSpace($last) -or [string]::IsNullOrWhiteSpace($dept)) {
                throw "FirstName, LastName, and Department must be populated."
            }
            $sam = ("{0}{1}" -f $first.Substring(0,1), $last).ToLower()
            $upn = "$sam@$DomainName"
            $targetOu = "OU=$dept,$UserBaseOu"
            $existing = Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction Stop
            if ($existing) { throw "User '$sam' already exists." }
            Get-ADOrganizationalUnit -Identity $targetOu -ErrorAction Stop | Out-Null
            $securePassword = ConvertTo-SecureString $row.Password -AsPlainText -Force
            if ($PSCmdlet.ShouldProcess($sam, "Create AD user in $targetOu")) {
                New-ADUser -Name "$first $last" -GivenName $first -Surname $last -SamAccountName $sam -UserPrincipalName $upn -Department $dept -Path $targetOu -AccountPassword $securePassword -Enabled $true -ChangePasswordAtLogon $true -ErrorAction Stop
                Write-Log "Created user '$sam' in '$targetOu'."
            }
        }
        catch {
            Write-Log "Failed to process '$($row.FirstName) $($row.LastName)': $($_.Exception.Message)" 'ERROR'
        }
    }
}
catch {
    Write-Log "Script failed: $($_.Exception.Message)" 'ERROR'
    throw
}
