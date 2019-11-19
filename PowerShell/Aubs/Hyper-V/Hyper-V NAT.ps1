New-VMSwitch –SwitchName “Smith NAT” –SwitchType Internal

New-NetIPAddress –IPAddress 192.168.3.1 -PrefixLength 24 -InterfaceIndex 45

New-NetNat –Name MyNATNetwork –InternalIPInterfaceAddressPrefix 192.168.3.0/24