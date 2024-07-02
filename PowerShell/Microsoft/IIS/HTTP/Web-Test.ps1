# Test Certificate authentication
$cert = Get-ChildItem -Path Cert:\LocalMachine\My\A4AF32429792FC94BF0688E3217E5DB13194CFF0
Invoke-WebRequest -Uri https://api.services.wayneent.com/gateway/status -Proxy http://proxy.service.wayneent.com -ProxyUseDefaultCredentials -Certificate $cert

# Create HTTPS connection
$TestURL = [System.Net.WebRequest]::Create('https://api.services.wayneent.com/')

# Get response status code
$ResStatCode = [int]$TestURL.GetResponse().StatusCode
Write-Host $ResStatCode


<#####

CODE

#####>

$Server = "server1\myinstance"
$Db = "Mydatabase"
$QueryFile = ".\MySqlScript.sql"

try {
    $tables = Invoke-SqlCmd -ServerInstance $Server -Database $Db -InputFile $QueryFile -OutputAs DataTables
}
catch {
    Write-Host $Error
}

$tables[0].Rows | Out-File -FilePath "D:\Results\outfile(Get-Date -f ddMMyy).txt" -Encoding UTF8
$tables[1].Rows | Export-Csv -NoTypeInformation -Path "D:\Results\outfile(Get-Date -f ddMMyy)2.csv" -Encoding UTF8

(Get-Content "D:\Results\outfile(Get-Date -f ddMMyy).txt" | Select-Object -Skip 3) | Set-Content -Path "D:\Results\outfile(Get-Date -f ddMMyy)1.csv"
