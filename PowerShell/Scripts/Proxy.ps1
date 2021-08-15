netsh winhttp show proxy

netsh winhttp set proxy "192.168.0.14:3128"

$Wcl = new-object System.Net.WebClient
$Wcl.Headers.Add(“user-agent”, “PowerShell Script”)
$Wcl.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

<#
$Wcl=New-Object System.Net.WebClient
$Creds=Get-Credential
$Wcl.Proxy.Credentials=$Creds
#>

<#
# Set Proxy Server Settings in the PowerShell Profile File
# C:\Users\username\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
notepad $PROFILE


[system.net.webrequest]::DefaultWebProxy = new-object system.net.webproxy('http://10.1.15.5:80')
# If you need to import proxy settings from Internet Explorer, you can replace the previous line with the: "netsh winhttp import proxy source=ie"
[system.net.webrequest]::DefaultWebProxy.credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
# You can request user credentials:
# System.Net.WebRequest]::DefaultWebProxy.Credentials = Get-Credential
# Also, you can get the user password from a saved XML file (see the article “Using saved credentials in PowerShell scripts”):
# System.Net.WebRequest]::DefaultWebProxy= Import-Clixml -Path C:\PS\user_creds.xml
[system.net.webrequest]::DefaultWebProxy.BypassProxyOnLocal = $true

Set-ExecutionPolicy RemoteSigned

# Save the Microsoft.PowerShell_profile.ps1 file and restart the PowerShell console window

# Enable proxy
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyEnable -value 1

# Disable proxy:
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' ProxyEnable -value 0

#>

function Set-Proxy ( $server,$port)
{
If ((Test-NetConnection -ComputerName $server -Port $port).TcpTestSucceeded) {
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyServer -Value "$($server):$($port)"
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 1
}
Else {
Write-Error -Message "Invalid proxy server address or port:  $($server):$($port)"
}
}

Set-Proxy 192.168.1.100 3128