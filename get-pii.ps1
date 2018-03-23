<#
.SYNOPSIS
This script searches for PII on a specified file share. Just supply the script a path and it will do the rest.

.DESCRIPTION
-Path - Path to file share

.EXAMPLE
.\get-pii.ps1 -Path \\server\share

#>

param(
[parameter(mandatory=$False)]$Path="$env:USERPROFILE\Desktop"
)


$SSN = "^\d{3}\s{0,1}[-]{0,1}\d{2}\s{0,1}[-]{0,1}\d{4}$"
$Visa = "^\d{4}\s{0,1}[-]{0,1}\d{4}\s{0,1}[-]{0,1}\d{4}\s{0,1}[-]{0,1}\d{4}$"
$AmericanExpress = "^3(4|7)\d{2}\s{0,1}[-]{0,1}\d{4}\s{0,1}[-]{0,1}\d{4}\s{0,1}[-]{0,1}\d{4}$"
$MasterCard = "^(5[1-5]\d{2}|2720|2221)\s{0,1}[-]{0,1}\d{4}\s{0,1}[-]{0,1}\d{4}\s{0,1}[-]{0,1}\d{4}$"
$Discover = "^6(?:011|22(?:1(?=[\ \-]?(?:2[6-9]|[3-9]))|[2-8]|9(?=[\ \-]?(?:[01]|2[0-5])))|4[4-9]\d|5\d\d)([\ \-]?)\d{4}\1\d{4}\1\d{4,7}$"

$saveDirectory = "$env:USERPROFILE\Desktop\PIIScan"
$datetime = Get-Date -Format "MMM_dd_yyyy"
$saveFile = "$saveDirectory\PII_scan_$datetime.csv"

Write-Host "Creating PIIScan directory if applicable..."
New-Item -Path $saveDirectory -ItemType Directory -ErrorAction SilentlyContinue

Write-Host "Collecting possible PII..." -ForegroundColor Green
Get-ChildItem -Recurse -Path $Path -Exclude *.*db, *.jpg, *.xps, *.pdf, *.bmp, *.xfdl, *.ppt, *.exe, *.dll -ErrorAction SilentlyContinue | Select-String $SSN, $Visa, $AmericanExpress, $MasterCard, $Discover | select linenumber, filename, path | Export-csv "$saveFile" -Append
Write-Host "Finished collecting possible PII..." -ForegroundColor Yellow