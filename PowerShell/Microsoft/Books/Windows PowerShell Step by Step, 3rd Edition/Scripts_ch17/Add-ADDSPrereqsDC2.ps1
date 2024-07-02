#set static IP address
$ipaddress = "192.168.0.226"
$ipprefix = "24"
$ipgw = "192.168.0.1"
$ipdns = "192.168.0.225"
$ipif = (Get-NetAdapter).ifIndex
New-NetIPAddress -IPAddress $ipaddress -PrefixLength $ipprefix -InterfaceIndex $ipif -DefaultGateway $ipgw
Set-DnsClientServerAddress -InterfaceIndex $ipif -ServerAddresses $ipdns

#rename the computer
$newname = "dc28508"
Rename-Computer -NewName $newname -force

#install roles and features
$featureLogPath = "c:\poshlog\featurelog.txt"
New-Item $featureLogPath -ItemType file -Force

Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools
Get-WindowsFeature | Where installed >>$featureLogPath

#restart the computer
Restart-Computer