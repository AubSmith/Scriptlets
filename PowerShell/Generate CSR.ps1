Write-Host "Creating CertificateRequest(CSR) for $CertName `r "

Invoke-Command -ComputerName "Win16IIS1" -ScriptBlock {

$CertName = "Aubs.dev"
$CSRPath = "D:\$($CertName)_.csr"
$INFPath = "D:\$($CertName)_.inf"
$Signature = '$Windows NT$' 
 
 
$INF =
@"
[Version]
Signature= "$Signature" 
 
[NewRequest]
Subject = "CN=$CertName, OU=Information Technoloy, O=Private Ltd, L=Rolleston, S=South Island, C=NZ"
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
FriendlyName = "findme.dev"

[Extensions]
2.5.29.17 = "{text}"
_continue_ = "DNS=findme.dev&"
 
"@

write-Host "Certificate Request is being generated `r "
$INF | out-file -filepath $INFPath -force
certreq -new $INFPath $CSRPath

}
write-output "Certificate Request has been generated"
