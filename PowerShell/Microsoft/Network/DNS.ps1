Get-Module DNSServer –ListAvailable

Get-DnsServerResourceRecord -ComputerName dc -ZoneName mylab.local

Get-DnsServerResourceRecord -ComputerName dc -ZoneName mylab.local -RRType A

$new = $old = Get-DnsServerResourceRecord -ComputerName dc -ZoneName mylab.local -Name MYSQL

$new.RecordData.IPv4Address = [System.Net.IPAddress]::parse('192.168.0.254')

Set-DnsServerResourceRecord -NewInputObject $new -OldInputObject $old -ZoneName mylab.local -ComputerName dc

Get-DnsServerResourceRecord -ComputerName dc -ZoneName mylab.local -Name MYSQL | Remove-DNSServerResourceRecord –ZoneName mylab.local –ComputerName DC

Get-Command -Module DNSServer -Name *record*