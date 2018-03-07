<#
.SYNOPSIS
This script searches for PII on a specified file share. Just supply the script a path and the types of PII you're looking for and it will do the rest.

.DESCRIPTION
-Path - Path to file share
-S - Social Security Number
-V - Visa
-A - American Express
-M - Mastercard
-D - Discover
-A - Equivilant to -S -V -A -M -D

.EXAMPLE
.\get-pii.ps1 -Path \\server\share -S(SN) -V(isa) -A(mericanExpress) -M(astercard) -D(iscover) -All

#>

param(
[parameter(mandatory=$True)]$Path,
[switch]$S,
[switch]$V,
[switch]$A,
[switch]$M,
[switch]$D,
[switch]$All
)

#####################################################################################################
#####################################################################################################
##                                         FULL DISCLOSURE                                         ##
##     I found most of the Regex stuff at www.richardsramblings.com/regex/credit-card-numbers/     ##
##             These regex statements allow dashes and spaces to be in the card number             ##
##              I rewrote most of the statements to allow for dashes/spaces/no spaces              ##
#####################################################################################################
#####################################################################################################

$SSN = "\d{3}[ \-]\d{2}[ \-]\d{4}$"
$Visa = "^4\d{3}([\ \-]?)\d{4}[\ \-]\d{4}[\ \-]\d{4}$"
$AmericanExpress = "^3[47]\d{2}[\ \-]\d{4}[\ \-]\d{4}[\ \-]\d{4}$"
$MasterCard = @("^5[1-5]\d{2}([\ \-]?)\d{4}\1\d{4}\1\d{4}$", "^2720|2221\s{0,1}\d{4}\s{0,1}\d{4}\s{0,1}\d{4}$")
$Discover = "^6(?:011|22(?:1(?=[\ \-]?(?:2[6-9]|[3-9]))|[2-8]|9(?=[\ \-]?(?:[01]|2[0-5])))|4[4-9]\d|5\d\d)([\ \-]?)\d{4}\1\d{4}\1\d{4}$"


if($All)
{
    $S = $True
    $V = $True
    $A = $True
    $M = $True
    $D = $True
}
if($S)
{
    Write-Host "Collecting possible social security numbers..." -ForegroundColor Green
    Get-ChildItem -Recurse -Path $Path -Exclude *.*db, *.jpg, *.xps, *.pdf, *.bmp, *.xfdl, *.ppt, *.exe, *.dll | Select-String $SSN | select filename, line, path | Export-Csv ssn.csv -Append
}
if($V)
{
    Write-Host "Collecting possible Visa card numbers..." -ForegroundColor Green
    Get-ChildItem -Recurse -Path $Path -Exclude *.*db, *.jpg, *.xps, *.pdf, *.bmp, *.xfdl, *.ppt, *.exe, *.dll | Select-String $Visa | select filename, line, path | Export-Csv visa.csv -Append
}
if($A)
{
    Write-Host "Collecting possible American Express card numbers..." -ForegroundColor Green
    Get-ChildItem -Recurse -Path $Path -Exclude *.*db, *.jpg, *.xps, *.pdf, *.bmp, *.xfdl, *.ppt, *.exe, *.dll | Select-String $AmericanExpress | select filename, line, path | Export-Csv amexpress.csv -Append
}
if($M)
{
    Write-Host "Collecting possible Mastercard card numbers..." -ForegroundColor Green
    Get-ChildItem -Recurse -Path $Path -Exclude *.*db, *.jpg, *.xps, *.pdf, *.bmp, *.xfdl, *.ppt, *.exe, *.dll | Select-String $MasterCard | select filename, line, path | Export-Csv mastercard.csv -Append
}
if($D)
{
    Write-Host "Collecting possible Discover card numbers..." -ForegroundColor Green
    Get-ChildItem -Recurse -Path $Path -Exclude *.*db, *.jpg, *.xps, *.pdf, *.bmp, *.xfdl, *.ppt, *.exe, *.dll | Select-String $Discover | select filename, line, path | Export-Csv discover.csv -Append
}