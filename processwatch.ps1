<#
.SYNOPSIS
This script watches a PID to see if it has died and quits if it does.

.PARAMETER id
PID to watch

.PARAMETER time
Time to wait between checks

.EXAMPLE
processwatch.ps1 <PID> <time>
#>

param(
[parameter(mandatory=$true)]$id,[parameter(mandatory=$false)]$time=5
)

$name = Get-Process -Id $id | Select-Object -expand Name

while($true)
{
    if(Get-Process -Id $id -ErrorAction SilentlyContinue)
    {
        Write-Host "$name is running"
        sleep $time
    }
    else
    {
        Write-Host "Process has died"
        break
    }
}