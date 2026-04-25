<#
.SYNOPSIS
Resets an Active Directory user password and optionally unlocks the account.

.DESCRIPTION
Provides a controlled service-desk password reset workflow with logging, validation, optional unlock, and forced change at next logon. Run as an authorized domain administrator.

.PARAMETER SamAccountName
Target user logon name.
.PARAMETER NewPassword
Temporary password as a secure string.
.PARAMETER Unlock
Unlocks the account after reset.
.PARAMETER LogPath
Log file path.

.EXAMPLE
$p = Read-Host 'Temporary password' -AsSecureString
./reset-password.ps1 -SamAccountName jsmith -NewPassword $p -Unlock
#>
[CmdletBinding(SupportsShouldProcess=$true)]

param(
    [Parameter(Mandatory)]
    [ValidatePattern('^[a-zA-Z0-9._-]{2,64}$')]
    [string]$SamAccountName,

    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [securestring]$NewPassword,

    [Parameter()]
    [switch]$Unlock,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$LogPath = 'C:\Logs\ResetPassword.log'
)
function Write-Log { param([string]$Message,[ValidateSet('INFO','WARN','ERROR')]$Level='INFO'); $d=Split-Path $LogPath -Parent; if(-not(Test-Path $d)){New-Item $d -ItemType Directory -Force|Out-Null}; Add-Content $LogPath "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message" }
try {
    Import-Module ActiveDirectory -ErrorAction Stop
    $user = Get-ADUser -Identity $SamAccountName -Properties LockedOut -ErrorAction Stop
    if ($PSCmdlet.ShouldProcess($SamAccountName, 'Reset AD password')) {
        Set-ADAccountPassword -Identity $user -NewPassword $NewPassword -Reset -ErrorAction Stop
        Set-ADUser -Identity $user -ChangePasswordAtLogon $true -ErrorAction Stop
        if ($Unlock -and $user.LockedOut) { Unlock-ADAccount -Identity $user -ErrorAction Stop; Write-Log "Unlocked '$SamAccountName'." }
        Write-Log "Reset password for '$SamAccountName' and required change at next logon."
    }
}
catch {
    Write-Log "Password reset failed for '$SamAccountName': $($_.Exception.Message)" 'ERROR'
    throw
}
