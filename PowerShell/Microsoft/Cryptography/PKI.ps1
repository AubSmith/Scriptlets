# Get LM installed certs
$certs = Get-ChildItem Cert:\LocalMachine\My | ft -AutoSize
$certs

# Find cert based on Thumbprint
Get-ChildItem -Path $thumbprint -Recurse

# Find certs expiring in 30 days
Get-ChildItem -ExpiringInDays 30 -Recurse

#
$thumbprint
$certs = Get-ChildItem -Path Cert:\LocalMachine\My\$thumbprint

Invoke-WebRequest -Uri $url -Proxy $proxy -ProxyUseDefaultCredentials -Certificate $certs
