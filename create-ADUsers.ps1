#Requires -runasadministrator

<#
.SYNOPSIS
This script takes a csv file of usernames, and creates users in the correct groups on an AD server or on the local system

.EXAMPLE
You must run this script as administrator. Failure to do so will prevent this script from running.

To run with a domain controller:
.\create-ADUsers.ps1 -file <file.csv>

To run locally:
.\create-ADUsers.ps1 -file <file.csv> -local
#>

param(
[parameter(Mandatory=$true)]$file, [switch]$local, [string]$OUPath="OU=users,DC=domain,DC=lan"
)
Import-Module ActiveDirectory

$pw = Read-Host "Enter password" -AsSecureString

if($local)
{
    foreach($user in $(Import-CSV $file))
    {
        Write-Host "Creating local user" $user.username : "Adding to default Users group"
        New-LocalUser $user.username -Password $pw
        Add-LocalGroupMember -Group "Users" -Member $user.username
    }
}
else
{
    foreach ($user in $(Import-CSV $file))
    {
        Write-Host "Creating domain user" $user.username": Adding to group" $user.group
        New-ADUser $user.username -GivenName $user.fname -Surname $user.lname -Enabled $true -AccountPassword $pw -ChangePasswordAtLogon $true -Path $OUPath
        Add-ADGroupMember $user.group -Members $user.username
    }
}