# CA0

# Pre - RootCAPolicy.inf C:\Windows\CAPolicy.inf
Rename-Computer -NewName winsvradcs000 -LocalCredential WS\Administrator -PassThru
shutdown -r -t 1

Install-WindowsFeature –Name AD-Certificate –IncludeManagementTools
Install-AdcsCertificationAuthority -ValidityPeriod Years -ValidityPeriodUnits 20  -CACommonName "Wayne Corporation Root CA" -CADistinguishedNameSuffix "DC=WayneCorp,DC=com" -CAType StandaloneRootCa -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -HashAlgorithmName "SHA256" -KeyLength 4096

# To define CRL Period Units and CRL Period, run the following commands from an administrative command prompt: 
	Certutil -setreg CA\CRLPeriodUnits 52 
	Certutil -setreg CA\CRLPeriod "Weeks" 
	Certutil -setreg CA\CRLDeltaPeriodUnits 0 
# To define CRL Overlap Period Units and CRL Overlap Period, run the following commands from an administrative command prompt: 
	Certutil -setreg CA\CRLOverlapPeriodUnits 12 
	Certutil -setreg CA\CRLOverlapPeriod "Hours"

shutdown -r -t 1

AuditPol /set /Subcategory:"Certification Services" /failure:enable /success:enable
Certutil -setreg CA\AuditFilter 127

# Set AIA
certutil -setreg CA\CACertPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%1_%3%4.crt\n2:ldap:///CN=%7,CN=AIA,CN=Public Key Services,CN=Services,%6%11\n2:http://pki.WayneCorp.com/CertEnroll/%1_%3%4.crt"

# Set CDP
certutil -setreg CA\CRLPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%3%8%9.crl\n10:ldap:///CN=%7%8,CN=%2,CN=CDP,CN=Public Key Services,CN=Services,%6%10\n2:http://pki.WayneCorp.com/CertEnroll/%3%8%9.crl"

Restart-Service certsvc

certutil -crl

# Export root certificate
certutil -ca.cert ca_name.cer



# CA1
Rename-Computer -NewName winsvradcs001 -LocalCredential WS\Administrator -PassThru
Get-NetIPAddress
New-NetIPAddress -InterfaceIndex 6 -IPAddress 192.168.1.101 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses ("192.168.1.100","8.8.8.8")
Add-Computer -DomainName WayneCorp -Restart
Get-WindowsFeature



# IIS1
Get-NetIPAddress
New-NetIPAddress -InterfaceIndex 6 -IPAddress 192.168.1.102 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses ("192.168.1.100","8.8.8.8")

Rename-Computer -NewName winsvriis001 -LocalCredential WS\Administrator -PassThru
shutdown -r -t 0

Add-Computer -DomainName WayneCorp -Restart

# Format disk
Get-Disk | Where-Object PartitionStyle -eq 'RAW' | Initialize-Disk -PassThru | New-Partition -DriveLetter D -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'Data'

# Create CertEnroll
mkdir D:\CertEnroll

# Set NTFS permissions
$CertEnrollACL = Get-Acl -Path "D:\CertEnroll"
# Set properties
$identity = "WayneCorp\Cert Publishers"
$fileSystemRights = "Modify"
$type = "Allow"
$inheritance = 'ContainerInherit, ObjectInherit'
$propagation = 'None'
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type, $inheritance, $propagation
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$CertEnrollACL.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path "D:\CertEnroll" -AclObject $CertEnrollACL

Install-WindowsFeature -Name 

New-WebVirtualDirectory -Site "Default Web Site" -Name "CertEnroll" -PhysicalPath "D:\CertEnroll"
