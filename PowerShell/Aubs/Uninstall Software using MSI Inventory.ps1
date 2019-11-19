<# 

msiinv.exe = MS Inventory

Example

PS C:\Users\aubre\Downloads> .\msiinv.exe -s | Select-String "SQL Server" -Context 0,1

> SQL Server 2017 Database Engine Shared
        Product code:   {793F1C1E-5C83-4E33-A29B-6EAA7C1E791C}
> SQL Server 2017 Connection Info
        Product code:   {89A7644F-E056-4EC1-BFDE-9D1A531D6855}
> Microsoft SQL Server 2017 RsFx Driver
        Product code:   {7123D29F-9197-4686-A619-C7E8EA289718}


PS C:\Users\aubre\Downloads> msiexec /x "{7123D29F-9197-4686-A619-C7E8EA289718}"
PS C:\Users\aubre\Downloads> msiexec /x "{89A7644F-E056-4EC1-BFDE-9D1A531D6855}"
PS C:\Users\aubre\Downloads> msiexec /x "{793F1C1E-5C83-4E33-A29B-6EAA7C1E791C}"
PS C:\Users\aubre\Downloads> #>