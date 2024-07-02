$Computer = 'Localhost'
$Path = C:\Users\$Env:UserName\Desktop\rsop.Xml

Get-GPResultantSetOfPolicy -Computer $Computer -ReportType Xml -Path $Path

[xml]$rsop = Get-Content -Path $Path

$rsop.Rsop.ComputerResults.ExtensionData[0].Extension.AuditSetting