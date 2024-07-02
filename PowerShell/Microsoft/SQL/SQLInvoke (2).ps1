$server = "DESKTOP-EM8HVC2"
$db = "AdventureWorksDW2022"
$query_file = "F:\Code\SQL\MultiSelect.sql"


$Tables = Invoke-Sqlcmd -ServerInstance $server -Database $db -InputFile $query_file -As DataTables

$Tables[0].Rows | Export-Csv -NoTypeInformation -Path "F:\Code\results1.csv" -Encoding UTF8
$Tables[2].Rows | Export-Csv -NoTypeInformation -Path "F:\Code\results2.csv" -Encoding UTF8

