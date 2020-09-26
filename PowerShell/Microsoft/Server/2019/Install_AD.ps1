# Sconfig - Mange server
Rename-Computer -NewName wayneenterprises -LocalCredential WS\Administrator -PassThru

ipconfig
Get-NetIPAddress
New-NetIPAddress -InterfaceIndex 6 -IPAddress 172.22.169.100 -PrefixLength 20 -DefaultGateway 172.22.169.1
Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses ("172.22.169.100","8.8.8.8")
Install-WindowsFeature –Name AD-Domain-Services –IncludeManagementTools

# Install Script
Install-ADDSForest
 
  -DomainName "wayneent.com" 
  -CreateDnsDelegation:$false 
  -DatabasePath "C:\Windows\NTDS" 
  -DomainMode "7" 
  -DomainNetbiosName "example" 
  -ForestMode "7"  
  -InstallDns:$true 
  -LogPath "C:\Windows\NTDS" 
  -NoRebootOnCompletion:$True
  -SysvolPath "C:\Windows\SYSVOL"
  -Force:$true

  #####endregion

  shutdown -r -t 1