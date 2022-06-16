$user = 'domain\username'
$SamAccountName = $user.Split('\')[1]
Get-ADUser -Identity $SamAccountName -Properties EmailAddress