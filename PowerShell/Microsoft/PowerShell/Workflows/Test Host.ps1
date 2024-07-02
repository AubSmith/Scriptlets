# get-computersystem -computerName $env:COMPUTERNAME

workflow get-computersystem {
    param([string[]]$computerName)
   
    function get-fcomputersystem {
    param ([string]$fcomputer)
    Get-WmiObject -Class Win32_ComputerSystem -ComputerName $fcomputer
   }
   
    
   # The contents of the foreach block will be executed in parallel     
     foreach -parallel($computer in $computerName) {
        if (Test-Connection -ComputerName $computer -Quiet -Count 1) {
            get-fcomputersystem -fcomputer $computer
        }

        else {   
          “$computer unreachable”
        }
     }
   }
