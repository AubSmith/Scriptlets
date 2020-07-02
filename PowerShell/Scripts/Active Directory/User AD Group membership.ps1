$User = "%username%"

(New-Object System.DirectoryServices.DirectorySearcher("(&(objectCategory=User)(samAccountName=$User))")).FindOne().GetDirectoryEntry().memberOf | Out-File C:\Logs\Groups.txt
