$dteStart = Get-Date
$Query = "Select * from Win32_Product"
Write-Host "Counting Installed Products. This" `
   "may take a little while. " -foregroundColor blue `n
Get-CimInstance -Query $Query
$dteEnd = Get-Date
$dteDiff = New-TimeSpan $dteStart $dteEnd
Write-Host "It took " $dteDiff.totalSeconds " Seconds" `
 " for this script to complete"