<#
.SYNOPSIS
This script takes a list of usernames and creates new users from them on the local system.

.PARAMETER file
File name to input to the file

.EXAMPLE
usercreate.ps1 -file <file.txt>
#>

param(
[parameter(Mandatory=$true)]$file
)

$pass = Read-Host "Enter Password" -AsSecureString
$file = Get-Content $file

foreach ($user in $file)
{
    New-LocalUser -Name $user -Password $pass
    Add-LocalGroupMember -Group "Users" -Member $user
}