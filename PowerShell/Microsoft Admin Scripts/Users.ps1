# Find domain admins
get-adgroupmember 'domain admins' | Select-Object name,samaccountname
get-adgroupmember 'enterprise admins' | Select-Object name,samaccountname

# Set user password
Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$newPass" -Force)