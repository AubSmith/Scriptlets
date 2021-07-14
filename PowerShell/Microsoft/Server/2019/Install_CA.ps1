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

# Submit req
certreq -submit "C:\winsvradcs001.waynecorp.com_Wayne Corporation Issuing CA.req"

# Approve req
certutil -resubmit 2

# Extract certificate
certreq -retrieve 2 "C:\winsvradcs001.waynecorp.com_WayneCorp Issuing CA.crt"



# CA1
Rename-Computer -NewName winsvradcs001 -LocalCredential WS\Administrator -PassThru
Get-NetIPAddress
New-NetIPAddress -InterfaceIndex 6 -IPAddress 192.168.1.101 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses ("192.168.1.100","8.8.8.8")
Add-Computer -DomainName WayneCorp -Restart
Get-WindowsFeature
Install-WindowsFeature –Name AD-Certificate –IncludeManagementTools
Install-AdcsCertificationAuthority -CACommonName "Wayne Corporation Issuing CA" -CADistinguishedNameSuffix "DC=WayneCorp,DC=com" -CAType EnterpriseSubordinateCa -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -HashAlgorithmName "SHA256" -KeyLength 4096

Get-Disk | Where-Object IsOffline -eq True
Set-Disk -Number 1 -isOffline $false
Get-Volume

certutil -f -dspublish "D:\winsvradcs000_Wayne Corporation Root CA.crt" RootCA 
certutil -f -dspublish "D:\Wayne Corporation Root CA.crl" winsvradcs000

Copy-Item D:* \\WinSvrIIS001\D$\CertEnroll

certutil -addstore -f root "D:\winsvradcs000_Wayne Corporation Root CA.crt" 
certutil -addstore -f root "D:\Wayne Corporation Root CA.crl"

certutil -installCert "C:\winsvradcs001.waynecorp.com_WayneCorp Issuing CA.crt"

Certutil -setreg CA\CRLPeriodUnits 2
Certutil -setreg CA\CRLPeriod "Years" 
Certutil -setreg CA\CRLDeltaPeriodUnits 2 
Certutil -setreg CA\CRLDeltaPeriod "Weeks"
Certutil -setreg CA\CRLOverlapPeriodUnits 1
Certutil -setreg CA\CRLOverlapPeriod "Weeks"
Certutil -setreg CA\ValidityPeriodUnits 10
Certutil -setreg CA\ValidityPeriod "Years" 




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

# Enable-IisDirectoryBrowsing.ps1
Enable-IisDirectoryBrowsing -SiteName Default -Directory CertEnroll

# Verify Directory Browsing
Get-WebConfigurationProperty -filter /system.webServer/directoryBrowse -name enabled -PSPath 'IIS:\Sites\Default Web Site'

cmd
cd %windir%\system32\inetsrv\ 

Appcmd set config "Default Web Site" /section:system.webServer/Security/requestFiltering -allowDoubleEscaping:True
iisreset

# Create DNS alias
Add-DnsServerResourceRecordCName -Name "pki" -HostNameAlias "winsvriis001.waynecorp.com" -ZoneName "waynecorp.com"

# Format disk
Get-Disk | Where-Object PartitionStyle -eq 'RAW' | Initialize-Disk -PassThru | New-Partition -DriveLetter D -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'Removable'

Copy-Item C:\Windows\System32\CertSrv\CertEnroll\* D:\

Get-ChildItem d:
