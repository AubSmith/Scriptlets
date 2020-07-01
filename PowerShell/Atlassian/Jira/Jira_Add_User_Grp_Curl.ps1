[CmdletBinding()]
Param(
  [parameter(mandatory=$true,Position=1)]
  [string]$envmt,

  [parameter(mandatory=$true,Position=2)]
  [string]$UserID
)

$Xml = [XML](Get-Content .\Config.xml)
$Url = $xml.settings.$envmt.url
$ContentPath = $Xml.settings.$envmt.file
$Groups = Import-Csv $ContentPath

$Groups | ForEach-Object -Parallel {

$Update = $_
$Groupname = $($Update.Group)
$Username = $($Update.Username)

$ApiUrl = https://$using:url/rest/api/2/group/user?groupname=$Groupname
[uri]::EscapeDataString($ApiUrl)

$Data = @"
{\"name\":\"$Username\"}
"@

Write-Output $Data

D:\Downloads\curl\bin\curl.exe --insecure -D- -u $using:UserID -X POST --data $Data -H "Content-Type: application/json" $ApiUrl

Write-Output $Groupname

} -ThrottleLimit 4