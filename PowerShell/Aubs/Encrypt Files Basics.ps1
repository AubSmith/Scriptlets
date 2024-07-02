# Get-Command -Noun CmsMessage

# Get-Help New-DocumentEncryptionCertificate
# Install-Package OpenSSL.Light

New-SelfSignedCertificate -Subject 'Smith.com' -Type DocumentEncryptionCertLegacyCsp

# dir Cert:\LocalMachine\My -DocumentEncryptionCert

$p = "This is a test" | Protect-CmsMessage -To 'Smith.com'
$p

Get-CmsMessage $p
$p | Unprotect-CmsMessage



