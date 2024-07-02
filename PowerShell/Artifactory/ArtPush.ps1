<#
.Synopsis
  .

.Description
  .

.INPUTS
  See function-level notes.

.OUTPUTS
  .

.NOTES

  Author: Aubrey Smith (aubrey.smith@anz.com)
  Date  : 2018/10/30
  Vers  : 1

  Updates:
  1.0   Original Script

.PARAMETER 
  .

.PARAMETER 
  .

.PARAMETER 
  .

.PARAMETER 
  .

.LINK
	https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API

.EXAMPLE
	

#>

$URI = "https://url/artifactory/example-repo-local/ArtifactoryPowerShellv4.zip"
$Source = ".\ArtifactoryPowerShellv4.zip"

$Auth = Get-Credential -Message "Enter Credentials for Artifactory"

#                              Basic user:pass
$headers = @{ Authorization = "Basic" }  

Invoke-RestMethod -Uri $URI -InFile $source -Method Put -Credential $Auth -Headers $headers