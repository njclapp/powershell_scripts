#Requires -runasadministrator

<#
.SYNOPSIS
This script finds stale user accounts, prints out details of the stale account, and confirms with the user before each disabling the account.

.EXAMPLE
.\maintain-ADUsers.ps1 -age <days>
#>


param(
[int]$age=180
)
Import-Module ActiveDirectory

Write-Host "Finding accounts that have not been logged into in $age days..."
Write-Host

# $(Search-ADAccount -AccountInactive -UsersOnly -TimeSpan "$age" | where{$_.enabled}) # Apparently this method doesn't work...?

foreach($account in $(Get-ADUser -Filter * -Properties LastLogonDate | where{$_.LastLogonDate -lt $(get-date).AddDays(-$age)} | where{$_.Enabled}))
{
    Get-ADUser $account -Properties LastLogonDate | select SamAccountName,DistinguishedName,LastLogonDate | Format-List
    Disable-ADAccount -Identity $account.SamAccountName -Confirm
}