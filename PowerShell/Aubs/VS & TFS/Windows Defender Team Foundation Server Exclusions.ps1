<#
.SYNOPSIS

This script is to be used to create Windows Defender exclusions for Team Services Foundation directories

.DESCRIPTION

Windows Defender performs real-time scans which can severely degrade system performance. This script targets well-known paths and executables used by TFS and adds them as Windows Defender exclusions.

.INPUTS

None.

.OUTPUTS

Log file stored in C:\Windows\Temp\Output.log - only written to if targeted folders do not exist.

.NOTES

  Version:   1.0
  Author:    Aubrey Smith
  Created:   04 May 2018 (Star Wars Day - may the fourth be with you!)
  Change:    Initial script development

.Example

Execute from an elevated PowerShell shell.

#>

# Specify the logfile path and name

$LogFile = "C:\Windows\Temp\Output.log"

# Function: LogWrite - Write error if folder does not exist

Function LogWrite
{
    Param ([string]$logstring)

    Add-Content $LogFile -Value $logstring
}

# NOTE: Add exclusions as required

# Excluded processes:

$TFSProcesses = "C:\Windows\System32\inetsrv\w3wp.exe",
                "C:\Program Files\Microsoft Team Foundation Server 14.0\Application Tier\TFSJobAgent\TFSJobAgent.exe",
                "D:\Program Files\Microsoft Team Foundation Server 14.0\Application Tier\TFSJobAgent\TFSJobAgent.exe",
                "C:\Program Files\Microsoft Team Foundation Server 2018\Application Tier\TFSJobAgent\TFSJobAgent.exe",
                "D:\Program Files\Microsoft Team Foundation Server 2018\Application Tier\TFSJobAgent\TFSJobAgent.exe"

$TFSProcesses | % {$_
 
    $ExeExists = Test-Path -Path $_
                
    IF($ExeExists -eq $true){Add-MpPreference -ExclusionPath $_}
Else {LogWrite "$_ does not exist"}}

# END

# Excluded directories:

$TFSPaths =     "D:\Program Files\Microsoft Team Foundation Server 14.0\Application Tier\Web Services\bin\",
                "C:\Program Files\Microsoft Team Foundation Server 2018\Application Tier\Web Services\bin\",
                "D:\Program Files\Microsoft Team Foundation Server 14.0\Application Tier\Web Services_tfs_data",
                "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files\",
                "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files\",
                "C:\inetpub\temp\",
                "D:\TfsData\ApplicationTier\_fileCache",
                "C:\Users\$Env:UserName\AppData\Local\Temp\",
                "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\14"

$TFSPaths | % {$_
 
    $FolderExists = Test-Path -Path $_
                
    IF($FolderExists -eq $true){Add-MpPreference -ExclusionPath $_}
Else {LogWrite "$_ does not exist"}}
                
# END# End