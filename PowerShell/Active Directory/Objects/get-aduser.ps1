import-module ActiveDirectory

Get-ADUser esmith -Properties *

Get-ADUser -Filter * -Properties EmailAddress,DisplayName, samaccountname| select EmailAddress, DisplayName

Get-ADUser -Filter * -Properties EmailAddress,DisplayName, samaccountname| select EmailAddress, DisplayName, samaccountname | Export-CSV D:\PowerShell\Ad_user_email_Address.csv

$users = Get-Content .\samaccountname.txt
$users | ForEach-Object {
    Get-ADUser -Identity $_ -properties mail | Select samaccountname,mail
} | Export-CSV aduserEmails.txt -NoTypeInformation

Get-ADUser -Filter {Emailaddress -eq 'ethan.smith@waynecorp.com'}

##### Get AD User by Display Name #####

# Import csv file and read display names of user
$UserNames = Import-Csv -Path D:\AdusersList.csv
foreach ($un in $UserNames)
{
    $displayName = $un.DisplayName.Replace(',', ' ')
    Write-Host $displayName
    # Get email address from display name using filter parameter
    Get-Aduser -Filter "DisplayName -eq '$displayName'" -Properties EmailAddress, mail
}

##########

Get-ADUser -Filter {mail -notlike '*'} -Property EmailAddress  | Select Name,EmailAddress

Get-ADUser -Filter * -Property EmailAddress | Where { $_.EmailAddress -ne $null }| Select Name,EmailAddress

$user = "garyw"
$Manager = get-aduser $user -properties * | Select -ExpandProperty Manager
get-aduser $Manager -properties * | Select EmailAddress
