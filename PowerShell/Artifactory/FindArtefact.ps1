<#
.Synopsis
  This tool is for testing Artifactory artefact discovery. The tool can be utilised via the PowerShell command line.

.Description
  The tool has been paramterised to allow interaction by using the PowerShell shell. The tool currently serves the following purpose;
    1) Lists, downloads, and installs a package from the remote repo

.INPUTS
  See function-level notes.

.OUTPUTS
  A log is written to the directory from where the tool is invoked.

.NOTES

  Author: Aubrey Smith (aubrey.smith@anz.com)
  Date  : 2019/02/13
  Vers  : 1.0

  Updates:
  1.0   Original Script
  
.PARAMETER env
  The environment in which to create the repo; either prod, oat or test.

.PARAMETER key
  The name of the repo or project; e.g. bwb, gomoney or jenkins.

.PARAMETER packageType
  This would be the type of the repo; e.g. generic, npm, nuget etc.

.LINK
	https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API

.EXAMPLE
	.\Remote-Test.ps1 "test" "Aubs" "nuget"

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



# Verify that the requested repo packageType is valid

$validPackageType = $xml.settings.repo.packageType

If ($validPackageType -CONTAINS "$packageType") {"This is a valid package type"}
   Else {THROW "Invalid package type"}


# Set the repo name

[string]$grpName = -Join("$packageType","-","$key","-remote")



########## Finds a package in the remote repo ##########

# Execute once to configure the Artifactory source  

$xml = [XML](Get-Content $Env:Appdata\NuGet\NuGet.config)
$packageSource = $xml.configuration.packageSources.add.value

If ($packageSource -CONTAINS "https://$url/api/nuget/v3/$grpName") {"Package source exists."}
    Else {D:\nuget.exe sources Add -Name "Artifactory" -Source "https://$url/api/nuget/$grpName"}


# List - proves that the remote repository is reachable

  D:\nuget.exe list Microsoft.SQLServer


Stop-Transcript