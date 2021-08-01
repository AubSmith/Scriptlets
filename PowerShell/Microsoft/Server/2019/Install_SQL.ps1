# Create SQL Server service dsa
Import-Module ActiveDirectory
New-ADUser sqlsvcT1 -AccountPassword (Read-Host -AsSecureString "Enter Password") -PasswordNeverExpires $true -Enabled $true

# Set the SPN
setspn -A MSSQLSvc/RHELSVRSQL001.WayneCorp.com:1433 sqlsvcT1

# Create Keytab file
ktpass /princ MSSQLSvc/RHELSVRSQL001.WayneCorp.com:1433@WAYNECORP.COM /ptype KRB5_NT_PRINCIPAL /crypto aes256-sha1 /mapuser WayneCorp\sqlsvcT1 /out mssql.keytab -setpass -setupn /kvno 2 /pass <D3lt@F0rc3>

ktpass /princ MSSQLSvc/RHELSVRSQL001:1433@WAYNECORP.COM /ptype KRB5_NT_PRINCIPAL /crypto aes256-sha1 /mapuser WayneCorp\sqlsvcT1 /in mssql.keytab /out mssql.keytab -setpass -setupn /kvno 2 /pass <D3lt@F0rc3>

ktpass /princ sqlsvct1@WAYNECORP.COM /ptype KRB5_NT_PRINCIPAL /crypto aes256-sha1 /mapuser WayneCorp\sqlsvct1 /in mssql.keytab /out mssql.keytab -setpass -setupn /kvno 2 /pass <D3lt@F0rc3>
