mkdir %windir%\Tools
copy /Y Log-EphemeralPortStats.ps1 %windir%\Tools\Log-EphemeralPortStats.ps1
schtasks /create /F /tn LogEphemeralPorts /sc onstart /tr "powershell.exe %windir%\Tools\Log-EphemeralPortStats.ps1 -OutputFilePath %windir%\Tools\EphemeralPortStats.log" /ru System
schtasks /run /tn LogEphemeralPorts