# RemoteWMISessionNoDebug.ps1
# ed wilson, msft, 4/8/12
# PowerShell 3.0 Step By Step
# chapter 18
# Scripting Techniques, Troubleshooting, debugging

$credential = Get-Credential
$cn = Read-Host -Prompt "enter a computer name"
Get-WmiObject win32_bios -cn $cn -Credential $credential