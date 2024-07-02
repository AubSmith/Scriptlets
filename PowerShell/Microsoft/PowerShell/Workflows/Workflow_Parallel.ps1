# Parallel - order not guaranteed

# paralleltask
# Get-command paralletask | format-list *
workflow paralleltask {
    parallel {
      Get-CimInstance –ClassName Win32_OperatingSystem
      Get-Process –Name PowerShell*
      Get-CimInstance –ClassName Win32_ComputerSystem
      Get-Service –Name s*
     }
   }


# foreachptest  -Computers “server01”, “server02”, “server03”
workflow foreachptest {
    param([string[]]$computers)
    foreach –parallel ($computer in $computers){
     Get-WmiObject –Class Win32_OperatingSystem –PSComputerName $computer
    }
 }



# Sequence - order guaranteed

# foreachpstest  -Computers “server01”, “server02”, “server03”
workflow foreachpstest {
    param([string[]]$computers)
    foreach –parallel ($computer in $computers){
     sequence {
       Get-WmiObject -Class Win32_ComputerSystem -PSComputerName $computer
       Get-WmiObject –Class Win32_OperatingSystem –PSComputerName $computer
     }
    }
 }


# foreachpsptest  -Computers “server01”, “server02”, “server03” 
 workflow foreachpsptest {
    param([string[]]$computers)
    foreach –parallel ($computer in $computers){
     sequence {
       Get-WmiObject -Class Win32_ComputerSystem -PSComputerName $computer
       Get-WmiObject –Class Win32_OperatingSystem –PSComputerName $computer
       $disks = Get-WmiObject -Class Win32_LogicalDisk `
          -Filter “DriveType = 3” –PSComputerName $computer
      
       foreach -parallel ($disk in $disks){
         sequence {
           $vol = Get-WmiObject -Class Win32_Volume `
           -Filter “DriveLetter = ‘$($disk.DeviceID)'” `
           –PSComputerName $computer 
           Invoke-WmiMethod -Path $($vol.__PATH) -Name DefragAnalysis 
         }
       }
     }
    }
 }



# Piping and Inlinescript PowerShell script blocks

# foreachpitest -Computers “server01”, “server02”, “server03”
workflow foreachpitest {
    param([string[]]$computers)
    foreach –parallel ($computer in $computers){
      InlineScript {
        Get-WmiObject –Class Win32_OperatingSystem –ComputerName $using:computer |
        Format-List
      }
    }
 }
