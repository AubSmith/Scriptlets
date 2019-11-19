Set-Location cert:\

Get-ChildItem

Get-ChildItem -recurse

GCI -path currentUser

sl currentuser\authroot

gci | where {$_.subject -like "*c&w*"}

gci | where {$_.subject -like "*SGC Root*"}

gci | where {$_.thumbprint -eq "F88015D3F98479E1DA553D24FD42BA3F43886AEF"}

gci | where {$_.thumbprint -eq "F88015D3F98479E1DA553D24FD42BA3F43886AEF"} | Format-List *

Certmgr.msc

Invoke-Item cert:\



