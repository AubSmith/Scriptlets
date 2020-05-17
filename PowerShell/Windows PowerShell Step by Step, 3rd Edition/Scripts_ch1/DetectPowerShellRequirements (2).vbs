'==========================================================================
'
'
' NAME: <DetectPowerShellRequirements.vbs>
'
' AUTHOR: Ed Wilson , MS
' DATE  : 12/3/2006
'
' COMMENT: <Detects presence of requirements to install PowerShell>
'1. PowerShell requires .NET Framework 2.0, and SP2 on Windows XP.
'2. SP1 on Windows Server 2003. This script detects these values.
'==========================================================================

Option Explicit 
On Error Resume Next
dim strComputer			'target computer
dim wmiNS						'target wmi name space
dim wmiQuery, wmiQuery1				'the WMI query
dim objWMIService		'sWbemservices object
dim colItems, colItems1				'sWbemObjectSet object
dim objItem, objItem1				'sWbemObject
Dim netERR
Dim osVER
Dim osSP

Const RtnImmedFwdOnly = &h30 'iflags for ExecQuery method of swbemservices object
strComputer = "."
wmiNS = "\root\cimv2"
wmiQuery = "Select name from win32_Product where name like '%.NET Framework 2.0%'"
wmiQuery1 = "Select * from win32_OperatingSystem"

WScript.Echo "Retrieving settings on " & CreateObject("wscript.network").computername & " this will take some time ..."


Set objWMIService = GetObject("winmgmts:\\" & strComputer & wmiNS)
Set colItems = objWMIService.ExecQuery(wmiQuery)
Set colItems1= objWMIService.ExecQuery(wmiQuery1,,RtnImmedFwdOnly)

If colItems.count <>1 Then
	WScript.Echo ".NET Framework 2.0 is required for PowerShell"
	Else 
	WScript.Echo ".NET Framework 2.0 detected"
End If


For Each objItem1 In colItems1
	osVER= objItem1.version
	osSP= objItem1.ServicePackMajorVersion 
Next

Select Case osVER
Case "5.1.2600"
	If osSP < 2 Then 
		WScript.Echo "Service Pack 2 is required on Windows XP"
	Else
		WScript.Echo "Service Pack",osSP,"detected on",osVER
	End If
Case "5.2.3790"
	If osSP <1 Then 
		WScript.Echo "Service Pack 1 is required on Windows Server 2003"
	Else
		WScript.Echo "Service Pack",osSP,"detected on",osVER
	End if
Case "6.0.6001"
	WScript.Echo "No service pack is required on Windows Vista"
Case Else
	WScript.Echo "Windows PowerShell does not install on Windows version " & osVER
End Select