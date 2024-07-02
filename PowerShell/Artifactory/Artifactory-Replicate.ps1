<#
.Synopsis
  This script is to 

.Description
  The 

.INPUTS
  See function-level notes.

.OUTPUTS
  A log is written to the directory from where the tool is invoked.

.NOTES
  Author: Aubrey Smith (aubrey.smith@anz.com)
  Date  : 2020/07/30
  Vers  : 1.0

.PARAMETER env
  The environment in which to 

.PARAMETER repo
  The name of the repo.

.LINK
	https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API

.EXAMPLE
	.\ArtifactoryAutoTest "oat" "maven-aubs-local"

#>

[CmdletBinding()]
Param(
  [parameter(mandatory=$true,Position=1)]
  [string]$env,
  
  [parameter(mandatory=$true,Position=2)]
  [string]$key
)



Start-Transcript


## Logging ##

$VerbosePreference = "Continue"

# Log file path is the same directory the script is run from

$LogPath = Split-Path $MyInvocation.MyCommand.Path

# Remove logs older than 14 days

Get-ChildItem "$LogPath\*.log" | Where-Object LastWriteTime -LT (Get-Date).AddDays(-365) | Remove-Item -Confirm:$false

# Create log file with todays date

$LogPathName = Join-Path -Path $LogPath -ChildPath "$($MyInvocation.MyCommand.Name)-$(Get-Date -Format 'MM-dd-yyyy').log"

# Start logging - append to if log already exists

Start-Transcript $LogPathName -Append



# Force TLS1.2

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12



# Authenticate before using the API

# $auth = Get-Credential -Message "Enter Credentials for Artifactory"

# Setting up credentials
 
$credPath = "D:\Restricted"
$keyFile = "$credPath\aes.key"
$key = Get-Content $keyFile
$tokenFile = "$credPath\password.txt"

$token = Get-Content $tokenFile | ConvertTo-SecureString -Key (Get-Content $keyFile)



# Retrieve the environment settings from a config file.

$xml = [XML](Get-Content .\Config.xml)
$url = $xml.settings.$env.url



# Convert the replication values to JSON

$jsonrepo = @{
    url = ""
    username = ""
    password = ""
} | ConvertTo-Json -Compress -Depth 10


<#
$headers = @{}
$headers.Add("x-jfrog-art-api", "$token")
$response = Invoke-RestMethod -Uri "https://$url/api/replication/execute/$repo" -Method Post -Headers $headers
#>


Invoke-RestMethod -Uri "https://$url/api/replication/execute/$repo" -Method Post -Credential $auth  -Headers @{ Authorization = "Basic" } -ContentType 'Application/json' -Body $jsonrepo -ErrorVariable RestErrorRep


if ($RestErrorRep)
{
    $HttpStatusCodeRep = $RestErrorRep.ErrorRecord.Exception.Response.StatusCode.value__
    $HttpStatusDescRep = $RestErrorRep.ErrorRecord.Exception.Response.StatusDescription
}

$HttpStatusCodeRep
$HttpStatusDescRep


Stop-Transcript