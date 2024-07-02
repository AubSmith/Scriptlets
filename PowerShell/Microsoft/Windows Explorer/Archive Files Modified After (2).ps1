$Source = "D:\Data\"
$TargetDir = "D:\Backup\"
$DateMod = "01-01-2018"
$Exclude = "Test"

# Get Source Files | Exclude Directories | Filter by Date

Get-ChildItem $Source -Recurse | Where-Object {$_.Fullname -Notmatch $Exclude} | Where-Object {$_.LastWriteTime -gt [datetime]::Parse("$DateMod")} |  

ForEach-Object {

    $TargetFile = $TargetDir + $_.FullName.SubString($Source.Length); 
    New-Item -ItemType Directory -Path $TargetDir -Force;  
    Copy-Item $_.FullName -destination $TargetFile -Container -Force
  }