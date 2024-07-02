# -----------------------------------------------------------------------------
# Script: Switch_DebugRemoteWMISession.ps1
# Author: ed wilson, msft
# Date: 7/8/2015
# Keywords: Debugging
# comments: Errors
# Windows PowerShell 5.0 Step by Step, Microsoft Press, 2015
# Chapter 18
# -----------------------------------------------------------------------------

[CmdletBinding()]
Param($cn = $env:computername)
$credential = Get-Credential
Write-Debug "user name: $($credential.UserName)"
Write-Debug "password: $($credential.GetNetworkCredential().Password)"
Write-Debug "$cn is up: 
  $(Test-Connection -Computername $cn -Count 1 -BufferSize 16 -quiet)"
Get-WmiObject win32_bios -cn $cn -Credential $credential 
