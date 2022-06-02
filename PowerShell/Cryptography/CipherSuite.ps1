# View enabled cypher suites TLS can use
Get-TlsCipherSuite

Get-TlsCipherSuite -Name "DES"


# Enable cypher suite
Enable-TlsCipherSuite -Name "TLS_DHE_DSS_WITH_AES_256_CBC_SHA"

# Set lowest priotiy
Enable-TlsCipherSuite -Name "TLS_DHE_DSS_WITH_AES_256_CBC_SHA" -Position 4294967295
# Set highest priority
Enable-TlsCipherSuite -Name "TLS_DHE_DSS_WITH_AES_256_CBC_SHA" -Position 0


# Disable cypher suite
Disable-TlsCipherSuite -Name "TLS_RSA_WITH_3DES_EDE_CBC_SHA"

# Disables a TLS cipher suite.
Disable-TlsCipherSuite	

# Disables the Elliptic Curve Cryptography (ECC) cipher suites available for TLS(Transport Layer Security) for a computer.
Disable-TlsEccCurve	

# Disables a TLS session ticket key.
Disable-TlsSessionTicketKey	

# Enables a TLS cipher suite.
Enable-TlsCipherSuite	

# Enables Elliptic Curve Cryptography (ECC) cipher suites available for TLS.
Enable-TlsEccCurve	

# Configures a TLS server with a TLS session ticket key.
Enable-TlsSessionTicketKey	

# Exports a TLS session ticket key.
Export-TlsSessionTicketKey	

# Gets the TLS cipher suites for a computer.
Get-TlsCipherSuite	

# Gets the list of Elliptic Curve Cryptography (ECC) cipher suites available for TLS for a computer.
Get-TlsEccCurve	

# Creates a TLS session ticket key configuration file.
New-TlsSessionTicketKey	

# Import cert
Import-Certificate -FilePath "C:\Users\xyz\Desktop\BackupCert.Cer" -CertStoreLocation cert:\CurrentUser\Root
# OR
Set-Location -Path cert:\CurrentUser\My
Import-Certificate -Filepath "C:\files\intermediate.cert"
# OR
Import-Certificate -FilePath "C:\Users\Xyz\Desktop\BackupCert.Cer" -CertStoreLocation Cert:\LocalMachine\Root

# Import-PfxCertificate
$mypwd = Get-Credential -UserName 'Enter password below' -Message 'Enter password below'
Import-PfxCertificate -FilePath C:\mypfx.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $mypwd.Password
# OR
Get-ChildItem -Path c:\mypfx\my.pfx | Import-PfxCertificate -CertStoreLocation Cert:\CurrentUser\My -Exportable
# OR
Set-Location -Path cert:\localMachine\my
Import-PfxCertificate -FilePath c:\mypfx.pfx

# New-SelfSignedCertificate
New-SelfSignedCertificate -DnsName "www.fabrikam.com", "www.contoso.com" -CertStoreLocation "cert:\LocalMachine\My"
# OR
Set-Location -Path "cert:\LocalMachine\My"
$OldCert = (Get-ChildItem -Path E42DBC3B3F2771990A9B3E35D0C3C422779DACD7)
New-SelfSignedCertificate -CloneCert $OldCert
#OR
New-SelfSignedCertificate -Type Custom -Subject "E=patti.fuller@contoso.com,CN=Patti Fuller" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.4","2.5.29.17={text}email=patti.fuller@contoso.com&upn=pattifuller@contoso.com") -KeyAlgorithm RSA -KeyLength 2048 -SmimeCapabilities -CertStoreLocation "Cert:\CurrentUser\My"
# OR
New-SelfSignedCertificate -Type Custom -Subject "CN=Patti Fuller,OU=UserAccounts,DC=corp,DC=contoso,DC=com" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2","2.5.29.17={text}upn=pattifuller@contoso.com") -KeyUsage DigitalSignature -KeyAlgorithm RSA -KeyLength 2048 -CertStoreLocation "Cert:\CurrentUser\My"
# OR
New-SelfSignedCertificate -Type Custom -Subject "CN=Patti Fuller,OU=UserAccounts,DC=corp,DC=contoso,DC=com" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2","2.5.29.17={text}upn=pattifuller@contoso.com") -KeyUsage DigitalSignature -KeyAlgorithm ECDSA_nistP256 -CurveExport CurveName -CertStoreLocation "Cert:\CurrentUser\My"
# OR
New-SelfSignedCertificate -Type Custom -Provider "Microsoft Platform Crypto Provider" -Subject "CN=Patti Fuller" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2","2.5.29.17={text}upn=pattifuller@contoso.com") -KeyExportPolicy NonExportable -KeyUsage DigitalSignature -KeyAlgorithm RSA -KeyLength 2048 -CertStoreLocation "Cert:\CurrentUser\My"
# OR
New-SelfSignedCertificate -Type Custom -Container test* -Subject "CN=Patti Fuller" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2","2.5.29.17={text}upn=pattifuller@contoso.com") -KeyUsage DigitalSignature -KeyAlgorithm RSA -KeyLength 2048 -NotAfter (Get-Date).AddMonths(6)
# OR
New-SelfSignedCertificate -Type Custom -Subject "E=patti.fuller@contoso.com,CN=Patti Fuller" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.4","2.5.29.17={text}email=patti.fuller@contoso.com&email=pattifuller@contoso.com") -KeyAlgorithm RSA -KeyLength 2048 -SmimeCapabilities -CertStoreLocation "Cert:\CurrentUser\My"
# OR
New-SelfSignedCertificate -Subject "localhost" -TextExtension @("2.5.29.17={text}DNS=localhost&IPAddress=127.0.0.1&IPAddress=::1")

# Test-Certificate
Get-ChildItem -Path Cert:\localMachine\My | Test-Certificate -Policy SSL -DNSName "dns=contoso.com"
Test-Certificate -Cert cert:\currentuser\my\191c46f680f08a9e6ef3f6783140f60a979c7d3b -AllowUntrustedRoot -EKU "1.3.6.1.5.5.7.3.1" -User
