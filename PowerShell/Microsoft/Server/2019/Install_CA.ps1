# CA0
Rename-Computer -NewName winsvradcs000 -LocalCredential WS\Administrator -PassThru
shutdown -r -t 1

Install-WindowsFeature –Name AD-Certificate –IncludeManagementTools
Install-AdcsCertificationAuthority 
Install-AdcsCertificationAuthority -ValidityPeriod Years -ValidityPeriodUnits 20  -CACommonName "Wayne Enterprises Root CA" -CADistinguishedNameSuffix "DC=WayneEnterprises,DC=com" -CAType StandaloneRootCa -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -HashAlgorithmName "SHA256" -KeyLength 4096



# CA1
Rename-Computer -NewName winsvradcs001 -LocalCredential WS\Administrator -PassThru
Get-NetIPAddress
New-NetIPAddress -InterfaceIndex 4 -IPAddress 192.168.1.101 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses ("172.22.169.100","8.8.8.8")
Add-Computer -DomainName wayneent -Restart
Get-WindowsFeature

# CA2
Rename-Computer -NewName winsvradcs002 -LocalCredential WS\Administrator -PassThru
Get-NetIPAddress
New-NetIPAddress -InterfaceIndex 5 -IPAddress 192.168.1.102 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex 5 -ServerAddresses ("192.168.1.100","8.8.8.8")
Add-Computer -DomainName wayneent -Restart
Get-WindowsFeature