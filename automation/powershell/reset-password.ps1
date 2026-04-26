<#
.SYNOPSIS
Resets an Active Directory user password and optionally unlocks the account.

.DESCRIPTION
Provides a controlled service-desk password reset workflow with logging, validation, optional unlock, and forced password change at next logon.

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
.\reset-password.ps1 -SamAccountName jsmith -NewPassword $p -Unlock
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^[a-zA-Z0-9._-]{2,64}$')]
    [string]$SamAccountName,

    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [securestring]$NewPassword,

    [switch]$Unlock,

    [string]$LogPath = 'C:\Logs\ResetPassword.log'
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
    Import-Module ActiveDirectory -ErrorAction Stop

    # Domain connectivity check
    if (-not (Get-ADDomain -ErrorAction SilentlyContinue)) {
        throw "Unable to connect to Active Directory"
    }

    # Get user
    try {
        $user = Get-ADUser -Identity $SamAccountName -Properties LockedOut -ErrorAction Stop
    } catch {
        Write-Log "User '$SamAccountName' not found" "ERROR"
        throw
    }

    $result = "FAILED"
    $unlockStatus = "NotRequested"

    if ($PSCmdlet.ShouldProcess($SamAccountName, "Reset AD password")) {

        # Reset password
        Set-ADAccountPassword -Identity $user -NewPassword $NewPassword -Reset -ErrorAction Stop
        Set-ADUser -Identity $user -ChangePasswordAtLogon $true -ErrorAction Stop

        Write-Log "Password reset for '$SamAccountName'" "WARN"

        # Unlock logic
        if ($Unlock) {
            if ($user.LockedOut) {
                Unlock-ADAccount -Identity $user -ErrorAction Stop
                Write-Log "Unlocked account '$SamAccountName'" "INFO"
                $unlockStatus = "Unlocked"
            } else {
                Write-Log "User '$SamAccountName' was not locked" "INFO"
                $unlockStatus = "NotLocked"
            }
        }

        $result = "SUCCESS"
    }

    # Output object
    [pscustomobject]@{
        User          = $SamAccountName
        Result        = $result
        UnlockStatus  = $unlockStatus
        Timestamp     = Get-Date
    }

} catch {
    Write-Log "Password reset failed for '$SamAccountName': $($_.Exception.Message)" "ERROR"
    throw
}