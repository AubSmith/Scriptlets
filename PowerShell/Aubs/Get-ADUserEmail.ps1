# Retrieve the email address of a user in Active Directory
$User = Get-ADUser -Identity "username" -Properties EmailAddress
$EmailAddress = $User.EmailAddress
$EmailAddress
