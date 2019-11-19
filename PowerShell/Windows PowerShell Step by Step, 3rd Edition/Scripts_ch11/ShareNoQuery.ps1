$Filter = "name='c$'" 
Get-CimInstance –ClassName Win32_Share -filter $Filter | 
Format-List *
