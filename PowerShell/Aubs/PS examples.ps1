## File System Provider ##

<# Must be run from PowerShell shell #>

cmd
echo %windir%
exit
Set-Location Env:
dir
Get-Item .\windir
(Get-Item windir).Value
$env:windir

CD C:\
New-Item -Path C:\NotBackedUp\Test -ItemType Directory
New-Item -Path C:\NotBackedUp\Test\Test -ItemType Directory | Out-Null
CD NotBackedUp\Test

## OR ##

Set-Location C:\NotBackedUp\Test

New-Item -Name Test.txt -ItemType File

Add-Content -Path .\Test.txt -Value "This is really awesome!"
Get-Content -Path .\Test.txt
CD C:\

Remove-Item C:\NotBackedUp\Test

## Function Provider ##

Get-ChildItem Function:
Get-Content Function:\mkdir
Get-Content Function:\mkdir >> C:\NotBackedUp\mkdirFunction.txt

## Registry Provider ##

Get-PSDrive -PSProvider Registry | Select Name, root
New-PSDrive -PSProvider Registry -Root HKEY_CLASSES_ROOT -Name HKCR
Set-Location HKCR:
Get-Location
DIR

Get-Item .\.ps1 | fl *
Get-ItemProperty .\.PS1 | fl *
(Get-ItemProperty .\.ps1 -Name '(default)').'(default)'
Get-PSDrive | WHERE Provider -Like "*Registry*"

<# Create registry key 1 #>

Push-Location
Set-Location HKCU:
Test-Path .\Software\Sample
New-Item -Path .\Software -Name sample
Pop-Location

<# Create registry key 2 #>

New-Item -Path HKCU:\Software -Name Test -Force

# Use get-member -force to see hidden methods or properties

# Invoke-Item Current Path

ii .

Get-Help * -Parameter ComputerName | Sort Name | FT Name, Synopsis -Auto -Wrap

Get-WinEvent -LogName Application -MaxEvents 1 -ComputerName ex1 -Credential smith\adminitrator

Get-Service -ComputerName ex1 -Name BITS #Does not have crdential parameter, therefore impersonates logged-on user

Enable-PSRemoting #Enables remote management

Enable-PSRemoting -Force #Bypasses prompts

Test-WSMan -ComputerName ex1 #Test WinRM remoting 