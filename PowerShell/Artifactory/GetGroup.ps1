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

$uri = "https://artifactory.smith/artifactory/api/security/groups/artifactory%20generic-lft-local%20manage"

$auth = Get-Credential -Message "Enter Credentials for Artifactory"

#                              Basic user:pass
$headers = @{ Authorization = "Basic" }

Invoke-RestMethod -Uri $URI -Method Get -Credential $Auth -Headers $headers