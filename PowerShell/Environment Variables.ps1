Get-ChildItem -Path Env:

$Env:Path
# OR
Write-Output $Env:PATH

$Env:PATH += ";C:\Program Files (x86)\GnuWin32\bin"