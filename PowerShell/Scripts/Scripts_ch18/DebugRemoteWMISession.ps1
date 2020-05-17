# -----------------------------------------------------------------------------
# Script: DebugRemoteWMISession.ps1
# Author: ed wilson, msft
# Date: 09/07/2013 16:30:28
# Keywords: Debugging
# comments: Errors
# Windows PowerShell 5.0 Step by Step, Microsoft Press, 2015
# Chapter 18
# -----------------------------------------------------------------------------
$oldDebugPreference = $DebugPreference
$DebugPreference = "continue"
$credential = Get-Credential
$cn = Read-Host -Prompt "enter a computer name"
Write-Debug "user name: $($credential.UserName)"
Write-Debug "password: $($credential.GetNetworkCredential().Password)"
Write-Debug "$cn is up: 
  $(Test-Connection -Computername $cn -Count 1 -BufferSize 16 -quiet)"
Get-WmiObject win32_bios -cn $cn -Credential $credential
$DebugPreference = $oldDebugPreference
