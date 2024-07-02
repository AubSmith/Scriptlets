# ------------------------------------------------------------------------
# NAME: Get-DiskSpace.ps1
# AUTHOR: ed wilson, Microsoft
# DATE: 1/28/2009
#
# KEYWORDS: [wmi], wmi accelerator, win32_logicaldisk,
# function
# COMMENTS: This script contains the Get-DiskSpace function
# that uses the wmi accelerator to connection to a specific
# instance of the win32_logicaldisk class
#
#
# ------------------------------------------------------------------------
Function Get-DiskSpace($drive,$computer)
{
 ([wmi]"\\$computer\root\cimv2:Win32_logicalDisk.DeviceID='$drive'").FreeSpace
}
Get-DiskSpace -drive "C:" -computer "Office"