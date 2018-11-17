#Requires -runasadministrator

<#
.SYNOPSIS
This script maps out an active directory environment. Useful for use in a new environment.

.EXAMPLE
./Invoke-Exploration.ps1
#>

$output = New-Object System.Object

$output | Add-Member -MemberType NoteProperty -Name User_Count -Value $(Get-ADUser -Filter * | measure).count
$output | Add-Member -MemberType NoteProperty -Name Computer_Count -Value $(Get-ADComputer -Filter * | measure).Count
$output | Add-Member -MemberType NoteProperty -Name DC_Count -Value $(Get-ADDomainController -Filter *).count
$output | Add-Member -MemberType NoteProperty -Name ReplicaDC -Value $(Get-ADDomain).ReplicaDirectoryServers
$output | Add-Member -MemberType NoteProperty -Name Group_Count -Value $(Get-ADGroup -Filter * | where {$_.GroupScope -like "Global"}).count
$output | Add-Member -MemberType NoteProperty -Name OU_Count -Value $(Get-ADOrganizationalUnit -Filter *).count

$DCs = Get-ADDomainController -Filter * | ft Name,IPv4Address,Forest,Domain,OperatingSystem
$Groups = Get-ADGroup -Filter * | where {$_.GroupScope -like "Global"} | ft Name,GroupScope,GroupCategory
$OUs = Get-ADOrganizationalUnit -Filter * | ft Name,ObjectClass


$output | fl

Write-Output "DC Names"
Write-Output "-----------"
$DCs

Write-Output "AD Groups"
Write-Output "-----------"
$Groups

Write-Output "AD OUs"
Write-Output "-----------"
$OUs