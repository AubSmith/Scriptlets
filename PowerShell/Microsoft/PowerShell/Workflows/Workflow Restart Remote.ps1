workflow test-restart {
 param ([string[]]$computernames)
 foreach -parallel ($computer in $computernames) {
   Get-WmiObject -Class Win32_ComputerSystem -PSComputerName $computer
   Get-WmiObject -Class Win32_OperatingSystem -PSComputerName $computer
 }
}


<#
Running this in PowerShell ISE or PowerShell console will show a progress bar with messages informing the stages of the restart. 

These include:
* Waiting for restart to begin
* Verifying computer has restarted
* Waiting for WMI connectivity
* Waiting for Windows PowerShell connectivity
* Waiting for WinRM connectivity
#>

# test-restart -computernames w12standard, webr201 -AsJob
workflow test-restart {
 param ([string[]]$computernames)
 foreach -parallel ($computer in $computernames) {
   Get-WmiObject -Class Win32_ComputerSystem -PSComputerName $computer
   Restart-Computer -Wait -PSComputerName $computer
   Get-WmiObject -Class Win32_OperatingSystem -PSComputerName $computer
 }
}
