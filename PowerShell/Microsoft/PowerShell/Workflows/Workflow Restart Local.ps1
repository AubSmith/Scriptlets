# https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj574130(v=ws.11)?redirectedfrom=MSDN#automate-resuming-the-workflow
# Manual

<#
PS C:scripts> $env:COMPUTERNAME

TEST1NOJOBPARAM

PS C:scripts> rename-localsystem -newname W12SUS
PS C:scripts> Import-Module PSWorkflow

PS C:scripts> Get-Job | Format-Table -AutoSize

Id Name PSJobTypeName State     HasMoreData Location  Command          

— —- ————- —–     ———– ——–  ——-          

3  Job2 PSWorkflowJob Suspended True
PS C:scripts> localhost rename-localsystem Resume
PS C:scripts> ls
PS C:scripts> $env:COMPUTERNAME

W12SUS
#>
workflow rename-localsystem {

    param (
     [string]$newname
    )
    Rename-Computer -Newname $newname -Force -Passthru  
    Restart-Computer -Wait
    Get-CimInstance -ClassName Win32_ComputerSystem |
    Select-Object -ExpandProperty Name |
    Set-Content -Path “C:Scripts$newname.txt”    
    }


# Automatic
# Register-ScheduledTask -TaskName Test -Action $act -Trigger $trig -RunLevel Highest
workflow test-restart {
    Get-WmiObject -Class Win32_ComputerSystem | Out-File -FilePath C:Reportscomp.txt
    Get-ChildItem -Path C:Reports | Out-File -FilePath C:dir.txt
    Restart-Computer -Wait
    Get-WmiObject -Class Win32_OperatingSystem | Out-File -FilePath C:Reportsos.txt
   }

$actionscript = ‘-NonInteractive -WindowStyle Normal -NoLogo -NoProfile -NoExit -Command “&”c:reportstest-resume.ps1””‘

$pstart =  “C:WindowsSystem32WindowsPowerShellv1.0powershell.exe”
   
Get-ScheduledTask -TaskName Test | Unregister-ScheduledTask -Confirm:$false
   
$act = New-ScheduledTaskAction -Execute $pstart -Argument $actionscript
   
$trig = New-ScheduledTaskTrigger -AtLogOn # OR –AtStartUp



Get-ChildItem -Path C:Reports | Out-File -FilePath C:Reportsdir.txt

Import-Module PSWorkflow

Get-Job | Resume-Job

Get-ScheduledTask -TaskName Test | Unregister-ScheduledTask -Confirm:$false
