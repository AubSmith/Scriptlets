# Find files modified after date

$Source = "D:\"
$DateMod = ""

Get-ChildItem $Source -Recurse | ? {$_.mode -notmatch "d"} | ? {$_.LastWriteTime -gt [datetime]::Parse("$DateMod")} | FT LastWriteTime, Fullname -AutoSize | Out-File NewFile.log -Append