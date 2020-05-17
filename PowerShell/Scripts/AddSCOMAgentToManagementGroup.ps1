######################################################################################

# Add-SCOMAgentToManagementGroup.ps1
# Author - Jure Labrovic
# http://jurelab.wordpress.com
# Created on: 5.10.2014
# Version 1.0.0

# Modified from Ross Worth script which was Inspired by Bob Cornelissen's VB Script.
######################################################################################

# This Script Adds SCOM Agent-s to Management Group. You can provide single or multiple servers.
# Sample: Add-mySCOMAgentToManagementGroup "Server01","Server02","Server03" -ManagementGroupName "Mgmt01" -ManagementServerName "MS01.contoso.com"
# Default port: 5723 is used
Param(
        [Parameter(Mandatory=$True,Position=1)][Array]$AgentName,
        [String]$ManagementGroupName,
        [String]$ManagementServerName
     )
    $ServerName=$env:COMPUTERNAME

    $AddToMG={      
        param($ManagementGroupName,$ManagementServerName)
        
        $NewObject = New-Object -ComObject AgentConfigManager.MgmtSvcCfg

        # Check if Agent is Already member of MG if not Add it
        [array]$ManagementGroups=$NewObject.GetManagementGroups() | Select-Object managementGroupName | % {$_.managementgroupname}
                
        if ($ManagementGroups -contains $ManagementGroupName){
            "Agent: " + $env:COMPUTERNAME + " is Already member of: " + $ManagementGroupName
        } else {
                $NewObject.AddManagementGroup("$ManagementGroupName", "$ManagementServerName",5723)
                "Adding: " +$env:COMPUTERNAME + " to " + $ManagementGroupName + " Management Group"
                Restart-Service HealthService
                }
    }
    foreach ($Agent in $AgentName) {      
            write-host "`n----------------------"
            $IsLocalServer=$Agent.StartsWith($ServerName,"CurrentCultureIgnoreCase")

            if ($IsLocalServer -eq $true){
                $AddToMG.Invoke($ManagementGroupName,$ManagementServerName)
            }else {
                    Invoke-Command -ComputerName $Agent -ScriptBlock $AddToMG -ArgumentList $ManagementGroupName,$ManagementServerName                    
                  }        
}