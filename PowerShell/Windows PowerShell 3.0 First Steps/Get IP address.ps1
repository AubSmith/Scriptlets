$obj = Get-NetIPConfiguration
Write-Host ($obj | Select -ExpandProperty "IPv4Address")