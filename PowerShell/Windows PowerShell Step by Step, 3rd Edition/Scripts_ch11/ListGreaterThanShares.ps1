$Query = "Select name from win32_Share where name > 'd'" 
 
Get-CimInstance -query $Query | 
Sort-Object -property name | 
Format-List -property name
