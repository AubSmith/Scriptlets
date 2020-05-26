<#
.Synopsis
  This script is to automate, as far as possible, the importing of Jira user/group mappings from one environment to another.
  The script can be invoked via the PowerShell command line.

.Description
  The script has been paramterised to allow flexibility and portability across environments.

.INPUTS
  See function-level notes.

.OUTPUTS
  A log is written to the directory from where the tool is invoked.

.NOTES

  Author: Aubrey Smith (aubrey.smith@anz.com)
  Date  : 2020/05/25
  Vers  : 1.0

  Updates:
  1.0   Original Script
  
.PARAMETER env
  The environment in which to execute the script; either prod, oat or dev.

.PARAMETER 
  

.PARAMETER 
  

.PARAMETER 
  

.PARAMETER 
  

.LINK
  https://docs.atlassian.com/software/jira/docs/api/REST/8.9.0/#api/2/group-addUserToGroup

.EXAMPLE
  .\Jira_Add_User_Grp.ps1 "test"

#>

[CmdletBinding()]
Param(
  [parameter(mandatory=$true,Position=1)]
  [string]$envmt
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

$auth = Get-Credential -Message "Enter Credentials for Jira"

# Retrieve the environment settings from a config file.

$Xml = [XML](Get-Content .\Config.xml)
$Url = $xml.settings.$envmt.url
$ContentPath = $Xml.settings.$envmt.file 
$Csv = Import-Csv $ContentPath 
$Usergrp = $Csv | ForEach-Object {
  $Group = $_.group
  $UserName = $_.username
}

ForEach($User in $UserGrp) {                

$User

if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type)
{
$certCallback = @"
    using System;
    using System.Net;
    using System.Net.Security;
    using System.Security.Cryptography.X509Certificates;
    public class ServerCertificateValidationCallback
    {
        public static void Ignore()
        {
            if(ServicePointManager.ServerCertificateValidationCallback ==null)
            {
                ServicePointManager.ServerCertificateValidationCallback += 
                    delegate
                    (
                        Object obj, 
                        X509Certificate certificate, 
                        X509Chain chain, 
                        SslPolicyErrors errors
                    )
                    {
                        return true;
                    };
            }
        }
    }
"@
    Add-Type $certCallback
 }
 
 $Body = "{ name : $UserName}"
 
$Result = ( Invoke-RestMethod -Uri "https://$url/rest/api/2/$Group/user" -Method Post -Credential $Auth -Headers @{ Authorization = "Basic" } -Body $Body -ErrorVariable RestErrorRep ).content
 
  if ($RestErrorRep)
  {
      $HttpStatusCodeRep = $RestErrorRep.ErrorRecord.Exception.Response.StatusCode.value__
      $HttpStatusDescRep = $RestErrorRep.ErrorRecord.Exception.Response.StatusDescription
  }
  
  $HttpStatusCodeRep
  $HttpStatusDescRep

}

$Result