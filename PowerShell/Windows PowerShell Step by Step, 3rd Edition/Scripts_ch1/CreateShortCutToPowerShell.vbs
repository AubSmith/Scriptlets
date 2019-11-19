'==========================================================================
'
' VBScript:  AUTHOR: Ed Wilson , MS,  12/8/2006
'
' NAME: CreateShortCutToPowerShell.vbs
'
' COMMENT: Key concepts are listed below:
'1.uses the wshobject to create a shortcut to powershell.
'2.places this shortcut on the desktop.
'3.path to the desktop is returned via the specialfolders method
'==========================================================================

Option Explicit
Dim objshell
Dim strDesktop
Dim objshortcut
Dim strProg
strProg = "powershell.exe"

Set objshell=CreateObject("WScript.Shell")
strDesktop = objshell.SpecialFolders("desktop")
set objShortcut = objshell.CreateShortcut(strDesktop & "\powershell.lnk")
objshortcut.TargetPath = strProg
objshortcut.WindowStyle = 1
objshortcut.Description = funfix(strProg)
objshortcut.WorkingDirectory = "C:\"
objshortcut.IconLocation= strProg
objshortcut.Hotkey = "CTRL+SHIFT+P"
objshortcut.Save

Function funfix(strin)
funfix = InStrRev(strin,".")
funfix = Mid(strin,1,funfix)
End function
