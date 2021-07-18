# Sconfig - Mange server

Get-NetIPAddress
New-NetIPAddress -InterfaceIndex 5 -IPAddress 192.168.1.100 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex 5 -ServerAddresses "192.168.1.100"
Install-WindowsFeature –Name AD-Domain-Services –IncludeManagementTools
Rename-Computer -NewName winsvradds001 -LocalCredential WS\Administrator -PassThru

shutdown -r -t 1

Get-WindowsFeature

# Install Script
Install-ADDSForest -DomainName "waynecorp.com" -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainNetbiosName "waynecorp" -ForestMode "7"  -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$True -SysvolPath "C:\Windows\SYSVOL" -Force:$true

shutdown -r -t 1

# Create DNS Reverse Lookup Zone
Add-DnsServerPrimaryZone -NetworkID "192.168.1.0/24" -ReplicationScope "Domain"

shutdown -r -t 1



# Create DNS alias
Add-DnsServerResourceRecordCName -Name "pki" -HostNameAlias "winsvriis001.waynecorp.com" -ZoneName "waynecorp.com"

# Prior to installing Online Responder in AD
# CERTSVC_DCOM_ACCESS: Domain Users, Domain Controllers, Domain Computers



# After PKI deployed
cd\
certutil  -config "Wayne Corp Issuing CA" -cacertfile "winsvradcs001.waynecorp.com_WayneCorp Issuing CA.crt"
