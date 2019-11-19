# ------------------------------------------------------------------------
# NAME: Get-OperatingSystemVersion.ps1
# AUTHOR: ed wilson, Microsoft
# DATE: 2/2/2009
#
# KEYWORDS: Function, Get-WmiObject, 
# Win32_OperatingSystem
#
# COMMENTS: This script returns the OS version number
# to the calling script. 
#
# Windows PowerShell Best Practices
#
# ------------------------------------------------------------------------
Function Get-OperatingSystemVersion
{
 (Get-WmiObject -Class Win32_OperatingSystem).Version
} #end Get-OperatingSystemVersion

"This OS is version $(Get-OperatingSystemVersion)"