$Query = "Select * from Win32_Product"
Write-Host "Counting Installed Products. This" `
   "may take a little while. " -foregroundColor blue `n
Get-CimInstance -Query $Queryt