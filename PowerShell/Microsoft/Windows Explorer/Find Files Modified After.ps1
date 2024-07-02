# Find files modified after date

$Source = "D:\"
$DateMod = ""

Get-ChildItem $Source -Recurse | Where-Object {$_.mode -notmatch "d"} | Where-Object {$_.LastWriteTime -gt [datetime]::Parse("$DateMod")} | Format-Table LastWriteTime, Fullname -AutoSize | Out-File NewFile.log -Append