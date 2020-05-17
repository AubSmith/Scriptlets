# ------------------------------------------------------------------------
# NAME: Get-EnabledBreakpointsFunction.ps1
# AUTHOR: ed wilson, Microsoft
# DATE:
#
# KEYWORDS: Get-PSBreakPoint
#
# COMMENTS: This function returns enabled breakpoints
#
# Windows PowerShell 3.0 Step by Step
# #Requires -Version 3.0
# ------------------------------------------------------------------------

Function Get-EnabledBreakpoints
{
  Get-PSBreakpoint | 
  Format-Table -Property id, script, command, variable, enabled -AutoSize
}

# *** Entry Point to Script ***

Get-EnabledBreakpoints
