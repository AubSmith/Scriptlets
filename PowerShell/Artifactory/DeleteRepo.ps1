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

[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$title = 'Artifactory Repo Name'
$msg = 'Please enter the name of the Artifactory repo to delete'
$key = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)



$uri = "https://artifactory.smith/artifactory/api/repositories/$key"

$auth = Get-Credential -Message "Enter Credentials for Artifactory"

#                              Basic user:pass
$headers = @{ Authorization = "Basic" }  

Invoke-RestMethod -Uri $URI -Method Delete -Credential $Auth -Headers $headers

