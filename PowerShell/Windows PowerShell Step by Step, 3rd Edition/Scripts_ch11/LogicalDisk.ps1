
$Disk=Get-CimInstance Win32_logicaldisk -filter 'drivetype = 3' | 
   Measure-Object -property freespace  -Minimum -Maximum | 
   Select-Object -Property property, maximum, minimum |
   Format-Table * -AutoSize

$Disk