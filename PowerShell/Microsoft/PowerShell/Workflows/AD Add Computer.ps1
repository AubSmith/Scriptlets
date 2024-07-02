# add-localsystemtodomain -domcred $cred -ipv4address “10.10.54.170” -JobName AddToDomain
workflow add-localsystemtodomain{
    param (
     $domcred,
     [string]$ipv4address
    )
   $index = Get-NetIPInterface -AddressFamily IPv4 -Dhcp Enabled |
    Select-Object -ExpandProperty  ifIndex
   New-NetIPAddress -InterfaceIndex $index -AddressFamily IPv4 `
    -IPAddress $ipv4address -PrefixLength 24
    Set-DnsClientServerAddress -InterfaceIndex $index -ServerAddresses “10.10.54.201”
    Set-DnsClient -InterfaceIndex $index -ConnectionSpecificSuffix “manticore.org”
   Add-Computer -Credential $domcred -DomainName Manticore `
    -OUPath “OU=Security Servers,OU=Servers,DC=Manticore,DC=org” -Force
   Restart-Computer 
   }
   

## remove relicit jobs
Get-Job |
where PSJobTypeName -eq “PSWorkflowJob” |
Remove-Job
$cred = Get-Credential   
