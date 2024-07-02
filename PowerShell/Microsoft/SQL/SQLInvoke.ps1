$server = "DESKTOP-EM8HVC2"
$db = "AdventureWorksDW2022"
$query_file = "F:\Code\SQL\MultiSelect.sql"

try {
    $Tables = Invoke-Sqlcmd -ServerInstance $server -Database $db -InputFile $query_file -As DataTables
}
catch {
    Write-Error
    Exit 1
}


$Tables[0].Rows | Export-Csv -NoTypeInformation -Path "F:\Code\results.csv" -Encoding UTF8
$Tables[1].Rows | Out-File -FilePath "F:\Code\results.txt" -Encoding UTF8
$Tables[2].Rows | Export-Csv -NoTypeInformation -Path "F:\Code\results$(Get-Date -f ddMMyy).csv" -Encoding UTF8
$Tables[3].Rows | Out-File -FilePath "F:\Code\results$(Get-Date -f ddMMyy).txt" -Encoding UTF8


(Get-Content "F:\Code\results$(Get-Date -f ddMMyy).txt" | Select-Object -Skip 3) | Set-Content -Path "D:\Out$(Get-Date -f ddMMyy).csv"
Get-Content "F:\Code\results$(Get-Date -f ddMMyy).txt" | Select-Object -Skip 3) | Set-Content -Path ("{0}\Out$(Get-Date -f ddMMyy).csv" -F $json_config.outpath)
