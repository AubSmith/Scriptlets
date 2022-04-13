Param(
   [string]$collectionurl = "http://server:8080/tfs",
   [string]$user = "username",
   [string]$token = "password",
   [string]$path = "D:\temp" # Export the agent list (*.csv file) to this path

)

$filename = (Get-Date).ToString("yyyyMMdd-HHmmss") + "-" + "AgentList.csv"

# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))

#Get pools 
$poolsUrl = "$collectionurl/_apis/distributedtask/pools"            
$poolresponse = Invoke-RestMethod -Uri $poolsUrl -Method Get -UseDefaultCredential -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
$pools = $poolresponse.value

foreach ($pool in $pools )
{
#Get agent list from pool
$baseUrl = "$collectionurl/_apis/distributedtask/pools/$($pool.id)/agents?includeCapabilities=true&includeAssignedRequest=true"         
$agentresponse = Invoke-RestMethod -Uri $baseUrl -Method Get -UseDefaultCredential -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
$agents = $agentresponse.value

$agentlist = @()

   foreach ($agent in $agents)
   {

    $customObject = new-object PSObject -property @{
          "PoolName" = $pool.name
          "Agent.Name" = $agent.systemCapabilities.'Agent.Name'
          "Agent.Version" = $agent.systemCapabilities.'Agent.Version'
          "Agent.ComputerName" = $agent.systemCapabilities.'Agent.ComputerName'
        } 

    $agentlist += $customObject
   }

   $agentlist | Select-Object `
                PoolName,
                Agent.Name,
                Agent.Version, 
                Agent.ComputerName |export-csv -Path $path\$filename -NoTypeInformation -Append

}