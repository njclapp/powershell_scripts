<#
.SYNOPSIS
This script invokes a password reset on a CSV file that the user gives it. It also forces users to change their password on next login.

.DESCRIPTION
Contributers
---------------------
Nathanael Clapp <nathanael.clapp@sdstate.edu>

.PARAMETER csvFile
CSV file to pull data from, must have a heading of 'samaccountname'

.EXAMPLE
invoke-reset.ps1 -csvFile <file.csv>
#>

param(
[parameter(mandatory=$true)]$csvFile 
)

$Password = ConvertTo-SecureString -AsPlainText "Password1!" -Force

foreach($student in $(Import-Csv $csvFile)){
    $object = New-Object PSObject
    Set-ADAccountPassword -Identity $student.samaccountname -NewPassword $Password -Reset -InformationAction SilentlyContinue
    Set-ADUser $student.samaccountname -ChangePasswordAtLogon $true
    Write-Host " AD Password has been reset for: "$student.samaccountname
    $object | Add-Member -MemberType NoteProperty -Name samAccountName -Value $student.samaccountname
    $object | Export-Csv ADReset.csv -Append
}