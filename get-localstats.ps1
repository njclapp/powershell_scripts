<#
.SYNOPSIS
This script creates a custom object that contains multiple stats about the local computer

.EXAMPLE
.\compstats.ps1
#>

$info = New-Object System.Object

$info | Add-Member -Type NoteProperty -Name Hostname -Value $env:COMPUTERNAME
$info | Add-Member -Type NoteProperty -Name RunningProcesses -Value $(Get-Process).count
$info | Add-Member -Type NoteProperty -Name RuningServices -Value $(Get-Service).count
$info | Add-Member -Type NoteProperty -Name StoppedServices -Value $(Get-Service | Where-Object status -Match "Stopped").count
$info | Add-Member -Type NoteProperty -Name Date -Value $(Get-Date)
$info | Add-Member -Type NoteProperty -Name OS -Value $(Get-CimInstance Win32_OperatingSystem)
$info | Add-Member -Type NoteProperty -Name CPU -Value $(Get-CimInstance CIM_Processor)
$info | Add-Member -Type NoteProperty -Name HDDUsed $([math]::Round((((Get-CimInstance Win32_LogicalDisk -Filter drivetype=3).size/1GB)-(Get-WmiObject Win32_LogicalDisk -Filter drivetype=3).FreeSpace/1GB),2))
$info | Add-Member -Type NoteProperty -Name HDDSize $([math]::Round(((Get-CimInstance Win32_LogicalDisk -Filter drivetype=3).size/1GB),2))

$info