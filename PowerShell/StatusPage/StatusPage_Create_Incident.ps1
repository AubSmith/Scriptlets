<#
.Synopsis
  This script is used to interface with the StatusPage.IO API, and specifically creates new incidents.

.Description
  The script has been parametrised to pass through required values to the StatusPage.IO to create a new
  incident.

  This script is to be used in conjunction with other scripts to fully interact with the API.

.INPUTS
  See function-level notes

.OUTPUTS
  A log file is written to the same directory that the script is executed from. At this stage the returned
  JSON is not used for any further interactions.

.NOTES

  Author: Aubrey Smith (aubrey.smith@anz.com)
  Date  : 2018/07/20
  Vers  : 1.3

  Updates:
  1.0   Original Script
  1.1   Added in impact
        Added in logic to handle component IDs
  1.2   Hardcoded parameters for the PoC
  1.3   Added logic to store the incident ID

.PARAMETER Name
  Provides the name of the incident. This is displayed as the heading on the StatusPage
  incident page.

.PARAMETER Status
  Inputs can be one of created | closed (Dynatrace).
  Outputs can be one of investigating|identified|monitoring|resolved. Blank defaults to investigating (StatusPage).

.PARAMETER Body
  Provides the detailed desciption of the issue.

.PARAMETER Impact
  Outputs can be one of none|minor|major|critical. This is calculated based on the input parameter (StatusPage).

.LINK
	https://doers.statuspage.io/api/v1/
	https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-5.1

.EXAMPLE
	.\StatusPage_Create_Incident.ps1 '${AGENT_GROUP_NAME}' '${STATE}' '${MESSAGE}' '${SEVERITY}'

#>

## Declare incident value parameters ##

[CmdletBinding()]
Param(
[Parameter(Mandatory=$True,Position=1)]
[string]$Name,

[Parameter(Mandatory=$True,Position=2)]
[string]$Status,

[Parameter(Mandatory=$True,Position=3)]
[string]$Body,

[Parameter(Mandatory=$True,Position=4)]
[string]$Impact
)

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


# Determine the affected component ID

If ($Name -like '*API*') {$Component_ID = 'b7rn3mvthp2l'}
    Else {$Component_ID=''}


# Translate the State to Status mapping

If ($Status -like 'Closed') { $Status = 'resolved'}
    Else {$Status = 'investigating'}

If ($Impact -like 'Severe') {$Impact = 'critical'}
    ElseIF ($Impact -like 'Warning') {$Impact = 'minor'}
    ElseIF ($Impact -like 'Informational') {$Impact = 'none'}
    #Else{$Impact = 'minor'}


# Set Delivery_Notification - Turns incident notifications (e.g. Slack) on or off. Default is ON.

$Delivery_Notification = $false

# Set Components

If ($Impact = 'critical') {$Components = 'major_outage'}
    ElseIF ($Impact = 'minor') {$Components = 'partial_outage'}
    ElseIF ($Impact = 'none') {$Components = 'degraded_performance'}
    Else{$Components = 'partial_outage'}

# Convert the values to JSON
        # also check if there's affected component listed

if([string]::IsNullOrEmpty($Component_ID)){
    $data =@{incident=@{
          name=$Name
          status=$Status
          body=$Body
          deliver_notifications=$Delivery_Notification}}
}
Else{
    $data =@{incident=@{
          name=$Name
          status=$Status
          body=$body
          component_ids=$Component_ID
          deliver_notifications=$Delivery_Notification
          components=@{$Component_ID=$Components}}}
}

$incident = ConvertTO-JSON -InputObject $data -Depth 99 -Compress


# Force PowerShell to use TLS1.2 - PowerShell natively uses TLS1.0

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


# Invoke the API and create the incident

Invoke-RestMethod -Uri "https://api.statuspage.io/v1/pages/incidents.json" -Header @{Authorization = "OAuth $token"} -ContentType 'Application/json' -Method Post -Body $incident -OutFile $Logpath\Response.json -ErrorVariable RestError

# Extract the incident ID

$Incident_ID = (Get-Content $LogPath\Response.json | ConvertFrom-Json).incident_updates.incident_id

# Save the Incident ID

$Incident_ID | Set-Content  "$LogPath\$Name.txt"

if ($RestError)
{
    $HttpStatusCode = $RestError.ErrorRecord.Exception.Response.StatusCode.value__
    $HttpStatusDescription = $RestError.ErrorRecord.Exception.Response.StatusDescription
}

$HttpStatusCode
$HttpStatusDescription

Stop-Transcript