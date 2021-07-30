# Create SQL Server service dsa
Import-Module ActiveDirectory
New-ADUser sqlsvcT1 -AccountPassword (Read-Host -AsSecureString "Enter Password") -PasswordNeverExpires $true -Enabled $true

# Set the SPN
setspn -A MSSQLSvc/RHELSVRSQL001:1433 sqlsvcT1
setspn -A MSSQLSvc/RHELSVRSQL001:1433 sqlsvcT1