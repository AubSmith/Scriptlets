CLS
Get-Process | Sort -Property VM -Descending
Get-Service | Sort Status 
Get-Service | Sort Status | Group -Property Status
Get-VM | Sort ComputerName
Get-NetAdapter | ? {$_.Name -eq "Ethernet"} | Enable-NetAdapter
Get-EventLog -Log Application -EntryType Error -New 5 | Sort Message | Group Message
Get-EventLog -Log Application | Sort EntryType | Group EntryType -NoElement | Sort Count -Descending
Get-Process | ? VirtualMemorySize -gt 1024MB
Get-Process | GM
Get-Process | ? {$_.StartTime.minute -GT 10} | Select Name, StartTime | ogv
Get-WindowsDriver -Online | ? Date -GT 01/01/2016 | Sort Date
Get-HotFix | Where installedon -gt 1/1/2017 | sort installedon |ogv
# {} marks a script block
