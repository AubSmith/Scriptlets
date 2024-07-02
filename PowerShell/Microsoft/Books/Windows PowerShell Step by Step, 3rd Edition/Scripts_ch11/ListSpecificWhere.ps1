
 
$Query = "Select * from win32_Share where name = 'ipc$'"
 Get-CimInstance -query $Query  |
 Format-List *
