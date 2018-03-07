<#
.SYNOPSIS
This script takes in several parameters and creates the necessary folders and VMs for a vcenter server.

It is assumed that you are running the script in powercli and are connected to the vcenter server you want to create the VMs on.

.EXAMPLES
.\push-vm.ps1 -Template <vcenter_template> -UserFile <local_user_file> -Class <class_name> -VMName <VM_Name> [-VMHost <vmhost.domain.lan>]
#>
param(
[parameter(Mandatory=$true)]$Template,
[parameter(Mandatory=$true)]$UserFile,
[parameter(Mandatory=$true)]$Class,
[parameter(Mandatory=$true)]$VMName,
[parameter(Mandatory=$false)]$VMHost="esxi1.domain.lan"
)

if(!(Get-Folder Classes -ErrorAction SilentlyContinue))
{
    Write-Host "Creating classes folder..." -ForegroundColor Red
    New-Folder -Name Classes -Location vm | Out-Null
}
if(!(Get-Folder $Class -ErrorAction SilentlyContinue))
{
    Write-Host "Creating class $Class..." -ForegroundColor Red
    New-Folder -Name $Class -Location Classes | Out-Null
}

foreach($user in $(get-content $UserFile))
{
    if(!(Get-Folder $user'_'$Class -ErrorAction SilentlyContinue))
    {
        Write-Host "Creating folder"$user"_"$Class"..." -ForegroundColor Red
        New-Folder -Name $user'_'$Class -Location $Class | Out-Null
        Write-Host "Creating VM for"$user"..." -ForegroundColor Cyan
        New-VM -Name $VMName -Location $user"_"$Class -Template $Template -VMHost $VMHost
    }
    else
    {
        Write-Host "Creating VM for"$user"..." -ForegroundColor Cyan
        New-VM -Name $VMName -Location $user"_"$Class -Template $Template -VMHost $VMHost
    }
}
