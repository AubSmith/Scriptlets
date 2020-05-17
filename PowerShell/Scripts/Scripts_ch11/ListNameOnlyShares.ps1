$Query = "Select Name from Win32_Share" 
Get-CimInstance -query $Query |
Sort-Object name |
Select-Object name