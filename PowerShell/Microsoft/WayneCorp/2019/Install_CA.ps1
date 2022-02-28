# CA0

# Pre - RootCAPolicy.inf C:\Windows\CAPolicy.inf
Rename-Computer -NewName winsvradcs000 -LocalCredential WS\Administrator -PassThru
shutdown -r -t 1

Install-WindowsFeature –Name AD-Certificate –IncludeManagementTools
Install-AdcsCertificationAuthority -ValidityPeriod Years -ValidityPeriodUnits 20  -CACommonName "Wayne Corporation Root CA" -CADistinguishedNameSuffix "DC=WayneCorp,DC=com" -CAType StandaloneRootCa -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -HashAlgorithmName "SHA256" -KeyLength 4096

Certutil -setreg CA\DSConfigDN "CN=Configuration,DC=WayneCorp,DC=com"

# To define CRL Period Units and CRL Period, run the following commands from an administrative command prompt: 
	Certutil -setreg CA\CRLPeriodUnits 52 
	Certutil -setreg CA\CRLPeriod "Weeks" 
	Certutil -setreg CA\CRLDeltaPeriodUnits 0 
# To define CRL Overlap Period Units and CRL Overlap Period, run the following commands from an administrative command prompt: 
	Certutil -setreg CA\CRLOverlapPeriodUnits 12 
	Certutil -setreg CA\CRLOverlapPeriod "Hours"

Certutil -setreg CA\ValidityPeriodUnits 20 
Certutil -setreg CA\ValidityPeriod "Years"

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
# certutil -ca.cert ca_name.cer

# Submit req
certreq -submit "C:\winsvradcs001.waynecorp.com_WayneCorp Issuing CA.req"

# Approve req
certutil -resubmit 2

# Extract certificate
certreq -retrieve 2 "C:\winsvradcs001.waynecorp.com_WayneCorp Issuing CA.crt"



# CA1
Get-NetIPAddress
New-NetIPAddress -InterfaceIndex 4 -IPAddress 192.168.1.101 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses "192.168.1.100"
Rename-Computer -NewName winsvradcs001 -LocalCredential WS\Administrator -PassThru
shutdown -r -t 0
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

certutil -installCert "D:\winsvradcs001.waynecorp.com_WayneCorp Issuing CA.crt"

Certutil -setreg CA\CRLPeriodUnits 2
Certutil -setreg CA\CRLPeriod "Years" 
Certutil -setreg CA\CRLDeltaPeriodUnits 2 
Certutil -setreg CA\CRLDeltaPeriod "Weeks"
Certutil -setreg CA\CRLOverlapPeriodUnits 1
Certutil -setreg CA\CRLOverlapPeriod "Weeks"
Certutil -setreg CA\ValidityPeriodUnits 10
Certutil -setreg CA\ValidityPeriod "Years" 

certutil -setreg CA\CACertPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%1_%3%4.crt\n2:ldap:///CN=%7,CN=AIA,CN=Public Key Services,CN=Services,%6%11\n2:http://pki.waynecorp.com/CertEnroll/%1_%3%4.crt"

certutil -getreg CA\CACertPublicationURLs

Copy-Item "D:\winsvradcs001.waynecorp.com_WayneCorp Issuing CA.crt" \\WinSvrIIS001\D$\CertEnroll\
Move-Item "D:\winsvradcs001.waynecorp.com_WayneCorp Issuing CA.crt" "c:\Windows\System32\certsrv\certenroll\"

certutil -setreg CA\CRLPublicationURLs "65:C:\Windows\system32\CertSrv\CertEnroll\%3%8%9.crl\n79:ldap:///CN=%7%8,CN=%2,CN=CDP,CN=Public Key Services,CN=Services,%6%10\n6:http://pki.waynecorp.com/CertEnroll/%3%8%9.crl\n65:\\pki.waynecorp.com\CertEnroll\%3%8%9.crl"

certutil -getreg CA\CRLPublicationURLs

cmd
net stop certsvc && net start certsvc
certutil -crl

# Execute after creating "ADCS Audit" GPO
Certutil -setreg CA\AuditFilter 127 

#####################################################################################

certutil -setreg CA\CACertPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%1_%3%4.crt\n2:ldap:///CN=%7,CN=AIA,CN=Public Key Services,CN=Services,%6%11\n2:http://pki.waynecorp.com/CertEnroll/%1_%3%4.crt"

certutil -getreg CA\CACertPublicationURLs

Copy-Item "c:\Windows\System32\certsrv\certenroll\winsvradcs001.waynecorp.com_WayneCorp Issuing CA.crt" \\pki.waynecorp.com\D$\certenroll\

certutil -setreg CA\CRLPublicationURLs "65:C:\Windows\system32\CertSrv\CertEnroll\%3%8%9.crl\n79:ldap:///CN=%7%8,CN=%2,CN=CDP,CN=Public Key Services,CN=Services,%6%10\n6:http://pki.waynecorp.com/CertEnroll/%3%8%9.crl\n65:\\pki.waynecorp.com\CertEnroll\%3%8%9.crl"

certutil -getreg CA\CRLPublicationURLs

cmd
net stop certsvc && net start certsvc
certutil -crl




# IIS1
Get-NetIPAddress
New-NetIPAddress -InterfaceIndex 4 -IPAddress 192.168.1.102 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses "192.168.1.100"

Rename-Computer -NewName winsvriis001 -LocalCredential WS\Administrator -PassThru
shutdown -r -t 0

Add-Computer -DomainName WayneCorp -Restart

Get-Volume

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
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $inheritance, $propagation, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$CertEnrollACL.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path "D:\CertEnroll" -AclObject $CertEnrollACL

Install-WindowsFeature -Name 

Online Responder
IIS 6 Metabase Compatibility
Management Service
ISAPI Extensions
Default Document
Directory Browsing
HTTP Errors
HTTP Redirection
Static Content
HTTP Logging
Logging Tools
Request Monitor
Tracing
Static Content Compression
Management Service
ASP.NET 4.7

net start WMSVC
sc.exe config WMSVC start= auto

New-WebVirtualDirectory -Site "Default Web Site" -Name "CertEnroll" -PhysicalPath "D:\CertEnroll"

# Enable-IisDirectoryBrowsing.ps1
Enable-IisDirectoryBrowsing -SiteName Default -Directory CertEnroll

# Verify Directory Browsing
Get-WebConfigurationProperty -filter /system.webServer/directoryBrowse -name enabled -PSPath 'IIS:\Sites\Default Web Site'

cmd
cd %windir%\system32\inetsrv\ 

Appcmd set config "Default Web Site" /section:system.webServer/Security/requestFiltering -allowDoubleEscaping:True
iisreset

Reg Add HKLM\Software\Microsoft\WebManagement\Server /V EnableRemoteManagement /T REG_DWORD /D 1

netsh advfirewall firewall add rule name=”Allow IIS Web Management” dir=in action=allow service=”WMSVC”


# Format disk
Get-Disk -Number 1 | Initialize-Disk -PassThru | New-Partition -DriveLetter D -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'Removable'

Copy-Item C:\Windows\System32\CertSrv\CertEnroll\* D:\

Get-ChildItem d:


#####################################################################################



# Change OSCP Response Signing Template to Server 2016 and Windows 10


Test-NetConnection 192.168.1.14 -port 135
PortQry.exe -e 135 -n 192.168.1.201
