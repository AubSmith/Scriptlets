<#
Get-ADUser esmith
Get-AdUser -Name esmith
Get-LocalUser
#>

$Password = Read-Host "Enter new password: " -AsSecureString

$UserAccount = Get-LocalUser -Name "Ethan" 
$UserAccount | Set-LocalUser -Password $Password
