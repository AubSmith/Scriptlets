<#
Checkpoints are a good technique for saving the current state of your workflow so that you can restart it if the machine or session is terminated. You can only restart from the last checkpoint taken—you can’t choose which checkpoint to use. Checkpoint data is saved in your user profile on the system you are using to run the workflow.

* Checkpoint-Workflow – Can be used after any activity, but not inside an InlineScript block. It takes an immediate checkpoint.
* PSPersist workflow parameter – Adds checkpoints at the beginning and at end of the workflow and after each activity. Does not modify any explicit checkpoints in the workflow.
* PSPersist activity parameter – Takes a checkpoint after the activity completes. This is not valid on expressions or commands in an InlineScript block.
* $PSPersistPreference preference variable – When set to true, takes a checkpoint after every following activity until it’s reset to false. Only effective within workflows.

#>

# Suspend
workflow test-wfsuspension {
    Start-Sleep -seconds 10
    Suspend-Workflow
    Get-ChildItem
   }

# Resume - Note Job ID 7 provided by job engine
# Resume-Job -Id 7
# Get-Job

# Resume from new PowerShell session
# Import-Module PSWorkflow
# Get-Job
# Resume-Job -Id 7

# OR

workflow test-wfsr {
    Start-Sleep -seconds 30
    Checkpoint-Workflow # Suspending job will result in workflow running up to checkpoint before suspending
    Get-ChildItem 
   }

# test-wfsr -AsJob
# Suspend-Job -Id 11 # Suspend-Job only works on workflows
# Resume-Job -id 11

# Checkpoint 1
workflow test-wfchkpnt {
    Get-WmiObject -Class Win32_ComputerSystem
    Checkpoint-Workflow
    Get-WmiObject -Class Win32_OperatingSystem
    Checkpoint-Workflow
    Get-WmiObject -Class Win32_LogicalDisk
    Checkpoint-Workflow   
    }

# OR

# Checkpoint 2 = Checkpoint 1
# test-wfchkpnt -PSPersist
workflow test-wfchkpnt {
    Get-WmiObject -Class Win32_ComputerSystem
    Get-WmiObject -Class Win32_OperatingSystem
    Get-WmiObject -Class Win32_LogicalDisk   
    }

# OR

# Checkpoint 3
workflow test-wfchkpnt {
    Get-WmiObject -Class Win32_ComputerSystem -PSPersist
    Get-WmiObject -Class Win32_OperatingSystem -PSPersist
    Get-WmiObject -Class Win32_LogicalDisk -PSPersist
    }

# OR

# Checkpoint 4 = Checkpoint 3
workflow test-wfchkpnt {
    $pspersistpreference = $true
    Get-WmiObject -Class Win32_ComputerSystem
    Get-WmiObject -Class Win32_OperatingSystem
    Get-WmiObject -Class Win32_LogicalDisk
    $pspersistpreference = $false
    }

# OR
# Checkpoint 5 - checkpoint after each loop
# test-wfchkpnt -AsJob # Must start as job
workflow test-wfchkpnt {
    $i = 0
    while ($true){
      $i++
      $i
      Checkpoint-Workflow
    } 
   } 
