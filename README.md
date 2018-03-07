# powershell_scripts
This repository is used for scripts that may be useful in future AD and VMWare related administration jobs.
It is a collection of scripts I wrote in my final year of college 2018 and will be used for scripts I write in the future.

## create-ADUsers.ps1
This script takes a csv file of usernames, and creates users in the correct groups on an AD server or on the local system.

## create-localuser.ps1
This script takes a list of usernames and creates new users from them on the local system.

## get-information.ps1
This script gets information about a specified computer on the network. If no computer name is given, it will resort to finding information about the current machine.

## get-localstats.ps1
Like get-information.ps1, this script finds information about a computer. This script is local only.

## get-pii.ps1
This script searches for PII on a specified file path(including file share paths). Just supply the script a path and the types of PII you're looking for and it will do the rest.

## maintain-ADUsers.ps1
This script finds stale user accounts, prints out details of the stale account, and confirms with the user before each disabling the account.

## processwatch.ps1
This script watches a PID to see if it has died. If it has, it currently stops running.

## push-vm.ps1
This is a powerCLI script to deploy VMware virtual machines to a VCenter server. It is assumed that the user is already using powerCLI and is logged into the VCenter server before running this script.