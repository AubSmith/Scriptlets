#CreateDC3Prereqs.ps1

#set static IP address
$ipaddress = "192.168.0.227"
$ipprefix = "24"
$ipgw = "192.168.0.1"
$ipdns = "192.168.0.225"
$ipif = (Get-NetAdapter).ifIndex
New-NetIPAddress -IPAddress $ipaddress -PrefixLength $ipprefix -InterfaceIndex $ipif -DefaultGateway $ipgw
Set-DnsClientServerAddress -InterfaceIndex $ipif -ServerAddresses $ipdns

#rename the computer
$newname = "dc38508"
Rename-Computer -NewName $newname -force

#install AD DS Role and tools
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools

#restart the computer
Restart-Computer