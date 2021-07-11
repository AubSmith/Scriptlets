# Sconfig - Mange server

Get-NetIPAddress
New-NetIPAddress -InterfaceIndex 5 -IPAddress 192.168.1.100 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceIndex 5 -ServerAddresses ("192.168.1.100","8.8.8.8")
Install-WindowsFeature –Name AD-Domain-Services –IncludeManagementTools
Rename-Computer -NewName winsvradds001 -LocalCredential WS\Administrator -PassThru

shutdown -r -t 1

Get-WindowsFeature

# Install Script
Install-ADDSForest -DomainName "waynecorp.com" -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainNetbiosName "waynecorp" -ForestMode "7"  -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$True -SysvolPath "C:\Windows\SYSVOL" -Force:$true

#####endregion

shutdown -r -t 1
