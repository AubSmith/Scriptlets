$User = "%username%"

# Use samAccountName=$($env:username) for current user

(New-Object System.DirectoryServices.DirectorySearcher("(&(objectCategory=User)(samAccountName=$User))")).FindOne().GetDirectoryEntry().memberOf | Out-File C:\Logs\Groups.txt
