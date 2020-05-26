[CmdletBinding()]
Param(
  [parameter(mandatory=$true,Position=1)]
  [string]$envmt
)



$Xml = [XML](Get-Content .\Config.xml)
$Url = $xml.settings.$envmt.url
$ContentPath = $Xml.settings.$envmt.file 
$Csv = Import-Csv $ContentPath 
$Usergrp = $Csv | ForEach-Object {
  $Group = $_.group
  $UserName = $_.username

$Group
$UserName

}

ForEach($User in $UserGrp) {      

  $Body = @{
    name = "$UserName"
    } | ConvertTo-Json -Compress

    D:\Software\curl\bin\curl.exe --insecure -D- -u user:pass -X POST --data $Data -H "Content-Type: application/json" http://$url/rest/api/2/group/user?groupname=$Group

}