$Query = "Select Name from Win32_Share where name = 'C$'" 
Get-CimInstance -query $Query |
Sort-Object name |
Select-Object name