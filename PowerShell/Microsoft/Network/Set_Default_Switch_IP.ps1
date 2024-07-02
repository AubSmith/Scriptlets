Get-NetIPAddress -InterfaceIndex (Get-NetAdapter -Name 'vEthernet (Default Switch)').ifIndex | Remove-NetIPAddress -confirm:$false

New-NetIPAddress -InterfaceAlias 'vEthernet (Default Switch)' -IPAddress '192.168.3.1' -PrefixLength 24

Set-DnsClientServerAddress -InterfaceAlias 'vEthernet (Default Switch)' -ServerAddresses ("192.168.3.80","192.168.3.1")
