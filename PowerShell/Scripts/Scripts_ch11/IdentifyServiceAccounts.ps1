$Query = "Select startName, name from win32_service"
Get-CimInstance –Query $Query |
Sort-Object startName, name |
Format-List name, startName