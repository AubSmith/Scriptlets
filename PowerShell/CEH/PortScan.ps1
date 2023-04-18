$ports = 22,53,80,445

$ports | ForEach-Object {$port = $_; 
    if (Test-NetConnection -ComputerName 8.8.8.8 -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue) 
    {"Port $port is open" } else {"Port $port is closed"} }