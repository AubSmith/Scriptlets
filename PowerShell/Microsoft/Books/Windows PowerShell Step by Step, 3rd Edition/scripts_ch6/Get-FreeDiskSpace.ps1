# ------------------------------------------------------------------------
# NAME: Get-FreeDiskSpace.ps1
# AUTHOR: ed wilson, Microsoft
# DATE: 1/29/2009
#
# KEYWORDS: function, Get-WmiObject, WMI,
# Win32_LogicalDisk, .NET Framework format specifier
# COMMENTS: This script uses the Get-FreeDiskSpace
# function to retrieve the free disk space on a local or remote
# computer. It takes two parameters the drive and the computer
# 
# Windows PowerShell Best Practices
# ------------------------------------------------------------------------
#Requires -Version 2.0
Function Get-FreeDiskSpace($drive,$computer)
{
 $driveData = Get-WmiObject -class win32_LogicalDisk `
 -computername $computer -filter "Name = '$drive'" 
"
 $computer free disk space on drive $drive 
    $("{0:n2}" -f ($driveData.FreeSpace/1MB)) MegaBytes
" 
}

Get-FreeDiskSpace -drive "C:" -computer "vista"