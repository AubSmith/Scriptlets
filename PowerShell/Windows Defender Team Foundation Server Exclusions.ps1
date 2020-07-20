<#
.SYNOPSIS

This script is to be used to create Windows Defender exclusions for TFS directories

.DESCRIPTION

Windows Defender performs real-time scans which can severely degrade system performance. This script targets well-known paths and executables used by TFS and adds them as Windows Defender exclusions.

.INPUTS

None.

.OUTPUTS

Log file stored in C:\Windows\Temp\Output.log - only written if targeted folders do not exist.

.NOTES

  Version:   1.1
  Author:    Aubrey Smith
  Created:   04 May 2018 (Star Wars Day - may the fourth be with you!)
  Change:    Included common development paths
             Added filter to only apply existing directories

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

# Excluded processes:

$Process =  "C:\Windows\System32\inetsrv\w3wp.exe",
            "D:\Program Files\Microsoft Team Foundation Server 14.0\Application Tier\TFSJobAgent\TFSJobAgent.exe",
            "C:\Program Files\Microsoft Team Foundation Server 2018\Application Tier\TFSJobAgent\TFSJobAgent.exe"

$Process | % {$_
 
    $ProcessExists = Test-Path -Path $_

    IF($ProcessExists -eq $true){Add-MpPreference -ExclusionPath $_}
Else {LogWrite "$_.Fullname does not exist"}}

# Excluded directories:

$Location = "D:\Program Files\Microsoft Team Foundation Server 14.0\Application Tier\Web Services\bin\",
            "C:\Program Files\Microsoft Team Foundation Server 2018\Application Tier\Web Services\bin\",
            "D:\Program Files\Microsoft Team Foundation Server 14.0\Application Tier\Web Services_tfs_data",
            "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files\",
            "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files\",
            "C:\inetpub\temp\",
            "D:\TfsData\ApplicationTier\_fileCache",
            "C:\Users\$Env:UserName\AppData\Local\Temp\",
            "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\14"

$Location| % {$_
 
    $FolderExists = Test-Path -Path $_

    IF($FolderExists -eq $true){Add-MpPreference -ExclusionPath $_}
Else {LogWrite "$_.Fullname does not exist"}}

#End