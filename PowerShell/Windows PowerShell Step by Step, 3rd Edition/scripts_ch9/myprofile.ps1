# myprofile.ps1
# ed wilson, msft 5/22/2012

#aliases
New-Alias -Name gh -Value get-help
New-Alias -Name i -Value Invoke-History

#variables
New-Variable -Name MyDocuments -Value ([environment]::GetFolderPath("mydocuments"))
New-Variable -Name ConsoleProfile -Value (Join-Path -Path $mydocuments -ChildPath WindowsPowerShell\Microsoft.PowerShell_profile.ps1)
New-Variable -Name ISEProfile -Value (Join-Path -Path $mydocuments -ChildPath WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1)

#psdrives
New-PSDrive -Name HKCR -PSProvider Registry -Root hkey_classes_root 
New-PSDrive -Name mycerts -PSProvider Certificate -Root Cert:\CurrentUser\My

#functions
Function Set-MyProfile
{
 ise C:\fso\myprofile.ps1
} # end function set-myprofile

#commands
Set-Location -Path c:\
Clear-Host
