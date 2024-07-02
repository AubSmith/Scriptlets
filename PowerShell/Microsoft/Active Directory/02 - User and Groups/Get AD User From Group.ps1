$AD_Group = "My AD Group"

Get-ADGroupMember -Identity $AD_Group -Recursive | Get-ADUser -Property Name, DisplayName, EmployeeID, sAMAccountName | Select-Object Name, DisplayName, EmployeeID, sAMAccountName | Export-Csv -Path D:\Extract.csv -NoTypeInformation -Encoding "UTF8"
