Write-Host "Creating CertificateRequest(CSR) for $CertName `r "

Invoke-Command -ComputerName "servername" -ScriptBlock {

$CertName = "smithservice.smith.com"
$CSRPath = "D:\$($CertName)_.csr"
$INFPath = "D:\$($CertName)_.inf"
$Signature = '$Windows NT$' 
 
 
$INF =
@"
[Version]
Signature= "$Signature" 
 
[NewRequest]
Subject = "CN=$CertName, OU=Information Technoloy, O=Smith, L=Chch, S=Canterbury, C=NZ"
KeySpec = 1
KeyLength = 2048
Exportable = TRUE
MachineKeySet = TRUE
SMIME = False
PrivateKeyArchive = FALSE
UserProtected = FALSE
UseExistingKeySet = FALSE
ProviderName = "Microsoft RSA SChannel Cryptographic Provider"
ProviderType = 12
RequestType = PKCS10
KeyUsage = 0xa0
FriendlyName = "smithservice.smith.com"

[Extensions]
2.5.29.17 = "{text}"
_continue_ = "DNS=smithservice.smith.com&"

"@

write-Host "Certificate Request is being generated `r "
$INF | out-file -filepath $INFPath -force
certreq -new $INFPath $CSRPath

}
write-output "Certificate Request has been generated"
