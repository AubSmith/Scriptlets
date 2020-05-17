<#
.SYNOPSIS

This script is to be used to create Windows Defender exclusions for Visual Studio directories

.DESCRIPTION

Windows Defender performs real-time scans, which during build tasks can severely degrade system performance. This script targets well-known paths and executables used by Visual Studio and adds them as Windows Defender exclusions.

.INPUTS

None.

.OUTPUTS

Log file stored in C:\Windows\Temp\Output.log - only written if targeted folders do not exist.

.NOTES

  Version:   1.1
  Author:    Aubrey Smith
  Created:   04 May 2018 (Star Wars Day - may the fourth be with you!)
  Change:    Included common development paths

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
Add-MpPreference -ExclusionProcess "devenv.exe"
Add-MpPreference -ExclusionProcess "MSBuild.exe"
Add-MpPreference -ExclusionProcess "dotnet.exe"
Add-MpPreference -ExclusionProcess "node.exe"
Add-MpPreference -ExclusionProcess "ServiceHub.Host.Node.x86.exe"

# Excluded directories:

$Locations =    "C:\Users\$Env:UserName\Documents\Visual Studio 2015\Projects\",
                "C:\Users\$Env:UserName\Documents\Visual Studio 2017\Projects\",
                "C:\Program Files (x86)\Microsoft Visual Studio 14.0\",
                "D:\Program Files (x86)\Microsoft Visual Studio 14.0\",
                "C:\Program Files (x86)\Microsoft Visual Studio 15.0\",
                "D:\Program Files (x86)\Microsoft Visual Studio 15.0\",
                "C:\Program Files (x86)\Microsoft Visual Studio\",
                "D:\Program Files (x86)\Microsoft Visual Studio\",
                "C:\ProgramData\Microsoft\VisualStudio\Packages\",
                "C:\Windows\assembly\",
                "C:\Windows\Microsoft.NET\",
                "C:\Program Files (x86)\MSBuild\",
                "C:\Program Files\dotnet\",
                "C:\Program Files (x86)\Microsoft SDKs\",
                "C:\Program Files\Microsoft SDKs\",
                "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files\",
                "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files\",
                "C:\Users\$Env:UserName\AppData\Local\Microsoft\VisualStudio\",
                "C:\Users\$Env:UserName\AppData\Local\Microsoft\WebsiteCache\",
                "C:\Users\$Env:UserName\AppData\Local\Jetbrains\",
                "C:\Users\$Env:UserName\AppData\Local\nuget\",
                "C:\Users\$Env:UserName\AppData\Roaming\Microsoft\VisualStudio\",
                "C:\Users\$Env:UserName\AppData\Roaming\JetBrains\",
                "C:\Users\$Env:UserName\AppData\Roaming\npm\",
                "C:\Users\$Env:UserName\AppData\Roaming\npm-cache\",
                "C:\Dev\",
                "C:\Develop\",
                "C:\Development\",
                "D:\Dev\",
                "D:\Develop\",
                "D:\Development\"


$Locations | % {$_
 
    $FolderExists = Test-Path -Path $_

    IF($FolderExists -eq $true){Add-MpPreference -ExclusionPath $_}
Else {LogWrite "$_ does not exist"}}

# END