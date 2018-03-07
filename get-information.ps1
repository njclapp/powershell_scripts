#Requires -runasadministrator

<#
.SYNOPSIS
This script gets information about a specified computer on the network. If no computer name is given, it will resort to finding information about the current machine.

.EXAMPLE
You must run this script as administrator. Failure to do so will prevent this script from running.

To run:
.\get-information [-ComputerName <computer, names, array>] [-RunningProcesses] [-ComputerInfo] [-Services] [-Updates] [-LocalUsers] [-DomainUsers]

#>

param(
[Array]$ComputerName=@(),
[Switch]$RunningProcesses,
[Switch]$ComputerInfo,
[Switch]$Services,
[Switch]$Updates,
[Switch]$LocalUsers,
[Switch]$DomainUsers
)
Import-Module ActiveDirectory

$LogPath = "C:\ComputerInfo" # For less typing

##############################################################
# SET $COMPUTERNAME ARRAY TO LOCAL HOSTNAME, IF NOT SUPPLIED #
##############################################################
if(!$ComputerName)
{
    $ComputerName = $env:COMPUTERNAME
}

##################################
# TEST FOR VALID DIRECTORY PATHS #
#      AND CREATE IF NEEDED      #
##################################
if(!(Test-Path $LogPath))
{
    Write-Host "$LogPath does not exist, creating directory now..."
    New-Item -ItemType Directory -Path $LogPath | Out-Null
}
foreach($computer in $ComputerName)
{
    if(!(Test-Path $LogPath\$computer))
    {
        Write-Host "$LogPath\$computer does not exist, creating directory now..."
        New-Item -ItemType Directory -Path $LogPath\$computer | Out-Null
    }
}

#######################
#     MAIN SCRIPT     #
#######################
if($RunningProcesses)
{
    write-host
    foreach($computer in $ComputerName)
    {
        Write-Host "Exporting running processes for $computer..."
        Invoke-Command -ComputerName $computer -ScriptBlock {Get-Process} | Export-Csv -Path $LogPath\$computer\Running_Processes.csv
    }
}
if($ComputerInfo)
{
    Write-Host
    foreach($computer in $ComputerName)
    {
        Write-Host "Exporting statistics for $computer..."
        $info = New-Object System.Object

        $info | Add-Member -Type NoteProperty -Name Computer_Name -Value $(Get-WmiObject Win32_ComputerSystem -ComputerName $computer).Name
        $info | Add-Member -Type NoteProperty -Name Domain -Value $(Get-WmiObject Win32_ComputerSystem -ComputerName $computer).Domain
        $info | Add-Member -Type NoteProperty -Name Manufacturer -Value $(Get-WmiObject Win32_ComputerSystem -ComputerName $computer).Manufacturer
        $info | Add-Member -Type NoteProperty -Name OS_Version -Value $(Get-WmiObject Win32_OperatingSystem -ComputerName $computer).Version
        $info | Add-Member -Type NoteProperty -Name Model -Value $(Get-WmiObject Win32_ComputerSystem -ComputerName $computer).Model
        $info | Add-Member -Type NoteProperty -Name CPU -Value $(Get-WmiObject Win32_Processor -ComputerName $computer).Name
        $info | Add-Member -Type NoteProperty -Name CPU_Manufacturer -Value $(Get-WmiObject Win32_Processor -ComputerName $computer).Manufacturer
        $info | Add-Member -Type NoteProperty -Name Max_CPU_Speed -Value $(Get-WmiObject Win32_Processor -ComputerName $computer).MaxClockSpeed
        $info | Add-Member -Type NoteProperty -Name Physical_RAM -Value $(Get-WmiObject Win32_ComputerSystem -ComputerName $computer).TotalPhysicalMemory
        
        $info | Export-Csv $LogPath\$computer\Computer_Stats.csv
    }
}
if($Services)
{
    Write-Host
    foreach($computer in $ComputerName)
    {
        Write-Host "Exporting all services for $computer..."
        Get-Service -ComputerName $ComputerName | Export-Csv $LogPath\$computer\Running_Services.csv
    }
}
if($Updates)
{
    Write-Host
    foreach($computer in $ComputerName)
    {
        Write-Host "Exporting list of installed patches for $computer..."
        Get-HotFix -ComputerName $computer | Export-Csv $LogPath\$computer\Installed_Patches.csv
    }
}
if($LocalUsers)
{
    Write-Host
    foreach($computer in $ComputerName)
    {
        Write-Host "Exporting list of local users for $computer..."
        Invoke-Command -ComputerName $computer -ScriptBlock {(Get-WmiObject Win32_UserAccount -Filter LocalAccount=$True) | Select Name} | Export-Csv $LogPath\$computer\Local_Users.csv
    }
}
if($DomainUsers)
{
    Write-Host

    Write-Host "Exporting list of domain user accounts..."
    (Get-ADUser -Filter "*" | Select SamAccountName) | Export-Csv $LogPath\Domain_Accounts.csv
}