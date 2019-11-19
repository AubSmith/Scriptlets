$wshnetwork = New-Object -ComObject "wscript.network"
$colPrinters = $wshnetwork.EnumPrinterConnections()
$coldrives = $wshnetwork.EnumNetworkDrives()
$username = $wshnetwork.username
$userdomain = $wshnetwork.userdomain
$computername = $wshnetwork.computername

$wshShell = New-Object -ComObject "wscript.shell"
$wshShell.Popup($userdomain+"\$username + $computername")
$wshShell.Popup($colprinters) | Format-Table
$wshShell.Popup($coldrives)