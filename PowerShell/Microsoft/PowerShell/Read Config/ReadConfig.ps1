$SettingsObject = Get-Content -Path .\MyConfig.json | ConvertFrom-Json

$SettingsObject

$SettingsObject.link1

$SettingsObject.OutputFile

$MyPath = Join-Path \\server01\folder01 $SettingsObject.file

Write-Output $MyPath


$myFileName = '.\{0}-{1}.json' -f $host, $Env:COMPUTERNAME 
Out-File -filepath $myFileName

$EndDate = get-date -UFormat "%Y-%m-%d %H:%M:%S"
$myFileName = '.\{0}-{1}.json' -f $host, ($EndDate.ToString() -replace ':','')  -replace '\s','' 
Out-File -filepath $myFileName
