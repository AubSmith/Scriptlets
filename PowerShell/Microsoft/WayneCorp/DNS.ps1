# Add DNS reverse lookup zone
Get-DnsServerZone

Add-DnsServerPrimaryZone -NetworkID "192.168.1.0/24" -ReplicationScope "Domain"

# Create DNS primary zone
Add-DnsServerPrimaryZone -Name "west01.contoso.com" -ReplicationScope "Forest" -PassThru

# Remove DNS zone
Get-DnsServerZone

Remove-DnsServerZone -Name "west01.contoso.com"

Get-DnsServerZone

# Create CNAME
Add-DnsServerResourceRecordCName -Name "pki" -HostNameAlias "winsvriis001.waynecorp.com" -ZoneName "waynecorp.com"