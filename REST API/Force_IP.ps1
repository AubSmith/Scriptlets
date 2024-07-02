# Set desired SSL/TLS protocol versions
$Protocols = [System.Net.SecurityProtocolType]'Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $Protocols

# OR
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Make the REST API call
Invoke-RestMethod -Uri 'https://192.168.65.2' -Headers @{ 'Host' = 'api.wayneent.com' }
