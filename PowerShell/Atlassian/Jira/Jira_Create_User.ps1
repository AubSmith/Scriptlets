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
$User = Import-Csv $ContentPath

$User | ForEach-Object -parallel {

$Email = $($User.Email)
$Fullname = $($User.Fullname)
$Username = $($User.Username)

$Data = @"
{   
    \"name\":\"$Username\",
    \"emailAddress\": \"$Email\",
    \"displayName\": \"$Fullname\",
        \"notification\": \"true\"
    ]
}
"@

Write-Output $Data

D:\Downloads\curl\bin\curl.exe --insecure -D- -u $UserID -X POST --data $Data -H "Content-Type: application/json" https://$url/rest/api/2/user

Write-Output $Url
Write-Output $User

 }