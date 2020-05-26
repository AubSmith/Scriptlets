<#
.Synopsis
  This tool is to automate the cleanup, as far as possible, the testing of the Artifactory environment. The tool can be utilised via the PowerShell command line.

.Description
  The tool has been paramterised to allow interaction by using the PowerShell shell. The tool currently servers five purposes;
    1) Removes the test repository from Artifactory
    2) Removes the relevant security group from Active Directory
    3) Removes the group from Artifactory
    4) Removes permissions on the repo in Artifactory using the newly created security group
    5) Uninstalls the installed package

.INPUTS
  See function-level notes.

.OUTPUTS
  A log is written to the directory from where the tool is invoked.

.NOTES

  Author: Aubrey Smith (aubrey.smith@anz.com)
  Date  : 2018/11/26
  Vers  : 1.0

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
	.\Env-TestCleanup.ps1 "test" "Aubs" "nuget"

#>


[CmdletBinding()]
Param(
  [parameter(mandatory=$true,Position=1)]
  [string]$envmt,
  
  [parameter(mandatory=$true,Position=2)]
  [string]$key,

  [parameter(mandatory=$true,Position=3)]
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
$url = $xml.settings.$envmt.url
$ou = $xml.settings.$envmt.ou


# Set the repo name

[string]$grpName = -Join("$packageType","-","$key","-remote")


########## Remove the test repo from Artifactory ##########

Invoke-RestMethod -Uri "https://$url/api/repositories/$grpName" -Method DELETE -Credential $Auth -Headers @{ Authorization = "Basic" } -ErrorVariable RestErrorRep

if ($RestErrorRep)
{
    $HttpStatusCodeRep = $RestErrorRep.ErrorRecord.Exception.Response.StatusCode.value__
    $HttpStatusDescRep = $RestErrorRep.ErrorRecord.Exception.Response.StatusDescription
}

$HttpStatusCodeRep
$HttpStatusDescRep


########## Remove the security group from AD ##########

Import-Module ActiveDirectory

IF($envmt -eq "test"){$ADgrpName = "Artifactory $grpName"}
    ELSE {$ADgrpName = "Artifactory $grpName"}

Remove-ADGroup -Identity $ADgrpName -Confirm:$true


########## Remove the group from Artifactory ##########

Invoke-RestMethod -Uri "https://$url/api/security/groups/$grpName" -Method DELETE -Credential $Auth -Headers @{ Authorization = "Basic" } -ErrorVariable RestErrorGrp

if ($RestErrorGrp)
{
    $HttpStatusCodeGrp = $RestErrorGrp.ErrorRecord.Exception.Response.StatusCode.value__
    $HttpStatusDescGrp = $RestErrorGrp.ErrorRecord.Exception.Response.StatusDescription
}

$HttpStatusCodeGrp
$HttpStatusDescGrp


########## Remove permissions on the repo in Artifactory ##########

Invoke-RestMethod -Uri "https://$url/api/security/permissions/$grpName" -Method DELETE -Credential $Auth -Headers @{ Authorization = "Basic" } -ErrorVariable RestErrorPrm

if ($RestErrorPrm)
{
    $HttpStatusCodePrm = $RestErrorPrm.ErrorRecord.Exception.Response.StatusCode.value__
    $HttpStatusDescPrm = $RestErrorPrm.ErrorRecord.Exception.Response.StatusDescription
}

$HttpStatusCodePrm
$HttpStatusDescPrm


########## Uninstall the package ##########

try {
  Remove-Item -Path .\Microsoft.SqlServer.Scripting* -Recurse -ErrorVariable PkgUninstall;
}
catch {
  Write-Output $PkgUninstall;
}

Stop-Transcript