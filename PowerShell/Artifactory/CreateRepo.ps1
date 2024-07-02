<#
.Synopsis
  This tool is to automate, as far as possible, the process to create and configure repositories in Artifactory. The tool can be utilised either via a GUI, or by using the PowerShell command line.

.Description
  The tool has been paramterised to allow interaction either by way of the GIU, or by using the PowerShell shell. The tool currently servers four purposes;
    1) Creates the new repository in Artifactory
    2) Creates the relevant security group in Active Directory
    3) Configures the group in Artifactory
    4) Configures permissions on the repo in Artifactory using the newly created security group

.INPUTS
  See function-level notes.

.OUTPUTS
  A log is written to the directory from where the tool is invoked.

.NOTES

  Author: Aubrey Smith (aubrey.smith@anz.com)
  Date  : 2018/10/30
  Vers  : 1

  Updates:
  1.0   Original Script

.PARAMETER env
  The environment in which to create the repo; either prod, oat or test.

.PARAMETER key
  The name of the repo or project; e.g. bwb, gomoney or jenkins.

.PARAMETER description
  A description of the repo. This gives detail as to what the repo is used for.

.PARAMETER packageType
  This would be the type of the repo; e.g. generic, npm, nuget etc.

.LINK
	https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API

.EXAMPLE
	.\CreateRepo.ps1 "oat" "Aubs" "Aubs repo test" "maven"

#>


[CmdletBinding()]
Param(
  [parameter(mandatory=$true,Position=1)]
  [string]$env,
  
  [parameter(mandatory=$true,Position=2)]
  [string]$key,
  
  [parameter(mandatory=$true,Position=3)]
  [string]$description,

  [parameter(mandatory=$true,Position=4)]
  [string]$packageType
)



Start-Transcript


## Logging ##

$VerbosePreference = "Continue"

# Log file path is the same directory the script is run from

$LogPath = Split-Path $MyInvocation.MyCommand.Path

# Remove logs older than 14 days

Get-ChildItem "$LogPath\*.log" | Where-Object LastWriteTime -LT (Get-Date).AddDays(-14) | Remove-Item -Confirm:$false

# Create log file with todays date

$LogPathName = Join-Path -Path $LogPath -ChildPath "$($MyInvocation.MyCommand.Name)-$(Get-Date -Format 'MM-dd-yyyy').log"

# Start logging - append to if log already exists

Start-Transcript $LogPathName -Append



# Authenticate before using the API

$auth = Get-Credential -Message "Enter Credentials for Artifactory"



# Retrieve the environment settings from a config file.

$xml = [XML](Get-Content .\Config.xml)
$url = $xml.settings.$env.url
$ou = $xml.settings.$env.ou



# Verify that the requested repo packageType is valid

$validPackageType = $xml.settings.repo.packageType

If ($validPackageType -CONTAINS "$packageType") {"This is a valid package type"}
   Else {THROW "Invalid package type"}



# Set the repo name

[string]$grpName = -Join("$packageType","-","$key","-local")



# Convert the repository values to JSON

$jsonrepo = @{
  key = $grpName
  rclass = "local"
  description = $description
  packageType = "$packageType"
} | ConvertTo-Json -Compress -Depth 10



Invoke-RestMethod -Uri "https://$url/api/repositories/$grpName" -Method Put -Credential $Auth -Headers @{ Authorization = "Basic" } -ContentType 'Application/json' -Body $jsonrepo -ErrorVariable RestErrorRep


if ($RestErrorRep)
{
    $HttpStatusCodeRep = $RestErrorRep.ErrorRecord.Exception.Response.StatusCode.value__
    $HttpStatusDescRep = $RestErrorRep.ErrorRecord.Exception.Response.StatusDescription
}

$HttpStatusCodeRep
$HttpStatusDescRep



# Create the new security group in AD

Import-Module ActiveDirectory

IF($env -eq "test"){$ADgrpName = "Artifactory $grpName"}
    ELSE {$ADgrpName = "Artifactory $grpName"}

New-ADGroup -Name "$ADgrpName" -SamAccountName "$ADgrpName" -GroupCategory Security -GroupScope Global -Path "$ou" -Description "Artifactory $grpName security group"



# Convert the security group values to JSON

$jsongrp = @{
  name = "$grpName"
  description = "Artifactory $grpName security group"
  realm = "ldap"
  realmAttributes = "ldapGroupName=$ADgrpName;groupsStrategy=STATIC;groupDn=cn=$ADgrpName,$ou"
} | ConvertTo-Json -Compress -Depth 10


Invoke-RestMethod -Uri "https://$url/api/security/groups/$grpName" -Method Put -Credential $Auth -Headers @{ Authorization = "Basic" } -ContentType 'Application/json' -Body $jsongrp -ErrorVariable RestErrorGrp


if ($RestErrorGrp)
{
    $HttpStatusCodeGrp = $RestErrorGrp.ErrorRecord.Exception.Response.StatusCode.value__
    $HttpStatusDescGrp = $RestErrorGrp.ErrorRecord.Exception.Response.StatusDescription
}

$HttpStatusCodeGrp
$HttpStatusDescGrp



# Convert the permissions settings to JSON

$jsonprm = @{
  name = "$grpName"
  repositories = @("$grpName")
  principals = @{
    groups = @{"$grpName" = "n","r"}}
  } | ConvertTo-Json -Compress -Depth 10


Invoke-RestMethod -Uri "https://$url/api/security/permissions/$grpName" -Method Put -Credential $Auth -Headers @{ Authorization = "Basic" } -ContentType 'Application/json' -Body $jsonprm -ErrorVariable RestErrorPrm


if ($RestErrorPrm)
{
    $HttpStatusCodePrm = $RestErrorPrm.ErrorRecord.Exception.Response.StatusCode.value__
    $HttpStatusDescPrm = $RestErrorPrm.ErrorRecord.Exception.Response.StatusDescription
}

$HttpStatusCodePrm
$HttpStatusDescPrm

Stop-Transcript