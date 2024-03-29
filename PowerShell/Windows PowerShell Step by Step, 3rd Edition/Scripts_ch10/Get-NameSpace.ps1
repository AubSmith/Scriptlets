Function Get-WmiNameSpace
{
 Param(
  [string]$nameSpace,
  [string]$computer)
 Get-WmiObject -Class __NameSpace -ComputerName $computer `
 -namespace $namespace -ErrorAction "Continue" |
 Foreach-Object `
 -Process `
   { 
     $subns = Join-Path -Path $_.__namespace -ChildPath $_.name
     if($subns -notmatch 'directory') {$subns} 
     $namespaces += $subns + "`r`n"
     Get-WmiNameSpace -namespace $subNS -computer $computer
   } 
} #end Get-WmiNameSpace

Get-WmiNameSpace -nameSpace ROOT -computer $env:COMPUTERNAME