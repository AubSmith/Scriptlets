$Query = "Select Name, Path, AllowMaximum from Win32_Share" 
Get-CimInstance -query $Query |
Sort-Object name |
Select-Object name, Path, AllowMaximum