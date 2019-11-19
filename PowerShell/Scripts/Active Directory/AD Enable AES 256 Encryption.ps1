# The numerical values for Kerberos AES encryption types to support
$AES128 = 0x8
$AES256 = 0x10

# Fetch all users from an OU with their current support encryption types attribute
$Users = Get-ADUser -Filter * -SearchBase "OU=SecureUsers,OU=Users,DC=domain,DC=tld" -Properties "msDS-SupportedEncryptionTypes"
foreach($User in $Users)
{
    # If none are currently supported, enable AES256
    $encTypes = $User."msDS-SupportedEncryptionType"
    if(($encTypes -band $AES128) -ne $AES128 -and ($encTypes -band $AES256) -ne $AES256)
    {
        Set-ADUser $User -Replace @{"msDS-SupportedEncryptionTypes"=($encTypes -bor $AES256)}
    }
}