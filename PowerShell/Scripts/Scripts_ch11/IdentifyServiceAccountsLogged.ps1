$Query = "Select startName, name from win32_service"
$File = "c:\MyOutPut\ServiceAccounts.txt"
New-Variable -name ASCII -value "ASCII" -option constant
Get-CimInstance –Query $Query |
Sort-Object startName, name |
Format-List name, startName |
Out-File -filepath $File -encoding $ASCII -append -noClobber