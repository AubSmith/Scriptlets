#-----------------------------------------------------------------------------------#
#                                                                                   # 
#    Written By: Ryan Waters (rywaters)  rywaters@microsoft.com                     # 
#                                                                                   #
#    Purpose: To easily determine the SChannel configuration is in use on a box.    #
#                                                                                   #
#    Date: 09/02/2016                                                               #
#                                                                                   #
#    Version: 1.6                                                                   #
#                                                                                   #
#    Copywrite: 09/02/2016 Microsoft                                                #
#                                                                                   #
#    Disclaimer: Any sample scripts contained in this article are not supported     #
#    under any Microsoft standard support program or service. Any sample scripts    #
#    contained in this article are provided AS IS without warranty of any kind.     #
#    Microsoft further disclaims all implied warranties including, without          #
#    limitation, any implied warranties of merchantability or of fitness for a      #
#    particular purpose. The entire risk arising out of the use or performance of   #
#    the sample scripts and documentation contained in this article remains with    #
#    you. In no event shall Microsoft, its authors, or anyone else involved in the  #
#    creation, production, or delivery of the scripts contained in this article be  #
#    liable for any damages whatsoever (including, without limitation, damages for  #
#    loss of business profits, business interruption, loss of business information, #
#    or other pecuniary loss) arising out of the use of or inability to use the     #
#    sample scripts or documentation contained in this article, even if Microsoft   #
#    has been advised of the possibility of such damages.  Use at your own risk     #
#                                                                                   #
#    Distribution: You are allowed to distribute this software, but are not         #
#    allowed to modify, copy the code herein without express permission of the      #
#    author.                                                                        #
#                                                                                   #
#    Bugs: If you find any bugs, please report to the author 'Ryan Waters' and use  #
#    in the subject line "Get-SChannelConfig".                                      #
#                                                                                   #
#    Usage: .\Get-SchannelConfig.ps1                                                #
#    Additional Parameters: -Reset (Resets the machines SChannel configuration to   #
#                           defaults                                                #
#                                                                                   # 
#-----------------------------------------------------------------------------------#
Param
(
	[Switch]$Reset
)


$osversionMajor = [System.Environment]::OSVersion.Version.Major
$osversionMinor = [System.Environment]::OSVersion.Version.Minor
$hostname = hostname
$isX64 = [Environment]::Is64BitProcess

# SChannel Paths
$schannel = "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL"
$scciphers = "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers"
$scciphersuites = "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\CipherSuites"
$schashes = "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes"
$sckeyexchangealgo = "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms"
$scprotocols = "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"
$protocolsSSL20 = "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0"
$ssl20clientpath = "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
$ssl20serverpath = "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"

# DefaultSecureProtocols
$IEDefaultSecureProtocols = "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$WinHttpDefaultSecureProtocols = "HKCU:\\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
$X32WinHttpDefaultSecureProtocols = "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"

# Cryptgraphy Paths
$gp00010002 = "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
$local00010002ssl = "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL"
$local00010002 = "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
$local00010003 = "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010003"

# 00010002 Function list by OS
$vistaciphers0102 = @(
	"TLS_RSA_WITH_AES_128_CBC_SHA",
    "TLS_RSA_WITH_AES_256_CBC_SHA",
    "TLS_RSA_WITH_RC4_128_SHA",
    "TLS_RSA_WITH_3DES_EDE_CBC_SHA",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P256",
    "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P384",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P521",
    "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P256",
    "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P384",
    "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P521",
    "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P256",
    "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P384",
    "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P521",
    "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P256",
    "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P384",
    "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P521",
    "TLS_DHE_DSS_WITH_AES_128_CBC_SHA",
    "TLS_DHE_DSS_WITH_AES_256_CBC_SHA",
    "TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA",
    "TLS_RSA_WITH_RC4_128_MD5",
    "SSL_CK_RC4_128_WITH_MD5",
    "SSL_CK_DES_192_EDE3_CBC_WITH_MD5",
    "TLS_RSA_WITH_NULL_MD5",
    "TLS_RSA_WITH_NULL_SHA"
)

$sevenciphers0102 = @(
	"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256",
	"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384",
	"TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256",
	"TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P384",
	"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P256",
	"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P384",
	"TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P256",
	"TLS_ECDHE_RDA_WITH_AES_128_CBC_SHA_P384",
	"TLS_DHE_RSA_WITH_AES_256_GCM_SHA384",
	"TLS_DHE_RSA_WITH_AES_128_GCM_SHA256",
	"TLS_DHE_RSA_WITH_AES_256_CBC_SHA",
	"TLS_DHE_RSA_WITH_AES_128_CBC_SHA",
	"TLS_RSA_WITH_AES_256_GCM_SHA384",
	"TLS_RSA_WITH_AES_128_GCM_SHA256",
	"TLS_RSA_WITH_AES_256_CBC_SHA256",
	"TLS_RSA_WITH_AES_128_CBC_SHA256",
	"TLS_RSA_WITH_AES_256_CBC_SHA",
	"TLS_RSA_WITH_AES_128_CBC_SHA",
	"TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384_P384",
	"TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P256",
	"TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P384",
	"TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384_P384",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P256",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P384",
	"TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P256",
	"TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P384",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P256",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P384",
	"TLS_DHE_DSS_WITH_AES_256_CBC_SHA256",
	"TLS_DHE_DSS_WITH_AES_128_CBC_SHA256",
	"TLS_DHE_DSS_WITH_AES_256_CBC_SHA",
	"TLS_DHE_DSS_WITH_AES_128_CBC_SHA",
	"TLS_RSA_WITH_3DES_EDE_CBC_SHA",
	"TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA",
	"TLS_RSA_WITH_RC4_128_SHA",
	"TLS_RSA_WITH_RC4_128_MD5",
	"TLS_RSA_WITH_NULL_SHA256",
	"TLS_RSA_WITH_NULL_SHA",
	"SSL_CK_RC4_128_WITH_MD5",
	"SSL_CK_DES_192_EDE3_CBC_WITH_MD5"
)

$20120102 = @(
	"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256",
    "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384",
    "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256",
    "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P384",
    "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P256",
    "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P384",
    "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P256",
    "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P384",
    "TLS_DHE_RSA_WITH_AES_256_GCM_SHA384",
    "TLS_DHE_RSA_WITH_AES_128_GCM_SHA256",
    "TLS_RSA_WITH_AES_256_GCM_SHA384",
    "TLS_RSA_WITH_AES_128_GCM_SHA256",
    "TLS_RSA_WITH_AES_256_CBC_SHA256",
    "TLS_RSA_WITH_AES_128_CBC_SHA256",
    "TLS_RSA_WITH_AES_256_CBC_SHA",
    "TLS_RSA_WITH_AES_128_CBC_SHA",
    "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384_P384",
    "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P256",
    "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P384",
    "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384_P384",
    "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P256",
    "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P384",
    "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P256",
    "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P384",
    "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P256",
    "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P384",
    "TLS_DHE_DSS_WITH_AES_256_CBC_SHA256",
    "TLS_DHE_DSS_WITH_AES_128_CBC_SHA256",
    "TLS_DHE_DSS_WITH_AES_256_CBC_SHA",
    "TLS_DHE_DSS_WITH_AES_128_CBC_SHA",
    "TLS_RSA_WITH_3DES_EDE_CBC_SHA",
    "TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA",
    "TLS_RSA_WITH_RC4_128_SHA",
    "TLS_RSA_WITH_RC4_128_MD5",
    "TLS_RSA_WITH_NULL_SHA256",
    "TLS_RSA_WITH_NULL_SHA",
    "SSL_CK_RC4_128_WITH_MD5",
    "SSL_CK_DES_192_EDE3_CBC_WITH_MD5"
)

$2012R20102 = @(
	"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256",
	"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384",
	"TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256",
	"TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P384",
	"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P256",
	"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P384",
	"TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P256",
	"TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P384",
	"TLS_DHE_RSA_WITH_AES_256_GCM_SHA384",
	"TLS_DHE_RSA_WITH_AES_128_GCM_SHA256",
	"TLS_RSA_WITH_AES_256_GCM_SHA384",
	"TLS_RSA_WITH_AES_128_GCM_SHA256",
	"TLS_RSA_WITH_AES_256_CBC_SHA256",
	"TLS_RSA_WITH_AES_128_CBC_SHA256",
	"TLS_RSA_WITH_AES_256_CBC_SHA",
	"TLS_RSA_WITH_AES_128_CBC_SHA",
	"TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384_P384",
	"TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P256",
	"TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P384",
	"TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384_P384",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P256",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P384",
	"TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P256",
	"TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P384",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P256",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P384",
	"TLS_DHE_DSS_WITH_AES_256_CBC_SHA256",
	"TLS_DHE_DSS_WITH_AES_128_CBC_SHA256",
	"TLS_DHE_DSS_WITH_AES_256_CBC_SHA",
	"TLS_DHE_DSS_WITH_AES_128_CBC_SHA",
	"TLS_RSA_WITH_3DES_EDE_CBC_SHA",
	"TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA",
	"TLS_RSA_WITH_RC4_128_SHA",
	"TLS_RSA_WITH_RC4_128_MD5",
	"TLS_RSA_WITH_NULL_SHA256",
	"TLS_RSA_WITH_NULL_SHA",
	"SSL_CK_RC4_128_WITH_MD5",
	"SSL_CK_DES_192_EDE3_CBC_WITH_MD5",
	"TLS_RSA_WITH_NULL_MD5"
)

$100102 = @(
	"TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
	"TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
	"TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
	"TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
	"TLS_DHE_RSA_WITH_AES_256_GCM_SHA384",
	"TLS_DHE_RSA_WITH_AES_128_GCM_SHA256",
	"TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256",
	"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384",
	"TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256",
	"TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA",
	"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA",
	"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA",
	"TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA",
	"TLS_DHE_RSA_WITH_AES_256_CBC_SHA",
	"TLS_DHE_RSA_WITH_AES_128_CBC_SHA",
	"TLS_RSA_WITH_AES_256_GCM_SHA384",
	"TLS_RSA_WITH_AES_128_GCM_SHA256",
	"TLS_RSA_WITH_AES_256_CBC_SHA256",
	"TLS_RSA_WITH_AES_128_CBC_SHA256",
	"TLS_RSA_WITH_AES_256_CBC_SHA",
	"TLS_RSA_WITH_AES_128_CBC_SHA",
	"TLS_RSA_WITH_3DES_EDE_CBC_SHA",
	"TLS_DHE_DSS_WITH_AES_256_CBC_SHA256",
	"TLS_DHE_DSS_WITH_AES_128_CBC_SHA256",
	"TLS_DHE_DSS_WITH_AES_256_CBC_SHA",
	"TLS_DHE_DSS_WITH_AES_128_CBC_SHA",
	"TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA",
	"TLS_RSA_WITH_RC4_128_SHA",
	"TLS_RSA_WITH_RC4_128_MD5",
	"TLS_RSA_WITH_NULL_SHA256",
	"TLS_RSA_WITH_NULL_SHA",
	"TLS_PSK_WITH_AES_256_GCM_SHA384",
	"TLS_PSK_WITH_AES_128_GCM_SHA256",
	"TLS_PSK_WITH_AES_256_CBC_SHA384",
	"TLS_PSK_WITH_AES_128_CBC_SHA256",
	"TLS_PSK_WITH_NULL_SHA384",
	"TLS_PSK_WITH_NULL_SHA256"
)

# Only Windows 10/Server 2016 had EccCurves Value in addition to Functions.
$10ecccurves = @(
	"curve25519",
	"NistP256",
	"NistP384"
)

# 00010003 Function list by OS (Vista has no 00010003)

$sevenciphers0103 = @(
	"RSA/SHA512",
	"ECDSA/SHA512",
	"RSA/SHA256",
	"RSA/SHA384",
	"RSA/SHA1",
	"ECDSA/SHA256",
	"ECDSA/SHA384",
	"ECDSA/SHA1",
	"DSA/SHA1"
)

$20120103 = @(
	"RSA/SHA512",
    "ECDSA/SHA512",
    "RSA/SHA256",
    "RSA/SHA384",
    "RSA/SHA1",
    "ECDSA/SHA256",
    "ECDSA/SHA384",
    "ECDSA/SHA1",
    "DSA/SHA1"
)

$2012R20103 = @(
	"RSA/SHA512",
	"ECDSA/SHA512",
	"RSA/SHA256",
	"RSA/SHA384",
	"RSA/SHA1",
	"ECDSA/SHA256",
	"ECDSA/SHA384",
	"ECDSA/SHA1",
	"DSA/SHA1"
)

$100103 = @(
	"RSA/SHA256",
	"RSA/SHA384",
	"RSA/SHA1",
	"ECDSA/SHA256",
	"ECDSA/SHA384",
	"ECDSA/SHA1",
	"DSA/SHA1",
	"RSA/SHA512",
	"ECDSA/SHA512"
)


# Adds commandline option -Reset to wipe clean and use OS defaults.


	
If ($Reset -eq $true) 
{		
	If ($osversionMajor -eq 6 -And $osversionMinor -eq 0) {
		Write-host "This will blanket reset all SChannel Settings back to Windows Vista/Server 2008 defaults and requires a reboot."
		$answer = Read-host "Selecting 'y' now will automatically reset and reboot the machine now.  Do you accept? (y/n)"
		If (($answer -eq "yes") -or ($answer -eq "Yes") -or ($answer -eq "Y") -or ($answer -eq "y") -or ($answer -eq "YES")) {
			Write-host "Resetting SChannel to the Windows Vista/Server 2008 OS default values. . ."
			Remove-Item -path $schannel -Recurse
			Remove-Item -path $gp00010002 -Recurse
			Remove-Item -path $local00010002 -Recurse
			New-Item -path $schannel
			New-Item -path $scciphers
			New-Item -path $scciphersuites
			New-Item -path $schashes
			New-Item -path $sckeyexchangealgo
			New-Item -path $scprotocols
			New-Item -path $protocolsSSL20
			New-Item -path $ssl20clientpath
			New-Item -path $gp00010002
			New-Item -path $local00010002
			New-ItemProperty -path $local00010002ssl -Name "Flags" -PropertyType "DWord" -Value 1 -Force
			New-ItemProperty -path $local00010002 -Name "(Default)" -PropertyType "String" -Value "NCRYPT_SCHANNEL_INTERFACE" -Force
			New-ItemProperty -path $local00010002 -Name "Functions" -PropertyType "MultiString" -Value $vistaciphers0102 -Force
			New-ItemProperty -path $schannel -Name "EventLogging" -PropertyType "DWord" -Value 1 -Force
			New-ItemProperty -path $ssl20clientpath -Name DisabledByDefault -PropertyType "DWord" -Value 1 -Force
			Write-Host "SChannel Reset to defaults, rebooting machine in 10 seconds.  Ctrl+C to cancel."
			Start-sleep -s 10
			Shutdown.exe -f -r -t 00
		}
		Else {
			Write-Host "You have not accepted the terms.  Closing script."
			exit 0		
		}
	}
	ElseIf ($osversionMajor -eq 6 -And $osversionMinor -eq 1) {
		Write-host "This will blanket reset all SChannel Settings back to Windows 7/Server 2008 R2 defaults and requires a reboot."
		$answer = Read-host "Selecting 'y' now will automatically reset and reboot the machine now.  Do you accept? (y/n)"
		If (($answer -eq "yes") -or ($answer -eq "Yes") -or ($answer -eq "Y") -or ($answer -eq "y") -or ($answer -eq "YES")) {
			Write-host "Resetting SChannel to the Windows 7/Server 2008 R2 OS default values. . ."
			Remove-Item -path $schannel -Recurse
			Remove-Item -path $gp00010002 -Recurse
			Remove-Item -path $local00010002 -Recurse
			Remove-Item -path $local00010003 -Recurse
			New-Item -path $schannel
			New-Item -path $scciphers
			New-Item -path $scciphersuites
			New-Item -path $schashes
			New-Item -path $sckeyexchangealgo
			New-Item -path $scprotocols
			New-Item -path $protocolsSSL20
			New-Item -path $ssl20clientpath
			New-Item -path $local00010002
			New-Item -path $local00010003
			New-ItemProperty -path $local00010002ssl -Name "Flags" -PropertyType "DWord" -Value 1 -Force
			New-ItemProperty -path $schannel -Name "EventLogging" -PropertyType "DWord" -Value 1 -Force
			New-ItemProperty -path $local00010002 -Name "(Default)" -PropertyType "String" -Value "NCRYPT_SCHANNEL_INTERFACE" -Force
			New-ItemProperty -path $local00010002 -Name "Functions" -PropertyType "MultiString" -Value $sevenciphers0102 -Force 
			New-ItemProperty -path $local00010003 -Name "(Default)" -PropertyType "String" -Value "NCRYPT_SCHANNEL_SIGNATURE_INTERFACE" -Force
			New-ItemProperty -path $local00010003 -Name "Functions" -PropertyType "MultiString" -Value $sevenciphers0103 -Force
			New-ItemProperty -path $ssl20clientpath -Name DisabledByDefault -PropertyType "DWord" -Value 1 -Force
            $IsKBInstalled = get-hotfix -id "kb3140245" -EA SilentlyContinue
            If ($IsKBInstalled.HotFixID -eq "KB3140245") {
                Write-host "WARNING! Hotfix is installed that changes the OS Defaults to TLS 1.1 and 1.2 only for WinHTTP connections.`r"
                Add-Content .\result.txt -value "WARNING! Hotfix is installed that changes the OS Defaults to TLS 1.1 and 1.2 only for WinHTTP connections.`r"
                Write-host "TLS 1.0 will still be enabled for other connection types, but not for WinHTTP Connections.`r"
                Add-Content .\result.txt -value "TLS 1.0 will still be enabled for other connection types, but not for WinHTTP Connections.`r"
                Write-host "If applications that use TLS 1.0 over WinHTTP, You must change the below RegKey to 0xa80 to re-enable TLS 1.0:`r"
                Add-Content .\result.txt -value "If applications that use TLS 1.0 over WinHTTP, You must change the below RegKey to 0xa80 to re-enable TLS 1.0:`r"
                Write-host "HKLM:\\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp\DefaultSecureProtocols`r"
                Add-Content .\result.txt -value "HKLM:\\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp\DefaultSecureProtocols`r"
                Write-host "If x64, also add to: HKLM:\\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttpDefaultSecureProtocols`r`n"
                Add-Content .\result.txt -value "If x64, also add to: HKLM:\\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp\DefaultSecureProtocols`r`n"
                $SetTLS10WinHttp = Read-Host "Do you want to automatically enable TLS 1.0? (y/n)"
                If (($SetTLS10WinHttp -eq "yes") -or ($SetTLS10WinHttp -eq "Yes") -or ($SetTLS10WinHttp -eq "Y") -or ($SetTLS10WinHttp -eq "y") -or ($SetTLS10WinHttp -eq "YES")) {

                    If($isX64 -eq "True") {
                        Remove-Item -path $WinHttpDefaultSecureProtocols -Recurse
                        Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                        New-Item -path $WinHttpDefaultSecureProtocols
                        New-Item -path $X32WinHttpDefaultSecureProtocols
                        New-ItemProperty -path $WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                        New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                        Write-host "TLS 1.0 is enabled with the Patch installed.`r`n"
                        Add-Content .\result.txt -value "TLS 1.0 is enabled with the Patch installed`r`n"
                    }
                    Else {
                        Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                        New-Item -path $X32WinHttpDefaultSecureProtocols
                        New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                        Write-host "TLS 1.0 is enabled with the Patch installed`r`n"
                        Add-Content .\result.txt -value "TLS 1.0 is enabled with the Patch installed`r`n"
                    }
                    
                }
                Else {

                    If($isX64 -eq "True") {
                        Remove-Item -path $WinHttpDefaultSecureProtocols -Recurse
                        Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                        New-Item -path $WinHttpDefaultSecureProtocols
                        New-Item -path $X32WinHttpDefaultSecureProtocols
                        New-ItemProperty -path $WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2560" -Force
                        New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2560" -Force
                        Write-host "TLS 1.0 is disabled with the Patch installed`r`n"
                        Add-Content .\result.txt -value "TLS 1.0 is disabled with the Patch installed`r`n"
                    }
                    Else {
                        Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                        New-Item -path $X32WinHttpDefaultSecureProtocols
                        New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2560" -Force
                        Write-host "TLS 1.0 is disabled with the Patch installed`r`n"
                        Add-Content .\result.txt -value "TLS 1.0 is disabled with the Patch installed`r`n"
                    }
                }
            }
            Else {
                Write-host "KB3140245 is not installed.  WinHTTP has not been patched for enabling only TLS 1.1 and 1.2. This is okay."
                Add-Content .\result.txt -value "KB3140245 is not installed.  WinHTTP has not been patched for enabling only TLS 1.1 and 1.2. This is okay."
                Write-host "Do not install KB3140245 if 2003 is still in use in the AD Environment.`r"
                Add-Content .\result.txt -value "Do not install KB3140245 if 2003 is still in use in the AD Environment.`r"
            }
            Write-Host "SChannel Reset to defaults, rebooting machine in 10 seconds.  Hit Ctrl+C to cancel."
			Start-sleep -s 10
			Shutdown.exe -f -r -t 00
		}
		Else {
			Write-host "You have not accepted the terms.  Closing script."
			exit 0
		}
	}
	ElseIf ($osversionMajor -eq 6 -And $osversionMinor -eq 2) {
		Write-host "This will blanket reset all SChannel Settings back to Windows 8,8.1/Server 2012,2012 R2 defaults and requires a reboot."
		$answer = Read-host "Selecting 'y' now will automatically reset and reboot the machine now.  Do you accept? (y/n)"
		If (($answer -eq "yes") -or ($answer -eq "Yes") -or ($answer -eq "Y") -or ($answer -eq "y") -or ($answer -eq "YES")) {
			Write-host "Resetting SChannel to the Windows 8,8.1/Server 2012,2012 R2 OS default values. . ."
			Remove-Item -path $schannel -Recurse
			Remove-Item -path $gp00010002 -Recurse
			Remove-Item -path $local00010002 -Recurse
			Remove-Item -path $local00010003 -Recurse
			New-Item -path $schannel
			New-Item -path $scciphers
			New-Item -path $scciphersuites
			New-Item -path $schashes
			New-Item -path $sckeyexchangealgo
			New-Item -path $scprotocols
			New-Item -path $protocolsSSL20
			New-Item -path $ssl20clientpath
			New-Item -path $local00010002
			New-Item -path $local00010003
			New-ItemProperty -path $local00010002ssl -Name "Flags" -PropertyType "DWord" -Value 1 -Force
			New-ItemProperty -path $schannel -Name "EventLogging" -PropertyType "DWord" -Value 1 -Force
			New-ItemProperty -path $local00010002 -Name "(Default)" -PropertyType "String" -Value "NCRYPT_SCHANNEL_INTERFACE" -Force
			New-ItemProperty -path $local00010002 -Name "Functions" -PropertyType "MultiString" -Value $20120102 -Force 
			New-ItemProperty -path $local00010003 -Name "(Default)" -PropertyType "String" -Value "NCRYPT_SCHANNEL_SIGNATURE_INTERFACE" -Force
			New-ItemProperty -path $local00010003 -Name "Functions" -PropertyType "MultiString" -Value $20120103 -Force 
			New-ItemProperty -path $ssl20clientpath -Name DisabledByDefault -PropertyType "DWord" -Value 1 -Force
            $IsKBInstalled = get-hotfix -id "kb3140245" -EA SilentlyContinue
            If ($IsKBInstalled.HotFixID -eq "KB3140245") {
                Write-host "WARNING! Hotfix is installed that changes the OS Defaults to TLS 1.1 and 1.2 only for WinHTTP connections.`r"
                Add-Content .\result.txt -value "WARNING! Hotfix is installed that changes the OS Defaults to TLS 1.1 and 1.2 only for WinHTTP connections.`r"
                Write-host "TLS 1.0 will still be enabled for other connection types, but not for WinHTTP Connections.`r"
                Add-Content .\result.txt -value "TLS 1.0 will still be enabled for other connection types, but not for WinHTTP Connections.`r"
                Write-host "If applications that use TLS 1.0 over WinHTTP, You must change the below RegKey to 0xa80 to re-enable TLS 1.0:`r"
                Add-Content .\result.txt -value "If applications that use TLS 1.0 over WinHTTP, You must change the below RegKey to 0xa80 to re-enable TLS 1.0:`r"
                Write-host "HKLM:\\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp\DefaultSecureProtocols`r"
                Add-Content .\result.txt -value "HKLM:\\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp\DefaultSecureProtocols`r"
                Write-host "If x64, also add to: HKLM:\\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttpDefaultSecureProtocols`r`n"
                Add-Content .\result.txt -value "If x64, also add to: HKLM:\\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp\DefaultSecureProtocols`r`n"
                $SetTLS10WinHttp = Read-Host "Do you want to automatically enable TLS 1.0? (y/n)"
                If (($SetTLS10WinHttp -eq "yes") -or ($SetTLS10WinHttp -eq "Yes") -or ($SetTLS10WinHttp -eq "Y") -or ($SetTLS10WinHttp -eq "y") -or ($SetTLS10WinHttp -eq "YES")) {

                    If($isX64 -eq "True") {
                        Remove-Item -path $WinHttpDefaultSecureProtocols -Recurse
                        Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                        New-Item -path $WinHttpDefaultSecureProtocols
                        New-Item -path $X32WinHttpDefaultSecureProtocols
                        New-ItemProperty -path $WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                        New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                        Write-host "TLS 1.0 is enabled with the Patch installed.`r`n"
                        Add-Content .\result.txt -value "TLS 1.0 is enabled with the Patch installed`r`n"
                    }
                    Else {
                        Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                        New-Item -path $X32WinHttpDefaultSecureProtocols
                        New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                        Write-host "TLS 1.0 is enabled with the Patch installed`r`n"
                        Add-Content .\result.txt -value "TLS 1.0 is enabled with the Patch installed`r`n"
                    }
                    
                }
                Else {

                    If($isX64 -eq "True") {
                        Remove-Item -path $WinHttpDefaultSecureProtocols -Recurse
                        Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                        New-Item -path $WinHttpDefaultSecureProtocols
                        New-Item -path $X32WinHttpDefaultSecureProtocols
                        New-ItemProperty -path $WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2560" -Force
                        New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2560" -Force
                        Write-host "TLS 1.0 is disabled with the Patch installed`r`n"
                        Add-Content .\result.txt -value "TLS 1.0 is disabled with the Patch installed`r`n"
                    }
                    Else {
                        Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                        New-Item -path $X32WinHttpDefaultSecureProtocols
                        New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2560" -Force
                        Write-host "TLS 1.0 is disabled with the Patch installed`r`n"
                        Add-Content .\result.txt -value "TLS 1.0 is disabled with the Patch installed`r`n"
                    }
                }
            }
            Else {
                Write-host "KB3140245 is not installed.  WinHTTP has not been patched for enabling only TLS 1.1 and 1.2. This is okay."
                Add-Content .\result.txt -value "KB3140245 is not installed.  WinHTTP has not been patched for enabling only TLS 1.1 and 1.2. This is okay."
                Write-host "Do not install KB3140245 if 2003 is still in use in the AD Environment.`r"
                Add-Content .\result.txt -value "Do not install KB3140245 if 2003 is still in use in the AD Environment.`r"
            }
			Write-Host "SChannel Reset to defaults, rebooting machine in 10 seconds.  Ctrl+C to cancel."
			Start-sleep -s 10
			Shutdown.exe -f -r -t 00			
		}
		Else {
			Write-host "You have not accepted the terms.  Closing script."
			exit 0
		}
	}
	ElseIf ($osversionMajor -eq 6 -And $osversionMinor -eq 3) {
		Write-host "This will blanket reset all SChannel Settings back to Windows 8.1/Server 2012 R2 defaults and requires a reboot."
		$answer = Read-host "Selecting 'y' now will automatically reset and reboot the machine now.  Do you accept? (y/n)"
		If (($answer -eq "yes") -or ($answer -eq "Yes") -or ($answer -eq "Y") -or ($answer -eq "y") -or ($answer -eq "YES")) {
			Write-host "Resetting SChannel to the Windows 8.1/Server 2012 R2 OS default values. . ."
			Remove-Item -path $schannel -Recurse
			Remove-Item -path $gp00010002 -Recurse
			Remove-Item -path $local00010002 -Recurse
			Remove-Item -path $local00010003 -Recurse
			New-Item -path $schannel
			New-Item -path $scciphers
			New-Item -path $scciphersuites
			New-Item -path $schashes
			New-Item -path $sckeyexchangealgo
			New-Item -path $scprotocols
			New-Item -path $protocolsSSL20
			New-Item -path $ssl20clientpath
			New-Item -path $local00010002
			New-Item -path $local00010003
			New-ItemProperty -path $local00010002ssl -Name "Flags" -PropertyType "DWord" -Value 1 -Force
			New-ItemProperty -path $schannel -Name "EventLogging" -PropertyType "DWord" -Value 1 -Force
			New-ItemProperty -path $local00010002 -Name "(Default)" -PropertyType "String" -Value "NCRYPT_SCHANNEL_INTERFACE" -Force
			New-ItemProperty -path $local00010002 -Name "Functions" -PropertyType "MultiString" -Value $2012R20102 -Force 
			New-ItemProperty -path $local00010003 -Name "(Default)" -PropertyType "String" -Value "NCRYPT_SCHANNEL_SIGNATURE_INTERFACE" -Force
			New-ItemProperty -path $local00010003 -Name "Functions" -PropertyType "MultiString" -Value $2012R20103 -Force
			New-ItemProperty -path $ssl20clientpath -Name DisabledByDefault -PropertyType "DWord" -Value 1 -Force
            If($isX64 -eq "True") {
                Remove-Item -path $WinHttpDefaultSecureProtocols -Recurse
                Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                New-Item -path $WinHttpDefaultSecureProtocols
                New-Item -path $X32WinHttpDefaultSecureProtocols
                New-ItemProperty -path $WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                Write-host "TLS 1.0 is enabled for WinHTTP.`r`n"
                Add-Content .\result.txt -value "TLS 1.0 is enabled for WinHTTP.`r`n"
            }
            Else {
                Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                New-Item -path $X32WinHttpDefaultSecureProtocols
                New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                Write-host "TLS 1.0 is enabled for WinHTTP.`r`n"
                Add-Content .\result.txt -value "TLS 1.0 is enabled for WinHTTP.`r`n"
            }
			Write-Host "SChannel Reset to defaults, rebooting machine in 10 seconds.  Ctrl+C to cancel."
			Start-sleep -s 10
			Shutdown.exe -f -r -t 00	
		}
		Else {
			Write-host "You have not accepted the terms.  Closing script."
			exit 0
		}
	}
	ElseIf ($osversionMajor -eq 10 -And $osversionMinor -eq 0) {
		Write-host "This will blanket reset all SChannel Settings back to Windows 10/Server 2016 defaults and requires a reboot."
		$answer = Read-host "Selecting 'y' now will automatically reset and reboot the machine now.  Do you accept? (y/n)"
		If (($answer -eq "yes") -or ($answer -eq "Yes") -or ($answer -eq "Y") -or ($answer -eq "y") -or ($answer -eq "YES")) {
			Write-host "Resetting SChannel to the Win10/Server2016 OS default values. . ."
			Remove-Item -path $schannel -Recurse
			Remove-Item -path $gp00010002 -Recurse
			Remove-Item -path $local00010002 -Recurse
			Remove-Item -path $local00010003 -Recurse
			New-Item -path $schannel
			New-Item -path $scciphers
			New-Item -path $scciphersuites
			New-Item -path $schashes
			New-Item -path $sckeyexchangealgo
			New-Item -path $scprotocols
			New-Item -path $protocolsSSL20
			New-Item -path $ssl20clientpath
			New-Item -path $local00010002
			New-Item -path $local00010003
			New-ItemProperty -path $local00010002ssl -Name "Flags" -PropertyType "DWord" -Value 1 -Force
			New-ItemProperty -path $schannel -Name "EventLogging" -PropertyType "DWord" -Value 1 -Force
			New-ItemProperty -path $local00010002 -Name "(Default)" -PropertyType "String" -Value "NCRYPT_SCHANNEL_INTERFACE" -Force
			New-ItemProperty -path $local00010002 -Name "EccCurves" -PropertyType "MultiString" -Value $10ecccurves -Force 
			New-ItemProperty -path $local00010002 -Name "Functions" -PropertyType "MultiString" -Value $100102 -Force 
			New-ItemProperty -path $local00010003 -Name "(Default)" -PropertyType "String" -Value "NCRYPT_SCHANNEL_SIGNATURE_INTERFACE" -Force
			New-ItemProperty -path $local00010003 -Name "Functions" -PropertyType "MultiString" -Value $100103 -Force
			New-ItemProperty -path $ssl20clientpath -Name DisabledByDefault -PropertyType "DWord" -Value 1 -Force
            If($isX64 -eq "True") {
                Remove-Item -path $WinHttpDefaultSecureProtocols -Recurse
                Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                New-Item -path $WinHttpDefaultSecureProtocols
                New-Item -path $X32WinHttpDefaultSecureProtocols
                New-ItemProperty -path $WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                Write-host "TLS 1.0 is enabled for WinHTTP.`r`n"
                Add-Content .\result.txt -value "TLS 1.0 is enabled for WinHTTP.`r`n"
            }
            Else {
                Remove-Item -path $X32WinHttpDefaultSecureProtocols -Recurse
                New-Item -path $X32WinHttpDefaultSecureProtocols
                New-ItemProperty -path $X32WinHttpDefaultSecureProtocols -Name "DefaultSecureProtocols" -PropertyType "DWord" -Value "2688" -Force
                Write-host "TLS 1.0 is enabled for WinHTTP.`r`n"
                Add-Content .\result.txt -value "TLS 1.0 is enabled for WinHTTP.`r`n"
            }
			Write-Host "SChannel Reset to defaults, rebooting machine in 10 seconds.  Ctrl+C to cancel."
			Start-sleep -s 10
			Shutdown.exe -f -r -t 00	
		}
		Else {
			Write-host "You have not accepted the terms.  Closing script."
			exit 0
		}
	}
	Else {
		write-host "This tool is not supported on your current OS."
		Add-Content .\result.txt -value "This tool is not supported on your current OS."
		exit 0
	}
}
Else{
		
Write-host " "
If ($osversionMajor -eq 6 -And $osversionMinor -eq 0) {
    Write-host "[Hostname] = $hostname`r"
	Add-Content .\result.txt -value "[Hostname] = $hostname`r"
    Write-host "[Machine Version] = Windows Vista or Server 2008`r"
	Add-Content .\result.txt -value "[Machine Version] = Windows Vista or Server 2008`r"
    if ([System.IntPtr]::Size -eq 4) {
        Write-host "[Architecture] = 32-bit`r`n`n"
        Add-Content .\result.txt -value "[Architecture] = 32-bit`r`n`n" 
    } 
    else {
        Write-host "[Architecture] = 64-bit"
        Add-Content .\result.txt -value "[Architecture] = 64-bit"
    }
    Write-host "[Client Keys]`r`n"
	Add-Content .\result.txt -value "[Client Keys]`r`n"

    $ssl20CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
    If ($ssl20CTest -eq "True") {
        $ssl20C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
        If($ssl20C.DisabledByDefault -eq $null) {
            Write-host "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl20CH = $ssl20C.DisabledByDefault
            Write-host "SSL 2.0: DisabledByDefault: $ssl20CH`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: $ssl20CH`r"
        }
        If($ssl20C.Enabled -eq $null) {
            Write-host "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
			Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl20CH = $ssl20C.Enabled
            Write-host "SSL 2.0: Enabled: $ssl20CH`r`n"
			Add-Content .\result.txt -value "SSL 2.0: Enabled: $ssl20CH`r`n"
        }
    }
    Else {
        Write-host "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
		Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
    }   
    $ssl30CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
    If ($ssl30CTest -eq "True") {
        $ssl30C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
        If($ssl30C.DisabledByDefault -eq $null) {
            Write-host "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl30CH = $ssl30C.DisabledByDefault
            Write-host "SSL 3.0: DisabledByDefault: $ssl20CH`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: $ssl20CH`r"
        }
        If($ssl30C.Enabled -eq $null) {
            Write-host "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
			Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl30CH = $ssl30C.Enabled
            Write-host "SSL 3.0: Enabled: $ssl30CH`r`n"
			Add-Content .\result.txt -value "SSL 3.0: Enabled: $ssl30CH`r`n"
        }
    }
    Else {
        Write-host "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $tls10CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
    If ($tls10CTest -eq "True") {
        $tls10C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
        If($tls10C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls10CH = $tls10C.DisabledByDefault
            Write-host "TLS 1.0: DisabledByDefault: $tls10CH`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: $tls10CH`r"
        }
        If($tls10C.Enabled -eq $null) {
            Write-host "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls10CH = $tls10C.Enabled
            Write-host "TLS 1.0: Enabled: $tls10CH`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: $tls10CH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls11CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
    If ($tls11CTest -eq "True") {
        $tls11C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
        If($tls11C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.1: DisabledByDefault: Not Applicable / Not Supported.`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: Not Applicable / Not Supported.`r"
        }
        Else {
            $tls11CH = $tls11C.DisabledByDefault
            Write-host "TLS 1.1: DisabledByDefault: $tls11CH, Value was set manually, but is not supported!`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: $tls11CH, Value was set manually, but is not supported!`r"
        }
        If($tls11C.Enabled -eq $null) {
            Write-host "TLS 1.1: Enabled: Not Applicable / Not Supported.`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: Not Applicable / Not Supported.`r`n"
        }
        Else {
            $tls11CH = $tls11C.Enabled
            Write-host "TLS 1.1: Enabled: $tls11CH, Value was set manually, but is not supported!`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: $tls11CH, Value was set manually, but is not supported!`r`n"
        }
    }
    Else {
        Write-host "TLS 1.1: DisabledByDefault: Not Applicable / Not Supported.`r"
		Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: Not Applicable / Not Supported.`r"
        Write-host "TLS 1.1: Enabled: Not Applicable / Not Supported.`r`n"
        Add-Content .\result.txt -value "TLS 1.1: Enabled: Not Applicable / Not Supported.`r`n"
    }
    $tls12CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
    If ($tls12CTest -eq "True") {
        $tls12C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
        If($tls12C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.2: DisabledByDefault: Not Applicable / Not Supported.`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: Not Applicable / Not Supported.`r"
        }
        Else {
            $tls12CH = $tls12C.DisabledByDefault
            Write-host "TLS 1.2: DisabledByDefault: $tls12CH, Value was set manually, but not supported!`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: $tls12CH, Value was set manually, but not supported!`r"
        }
        If($tls12C.Enabled -eq $null) {
            Write-host "TLS 1.2: Enabled: Not Applicable / Not Supported.`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: Not Applicable / Not Supported.`r`n`n"
        }
        Else {
            $tls12CH = $tls12C.Enabled
            Write-host "TLS 1.2: Enabled: $tls12CH, Value was set manually, but not supported!`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: $tls12CH, Value was set manually, but not supported!`r`n`n"
        }
    }
    Else {
        Write-host "TLS 1.2: DisabledByDefault: Not Applicable / Not Supported.`r"
		Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: Not Applicable / Not Supported.`r"
        Write-host "TLS 1.2: Enabled: Not Applicable / Not Supported.`r`n`n"
        Add-Content .\result.txt -value "TLS 1.2: Enabled: Not Applicable / Not Supported.`r`n`n"
    }

    Write-host "[Server Keys]`r`n"
    Add-Content .\result.txt -value "[Server Keys]`r`n"
    $ssl20STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
    If ($ssl20STest -eq "True") {
        $ssl20S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
        If($ssl20S.DisabledByDefault -eq $null) {
            Write-host "SSL 2.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl20SH = $ssl20S.DisabledByDefault
            Write-host "SSL 2.0: DisabledByDefault: $ssl20SH`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: $ssl20SH`r"
        }
        If($ssl20S.Enabled -eq $null) {
            Write-host "SSL 2.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl20SH = $ssl20S.Enabled
            Write-host "SSL 2.0: Enabled: $ssl20SH`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: $ssl20SH`r`n"
        }
    }
    Else {
        Write-host "SSL 2.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 2.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 2.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $ssl30STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
    If ($ssl30STest -eq "True") {
        $ssl30S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
        If($ssl30S.DisabledByDefault -eq $null) {
            Write-host "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl30SH = $ssl30S.DisabledByDefault
            Write-host "SSL 3.0: DisabledByDefaut: $ssl30SH`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefaut: $ssl30SH`r"
        }
        If($ssl30S.Enabled -eq $null) {
            Write-host "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl30SH = $ssl30S.Enabled
            Write-host "SSL 3.0: Enabled: $ssl30SH`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: $ssl30SH`r`n"
        }
    }
    Else {
        Write-host "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $tls10STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
    If ($tls10STest -eq "True") {
        $tls10S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
        If($tls10S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls10SH = $tls10S.DisabledByDefault
            Write-host "TLS 1.0: DisabledByDefault: $tls10SH`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: $tls10SH`r"
        }
        If($tls10S.Enabled -eq $null) {
            Write-host "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls10SH = $tls10S.Enabled
            Write-host "TLS 1.0: Enabled: $tls10SH`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: $tls10SH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls11STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
    If ($tls11STest -eq "True") {
        $tls11S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
        If($tls11S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.1: DisabledByDefault: Not Applicable / Not Supported.`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: Not Applicable / Not Supported.`r"
        }
        Else {
            $tls11SH = $tls11S.DisabledByDefault
            Write-host "TLS 1.1: DisabledByDefault: $tls11SH, Value was set manually, but not supported!`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: $tls11SH, Value was set manually, but not supported!`r"
        }
        If($tls11S.Enabled -eq $null) {
            Write-host "TLS 1.1: Enabled: Not Applicable / Not Supported.`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: Not Applicable / Not Supported.`r`n"
        }
        Else {
            $tls11SH = $tls11S.Enabled
            Write-host "TLS 1.1: Enabled: $tls11SH, Value was set manually, but not supported!`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: $tls11SH, Value was set manually, but not supported!`r`n"
        }
    }
    Else {
        Write-host "TLS 1.1: DisabledByDefault: Not Applicable / Not Supported.`r"
		Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: Not Applicable / Not Supported.`r"
        Write-host "TLS 1.1: Enabled: Not Applicable / Not Supported.`r`n"
        Add-Content .\result.txt -value "TLS 1.1: Enabled: Not Applicable / Not Supported.`r`n"
    }
    $tls12STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
    If ($tls12STest -eq "True") {
        $tls12S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
        If($tls12S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.2: Not Applicable / Not Supported.`r"
            Add-Content .\result.txt -value "TLS 1.2: Not Applicable / Not Supported.`r"
        }
        Else {
            $tls12SH = $tls12S.DisabledByDefault
            Write-host "TLS 1.2: DisabledByDefault: $tls12SH, Value was set manually, but not supported!`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: $tls12SH, Value was set manually, but not supported!`r"
        }
        If($tls12S.Enabled -eq $null) {
            Write-host "TLS 1.2: Not Applicable / Not Supported.`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Not Applicable / Not Supported.`r`n`n"
        }
        Else {
            $tls12SH = $tls12S.Enabled
            Write-host "TLS 1.2: Enabled: $tls12SH, Value set manually, but not supported!`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: $tls12SH, Value set manually, but not supported!`r`n`n"
        }
    }
    Else {
        Write-host "TLS 1.2: DisabledByDefault: Not Applicable / Not Supported.`r"
		Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: Not Applicable / Not Supported.`r"
        Write-host "TLS 1.2: Enabled: Not Applicable / Not Supported.`r`n`n"
        Add-Content .\result.txt -value "TLS 1.2: Enabled: Not Applicable / Not Supported.`r`n`n"
    }
    Write-Host "[KeyExchangeAlgorithms]`r`n"
    Add-Content .\result.txt -value "[KeyExchangeAlgorithms]`r`n"
    $keyExchangeAlgo = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms"
    If( $keyExchangeAlgo -eq "True" ) {
        $PKCS = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\PKCS"
        If( $PKCS -eq "True" ) {
            $PKCSE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\PKCS"
        
            If ( $PKCSE.Enabled -eq $null ) {
                Write-Host "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed.  Value not set.`r`n`n"
                Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed.  Value not set.`r`n`n"
            }
            ElseIf( $PKCSE.Enabled -eq 0 ) {
                Write-Host "WARNING!!! PKCS is disabled.  No RSA-based SSL and TLS cipher suites will be allowed!`r`n`n"
                Add-Content .\result.txt -value "WARNING!!! PKCS is disabled.  No RSA-based SSL and TLS cipher suites will be allowed!`r`n`n"
            }
            Else {
                $PKCSEH = $PKCSE.Enabled
                $PKCSEHex = "{0:x8}" -f $PKCSEH
                Write-Host "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed. Value set to: 0x$PKCSEHex`r`n`n"
                Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed. Value set to: 0x$PKCSEHex`r`n`n"
            }
        }
        Else {
            Write-host "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
            Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
        }
    }
    Else {
       Write-host "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
       Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
    }
    Write-Host "[Hashes]`r`n"
    Add-Content .\result.txt -value "[Hashes]`r`n"
    $md5 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5"
    If( $md5 -eq "True" ) {
        $md5E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5\"
        If ( $md5E.Enabled -eq $null ) {
            Write-Host "MD5 Cipher Hashes are enabled. Value not set.`r"
            Add-Content .\result.txt -value "MD5 Cipher Hashes are enabled. Value not set.`r"
        }
        ElseIf( $md5E.Enabled -eq 0 ) {
            Write-Host "WARNING!!! MD5 based Cipher Suites have been disabled!`r"
            Add-Content .\result.txt -value "WARNING!!! MD5 based Cipher Suites have been disabled!`r"
        }
        Else {
            $md5EH = $md5E.Enabled
            $md5EHex = "{0:x8}" -f $md5EH
            Write-Host "Md5 Cipher Hashes are enabled.  Value set to: 0x$md5EHex`r"
			Add-Content .\result.txt -value "Md5 Cipher Hashes are enabled.  Value set to: 0x$md5EHex`r"
        }
    }
    Else {
       Write-host "MD5 Cipher Hashes are enabled.  Reg Key not present.`r"
       Add-Content .\result.txt -value "MD5 Cipher Hashes are enabled.  Reg Key not present.`r"
    }
    $SHA = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA"
    If( $SHA -eq "True" ) {
        $SHAE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA"
        If ( $SHAE.Enabled -eq $null ) {
            Write-Host "SHA-1 Cipher Hashes are enabled. Value not set.`r`n`n"
            Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled. Value not set.`r`n`n"
        }
        ElseIf( $SHAE.Enabled -eq 0 ) {
            Write-Host "WARNING!!! SHA-1 based Cipher Suites have been disabled!`r`n`n"
            Add-Content .\result.txt -value "WARNING!!! SHA-1 based Cipher Suites have been disabled!`r`n`n"
        }
        Else {
            $SHAEH = $SHAE.Enabled
            $SHAEHex = "{0:x8}" -f $SHAEH
            Write-Host "SHA-1 Cipher Hashes are enabled.  Value set to: 0x$SHAEHex`r`n`n"
            Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled.  Value set to: 0x$SHAEHex`r`n`n"
        }
    }
    Else {
       Write-host "SHA-1 Cipher Hashes are enabled.  Reg Key not present.`r`n`n"
       Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled.  Reg Key not present.`r`n`n"
    }
    Write-host "[Cipher Suites]`r`n"
    Add-Content .\result.txt -value "[Cipher Suites]`r`n"
    $nullValue = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL"
    if ($nullValue -eq "True") {
        $nullValueE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL"
        If($nullValueE.Enabled -eq $null -Or $nullValueE.Enabled -eq 0) {
            Write-host "Null is not set. Cipher Suites can be used.`r`n"
            Add-Content .\result.txt -value "Null is not set. Cipher Suites can be used.`r`n"
            $cipherAES256 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
            If ($cipherAES256 -eq "True") {
                $cipherAES256E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
                If($cipherAES256E.Enabled -eq $null) {
                    Write-host "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherAES256EH = $cipherAES256E.Enabled
                    Write-host "AES 256: Enabled: $ciperAES256EH`r"
					Add-Content .\result.txt -value "AES 256: Enabled: $ciperAES256EH`r"
                }
            }
            Else {
                Write-host "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherAES128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
            If ($cipherAES128 -eq "True") {
                $cipherAES128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
                If($cipherAES128E.Enabled -eq $null) {
                    Write-host "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherAES128EH = $cipherAES128E.Enabled
                    Write-host "AES 128: Enabled: $ciperAES128EH`r"
					Add-Content .\result.txt -value "AES 128: Enabled: $ciperAES128EH`r"
                }
            }
            Else {
                Write-host "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherDES56 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
            If ($cipherDES56 -eq "True") {
                $cipherDES56E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
                If($cipherDES56E.Enabled -eq $null) {
                    Write-host "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherDES56EH = $cipherDES56E.Enabled
                    Write-host "DES 56: Enabled: $ciperDES56EH`r"
					Add-Content .\result.txt -value "DES 56: Enabled: $ciperDES56EH`r"
                }
            }
            Else {
                Write-host "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC4128128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
            If ($cipherRC4128128 -eq "True") {
                $cipherRC4128128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
                If($cipherRC4128128E.Enabled -eq $null) {
                    Write-host "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC4128128EH = $cipherRC4128128E.Enabled
                    Write-host "RC4 128/128: Enabled: $ciperRC4128128EH`r"
					Add-Content .\result.txt -value "RC4 128/128: Enabled: $ciperRC4128128EH`r"
                }
            }
            Else {
                Write-host "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC464 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
            If ($cipherRC464 -eq "True") {
                $cipherRC464E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
                If($cipherRC464E.Enabled -eq $null) {
                    Write-host "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC464EH = $cipherRC464E.Enabled
                    Write-host "RC4 64/128: Enabled: $ciperRC464EH`r"
					Add-Content .\result.txt -value "RC4 64/128: Enabled: $ciperRC464EH`r"
                }
            }
            Else {
                Write-host "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC456 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
            If ($cipherRC456 -eq "True") {
                $cipherRC456E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
                If($cipherRC456E.Enabled -eq $null) {
                    Write-host "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC456EH = $cipherRC456E.Enabled
                    Write-host "RC4 56/128: Enabled: $ciperRC456EH`r"
					Add-Content .\result.txt -value "RC4 56/128: Enabled: $ciperRC456EH`r"
                }
            }
            Else {
                Write-host "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC440 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
            If ($cipherRC440 -eq "True") {
                $cipherRC440E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
                If($cipherRC440E.Enabled -eq $null) {
                    Write-host "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC440EH = $cipherRC440E.Enabled
                    Write-host "RC4 40/128: Enabled: $ciperRC440EH`r"
					Add-Content .\result.txt -value "RC4 40/128: Enabled: $ciperRC440EH`r"
                }
            }
            Else {
                Write-host "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipher3DES168 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
            If ($cipher3DES168 -eq "True") {
                $cipher3DES168E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
                If($cipher3DES168E.Enabled -eq $null) {
                    Write-host "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipher3DES168EH = $cipher3DES168E.Enabled
                    Write-host "Triple DES 168: Enabled: $ciper3DES168EH`r"
					Add-Content .\result.txt -value "Triple DES 168: Enabled: $ciper3DES168EH`r"
                }
            }
            Else {
                Write-host "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC2128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
            If ($cipherRC2128 -eq "True") {
                $cipherRC2128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
                If($cipherRC2128E.Enabled -eq $null) {
                    Write-host "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC2128EH = $cipherRC2128E.Enabled
                    Write-host "RC2 128/128: Enabled: $ciperRC2128EH`r"
					Add-Content .\result.txt -value "RC2 128/128: Enabled: $ciperRC2128EH`r"
                }
            }
            Else {
                Write-host "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC256128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
            If ($cipherRC256128 -eq "True") {
                $cipherRC256128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
                If($cipherRC256128E.Enabled -eq $null) {
                    Write-host "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC256128EH = $cipherRC256128E.Enabled
                    Write-host "RC2 56/128: Enabled: $ciperRC256128EH`r"
					Add-Content .\result.txt -value "RC2 56/128: Enabled: $ciperRC256128EH`r"
                }
            }
            Else {
                Write-host "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC240128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
            If ($cipherRC240128 -eq "True") {
                $cipherRC240128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
                If($cipherRC240128E.Enabled -eq $null) {
                    Write-host "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC240128EH = $cipherRC240128E.Enabled
                    Write-host "RC2 40/128: Enabled: $ciperRC240128EH`r"
					Add-Content .\result.txt -value "RC2 40/128: Enabled: $ciperRC240128EH`r"
                }
            }
            Else {
                Write-host "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC25656 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
            If ($cipherRC25656 -eq "True") {
                $cipherRC25656E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
                If($cipherRC25656E.Enabled -eq $null) {
                    Write-host "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
					Add-Content .\result.txt -value "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
                }
                Else {
                    $cipherRC25656EH = $cipherRC25656E.Enabled
                    Write-host "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
					Add-Content .\result.txt -value "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
                }
            }
            Else {
                Write-host "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
                Add-Content .\result.txt -value "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
            }
			Write-host "[00010002 Group Policy Cipher Reg Key Values]`r`n"
			Add-Content .\result.txt -value "[00010002 Group Policy Cipher Reg Key Values]`r`n"
			$cryptSSLGTest = Test-path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
			If ($cryptSSLGTest -eq "True") {
				If ($cryptSSLGTest.EccCurves -eq $null -And $cryptSSLG.Functions -eq $null){
					Write-Host "Group Policy is not set.  Local values will be used listed below.`r`n`n"
					Add-Content .\result.txt -value "Group Policy is not set.  Local values will be used listed below.`r`n`n"
					Write-host "[00010002 Local Cipher Reg Key Values]`r`n"
					Add-Content .\result.txt -value "[00010002 Local Cipher Reg Key Values]`r`n"
					$cryptSSLTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
					If ($cryptSSLTest -eq "True") {
						$cryptSSL = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
						If($cryptSSL.EccCurves -eq $null) {
							Write-host "EccCurves: Value is NULL!`r`n"
							Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
						}
						Else {
							$cryptSSLH = $cryptSSL.EccCurves
							Write-host "EccCurves: $cryptSSLH`r`n"
							Add-Content .\result.txt -value "EccCurves: $cryptSSLH`r`n"
						}
						If($cryptSSL.Functions -eq $null) {
							Write-host "Functions: Value is NULL!`r`n`n"
							Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
						}
						Else {
							$cryptSSLF = $cryptSSL.Functions
							Write-host "Functions: $cryptSSLF`r`n`n"
							Add-Content .\result.txt -value "Functions: $cryptSSLF`r`n`n"
						}
					}
					Else {
						Write-host "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
						Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
					}
				}
				Else {
					$cryptSSLG = Get-ItemProperty -path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
					If($cryptSSLG.EccCurves -eq $null) {
						Write-host "EccCurves: Value is NULL!`r`n"
						Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
					}
					Else {
						$cryptSSLGH = $cryptSSL.EccCurves
						Write-host "EccCurves: $cryptSSLGH`r`n"
						Add-Content .\result.txt -value "EccCurves: $cryptSSLGH`r`n"
					}
					If($cryptSSLG.Functions -eq $null) {
						Write-host "Functions: Value is NULL!`r`n`n"
						Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
					}
					Else {
						$cryptSSLGF = $cryptSSL.Functions
						Write-host "Functions: $cryptSSLGF`r`n`n"
						Add-Content .\result.txt -value "Functions: $cryptSSLGF`r`n`n"
					}
				}
			}
			Else {
				Write-host "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
				Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
			}
        }
        Else {
            $nullValueEH = $nullValueE.Enabled
            Write-Host "WARNING!!!  NULL is enabled!  No Cipher Suites are enabled regardless of Reg Key Set or Not!`r`n`n"
			Add-Content .\result.txt -value "WARNING!!!  NULL is enabled!  No Cipher Suites are enabled regardless of Reg Key Set or Not!`r`n`n"
        }
    }
    Else {
        Write-host "Null Reg Key not present.  Cipher Suites can be used.`r`n"
        Add-Content .\result.txt -value "Null Reg Key not present.  Cipher Suites can be used.`r`n"
        $cipherAES256 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
        If ($cipherAES256 -eq "True") {
            $cipherAES256E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
            If($cipherAES256E.Enabled -eq $null) {
                Write-host "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherAES256EH = $cipherAES256E.Enabled
                Write-host "AES 256: Enabled: $ciperAES256EH`r"
				Add-Content .\result.txt -value "AES 256: Enabled: $ciperAES256EH`r"
            }
        }
        Else {
            Write-host "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherAES128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
        If ($cipherAES128 -eq "True") {
            $cipherAES128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
            If($cipherAES128E.Enabled -eq $null) {
                Write-host "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherAES128EH = $cipherAES128E.Enabled
                Write-host "AES 128: Enabled: $ciperAES128EH`r"
				Add-Content .\result.txt -value "AES 128: Enabled: $ciperAES128EH`r"
            }
        }
        Else {
            Write-host "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherDES56 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
        If ($cipherDES56 -eq "True") {
            $cipherDES56E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
            If($cipherDES56E.Enabled -eq $null) {
                Write-host "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherDES56EH = $cipherDES56E.Enabled
                Write-host "DES 56: Enabled: $ciperDES56EH`r"
				Add-Content .\result.txt -value "DES 56: Enabled: $ciperDES56EH`r"
            }
        }
        Else {
            Write-host "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC4128128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
        If ($cipherRC4128128 -eq "True") {
            $cipherRC4128128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
            If($cipherRC4128128E.Enabled -eq $null) {
                Write-host "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC4128128EH = $cipherRC4128128E.Enabled
                Write-host "RC4 128/128: Enabled: $ciperRC4128128EH`r"
				Add-Content .\result.txt -value "RC4 128/128: Enabled: $ciperRC4128128EH`r"
            }
        }
        Else {
            Write-host "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC464 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
        If ($cipherRC464 -eq "True") {
            $cipherRC464E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
            If($cipherRC464E.Enabled -eq $null) {
                Write-host "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC464EH = $cipherRC464E.Enabled
                Write-host "RC4 64/128: Enabled: $ciperRC464EH`r"
				Add-Content .\result.txt -value "RC4 64/128: Enabled: $ciperRC464EH`r"
            }
        }
        Else {
            Write-host "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC456 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
        If ($cipherRC456 -eq "True") {
            $cipherRC456E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
            If($cipherRC456E.Enabled -eq $null) {
                Write-host "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC456EH = $cipherRC456E.Enabled
                Write-host "RC4 56/128: Enabled: $ciperRC456EH`r"
				Add-Content .\result.txt -value "RC4 56/128: Enabled: $ciperRC456EH`r"
            }
        }
        Else {
            Write-host "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC440 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
        If ($cipherRC440 -eq "True") {
            $cipherRC440E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
            If($cipherRC440E.Enabled -eq $null) {
                Write-host "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC440EH = $cipherRC440E.Enabled
                Write-host "RC4 40/128: Enabled: $ciperRC440EH`r"
				Add-Content .\result.txt -value "RC4 40/128: Enabled: $ciperRC440EH`r"
            }
        }
        Else {
            Write-host "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipher3DES168 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
        If ($cipher3DES168 -eq "True") {
            $cipher3DES168E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
            If($cipher3DES168E.Enabled -eq $null) {
                Write-host "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipher3DES168EH = $cipher3DES168E.Enabled
                Write-host "Triple DES 168: Enabled: $ciper3DES168EH`r"
				Add-Content .\result.txt -value "Triple DES 168: Enabled: $ciper3DES168EH`r"
            }
        }
        Else {
            Write-host "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC2128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
        If ($cipherRC2128 -eq "True") {
            $cipherRC2128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
            If($cipherRC2128E.Enabled -eq $null) {
                Write-host "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC2128EH = $cipherRC2128E.Enabled
                Write-host "RC2 128/128: Enabled: $ciperRC2128EH`r"
				Add-Content .\result.txt -value "RC2 128/128: Enabled: $ciperRC2128EH`r"
            }
        }
        Else {
            Write-host "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC256128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
        If ($cipherRC256128 -eq "True") {
            $cipherRC256128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
            If($cipherRC256128E.Enabled -eq $null) {
                Write-host "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC256128EH = $cipherRC256128E.Enabled
                Write-host "RC2 56/128: Enabled: $ciperRC256128EH`r"
				Add-Content .\result.txt -value "RC2 56/128: Enabled: $ciperRC256128EH`r"
            }
        }
        Else {
            Write-host "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC240128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
        If ($cipherRC240128 -eq "True") {
            $cipherRC240128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
            If($cipherRC240128E.Enabled -eq $null) {
                Write-host "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC240128EH = $cipherRC240128E.Enabled
                Write-host "RC2 40/128: Enabled: $ciperRC240128EH`r"
				Add-Content .\result.txt -value "RC2 40/128: Enabled: $ciperRC240128EH`r"
            }
        }
        Else {
            Write-host "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC25656 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
        If ($cipherRC25656 -eq "True") {
            $cipherRC25656E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
            If($cipherRC25656E.Enabled -eq $null) {
                Write-host "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
				Add-Content .\result.txt -value "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            }
            Else {
                $cipherRC25656EH = $cipherRC25656E.Enabled
                Write-host "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
				Add-Content .\result.txt -value "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
            }
        }
        Else {
            Write-host "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
            Add-Content .\result.txt -value "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
        }
		Write-host "[00010002 Group Policy Cipher Reg Key Values]`r`n"
		Add-Content .\result.txt -value "[00010002 Group Policy Cipher Reg Key Values]`r`n"
		$cryptSSLGTest = Test-path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
		If ($cryptSSLGTest -eq "True") {
			If ($cryptSSLGTest.EccCurves -eq $null -And $cryptSSLG.Functions -eq $null){
				Write-Host "Group Policy is not set.  Local values will be used listed below.`r`n`n"
				Add-Content .\result.txt -value "Group Policy is not set.  Local values will be used listed below.`r`n`n"
				Write-host "[00010002 Local Cipher Reg Key Values]`r`n"
				Add-Content .\result.txt -value "[00010002 Local Cipher Reg Key Values]`r`n"
				$cryptSSLTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
				If ($cryptSSLTest -eq "True") {
					$cryptSSL = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
					If($cryptSSL.EccCurves -eq $null) {
						Write-host "EccCurves: Value is NULL!`r`n"
						Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
					}
					Else {
						$cryptSSLH = $cryptSSL.EccCurves
						Write-host "EccCurves: $cryptSSLH`r`n"
						Add-Content .\result.txt -value "EccCurves: $cryptSSLH`r`n"
					}
					If($cryptSSL.Functions -eq $null) {
						Write-host "Functions: Value is NULL!`r`n`n"
						Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
					}
					Else {
						$cryptSSLF = $cryptSSL.Functions
						Write-host "Functions: $cryptSSLF`r`n`n"
						Add-Content .\result.txt -value "Functions: $cryptSSLF`r`n`n"
					}
				}
				Else {
					Write-host "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
					Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
				}
			}
			Else {
				$cryptSSLG = Get-ItemProperty -path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
				If($cryptSSLG.EccCurves -eq $null) {
					Write-host "EccCurves: Value is NULL!`r`n"
					Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
				}
				Else {
					$cryptSSLGH = $cryptSSL.EccCurves
					Write-host "EccCurves: $cryptSSLGH`r`n"
					Add-Content .\result.txt -value "EccCurves: $cryptSSLGH`r`n"
				}
				If($cryptSSLG.Functions -eq $null) {
					Write-host "Functions: Value is NULL!"
					Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
				}
				Else {
					$cryptSSLGF = $cryptSSL.Functions
					Write-host "Functions: $cryptSSLGF"
					Add-Content .\result.txt -value "Functions: $cryptSSLGF`r`n`n"
				}
			}
		}
		Else {
			Write-host "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
			Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
		}
    }
	Write-Host "[Fips Algorithm]`r`n"
	Add-Content .\result.txt -value "[Fips Algorithm]`r`n"
	$fipsAlgo = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
    If ($fipsAlgo -eq "True") {
        $fipsAlgoE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
        If($fipsAlgoE.Enabled -eq $null -And $fipsAlgoE.MDMEnabled -eq $null) {
            Write-Host "Disabled! Someone deleted values manually.  Please add REG_DWORD Values: Enabled: 0, MDMEnabled: 0 to correct."
			Add-Content .\result.txt -value "Disabled! Someone deleted values manually.  Please add REG_DWORD Values: Enabled: 0, MDMEnabled: 0 to correct."
        }
        ElseIf ($fipsAlgoE.Enabled -eq 0 -And $fipsAlgoE.MDMEnabled -eq 0){
            $fipsAlgoEH = $fipsAlgoE.Enabled
            Write-Host "Fips and MDM are both Disabled."
			Add-Content .\result.txt -value "Fips and MDM are both Disabled."
        }
		Else {
            If($fipsAlgoE.Enabled -eq $null){
                Write-Host "Fips value set to Null.  Not enabled.`r"
                Add-Content .\result.txt -value "Fips value set to Null. Not enabled.`r"
            }
            Else {
                $fipsAlgoEF = $fipsAlgoE.Enabled
                $fipsAlgoEHex = "{0:x8}" -f $fipsAlgoEF
                Write-Host "Fips Value set to Enabled: 0x$fipsAlgoEHex`r"
			    Add-Content .\result.txt -value "Fips Value set to Enabled: 0x$fipsAlgoEHex`r"
            }

            If($fipsAlgoE.MDMEnabled -eq $null){
                Write-Host "MDMEnabled value is set to Null. Not enabled.`r"
                Add-Content .\result.txt -value "MDMEnabled value is set to Null.  Not enabled.`r"
            }
            Else {
			    $fipsAlgoEC = $fipsAlgoE.MDMEnabled
			    $fipsAlgoECHex = "{0:x8}" -f $fipsAlgoEC
			    Write-Host "MDMEnabled Value set to Enabled: 0x$fipsAlgoECHex"
			    Add-Content .\result.txt -value "MDMEnabled Value set to Enabled: 0x$fipsAlgoECHex"
            }
		}
    }
    Else {
        Write-host "FipsAlgorithmPolicy Reg Key has been removed manually!  Please re-add the Reg Key! HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy]"
        Add-Content .\result.txt -value "FipsAlgorithmPolicy Reg Key has been removed manually!  Please re-add the Reg Key! HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy]"
    }
}
ElseIf ($osversionMajor -eq 6 -And $osversionMinor -eq 1) {
    Write-host "[Hostname] = $hostname`r"
	Add-Content .\result.txt -value "[Hostname] = $hostname`r"
    Write-host "[Machine Version] = Windows 7 or Server 2008 R2`r"
    Add-Content .\result.txt -value "[Machine Version] = Windows 7 or Server 2008 R2`r"
    if ([System.IntPtr]::Size -eq 4) {
        Write-host "[Architecture] = 32-bit`r`n`n"
        Add-Content .\result.txt -value "[Architecture] = 32-bit`r`n`n" 
    } 
    else {
        Write-host "[Architecture] = 64-bit`r`n`n"
        Add-Content .\result.txt -value "[Architecture] = 64-bit`r`n`n"
    }
    Write-host "[Client Keys]`r`n"
    Add-Content .\result.txt -value "[Client Keys]`r`n"

    $ssl20CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
    If ($ssl20CTest -eq "True") {
        $ssl20C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
        If($ssl20C.DisabledByDefault -eq $null) {
            Write-host "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl20CH = $ssl20C.DisabledByDefault
            Write-host "SSL 2.0: DisabledByDefault: $ssl20CH`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: $ssl20CH`r"
        }
        If($ssl20C.Enabled -eq $null) {
            Write-host "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl20CH = $ssl20C.Enabled
            Write-host "SSL 2.0: Enabled: $ssl20CH`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: $ssl20CH`r`n"
        }
    }
    Else {
        Write-host "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
    }   
    $ssl30CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
    If ($ssl30CTest -eq "True") {
        $ssl30C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
        If($ssl30C.DisabledByDefault -eq $null) {
            Write-host "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl30CH = $ssl30C.DisabledByDefault
            Write-host "SSL 3.0: DisabledByDefault: $ssl20CH`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: $ssl20CH`r"
        }
        If($ssl30C.Enabled -eq $null) {
            Write-host "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl30CH = $ssl30C.Enabled
            Write-host "SSL 3.0: Enabled: $ssl30CH`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: $ssl30CH`r`n"
        }
    }
    Else {
        Write-host "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $tls10CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
    If ($tls10CTest -eq "True") {
        $tls10C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
        If($tls10C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls10CH = $tls10C.DisabledByDefault
            Write-host "TLS 1.0: DisabledByDefault: $tls10CH`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: $tls10CH`r"
        }
        If($tls10C.Enabled -eq $null) {
            Write-host "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls10CH = $tls10C.Enabled
            Write-host "TLS 1.0: Enabled: $tls10CH`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: $tls10CH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls11CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
    If ($tls11CTest -eq "True") {
        $tls11C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
        If($tls11C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls11CH = $tls11C.DisabledByDefault
            Write-host "TLS 1.1: DisabledByDefault: $tls11CH`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: $tls11CH`r"
        }
        If($tls11C.Enabled -eq $null) {
            Write-host "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls11CH = $tls11C.Enabled
            Write-host "TLS 1.1: Enabled: $tls11CH`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: $tls11CH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls12CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
    If ($tls12CTest -eq "True") {
        $tls12C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
        If($tls12C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls12CH = $tls12C.DisabledByDefault
            Write-host "TLS 1.2: DisabledByDefault: $tls12CH`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: $tls12CH`r"
        }
        If($tls12C.Enabled -eq $null) {
            Write-host "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
        }
        Else {
            $tls12CH = $tls12C.Enabled
            Write-host "TLS 1.2: Enabled: $tls12CH`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: $tls12CH`r`n`n"
        }
    }
    Else {
        Write-host "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
        Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
    }

    Write-host "[Server Keys]`r`n"
    Add-Content .\result.txt -value "[Server Keys]`r`n"
    $ssl20STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
    If ($ssl20STest -eq "True") {
        $ssl20S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
        If($ssl20S.DisabledByDefault -eq $null) {
            Write-host "SSL 2.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl20SH = $ssl20S.DisabledByDefault
            Write-host "SSL 2.0: DisabledByDefault: $ssl20SH`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: $ssl20SH`r"
        }
        If($ssl20S.Enabled -eq $null) {
            Write-host "SSL 2.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl20SH = $ssl20S.Enabled
            Write-host "SSL 2.0: Enabled: $ssl20SH`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: $ssl20SH`r`n"
        }
    }
    Else {
        Write-host "SSL 2.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 2.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 2.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $ssl30STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
    If ($ssl30STest -eq "True") {
        $ssl30S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
        If($ssl30S.DisabledByDefault -eq $null) {
            Write-host "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl30SH = $ssl30S.DisabledByDefault
            Write-host "SSL 3.0: DisabledByDefault: $ssl30SH`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: $ssl30SH`r"
        }
        If($ssl30S.Enabled -eq $null) {
            Write-host "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl30SH = $ssl30S.Enabled
            Write-host "SSL 3.0: Enabled: $ssl30SH`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: $ssl30SH`r`n"
        }
    }
    Else {
        Write-host "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $tls10STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
    If ($tls10STest -eq "True") {
        $tls10S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
        If($tls10S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls10SH = $tls10S.DisabledByDefault
            Write-host "TLS 1.0: DisabledByDefault: $tls10SH`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: $tls10SH`r"
        }
        If($tls10S.Enabled -eq $null) {
            Write-host "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls10SH = $tls10S.Enabled
            Write-host "TLS 1.0: Enabled: $tls10SH`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: $tls10SH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls11STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
    If ($tls11STest -eq "True") {
        $tls11S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
        If($tls11S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.1: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls11SH = $tls11S.DisabledByDefault
            Write-host "TLS 1.1: DisabledByDefault: $tls11SH`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: $tls11SH`r"
        }
        If($tls11S.Enabled -eq $null) {
            Write-host "TLS 1.1: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls11SH = $tls11S.Enabled
            Write-host "TLS 1.1: Enabled: $tls11SH`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: $tls11SH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.1: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.1: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.1: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls12STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
    If ($tls12STest -eq "True") {
        $tls12S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
        If($tls12S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.2: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls12SH = $tls12S.DisabledByDefault
            Write-host "TLS 1.2: DisabledByDefault: $tls12SH`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: $tls12SH`r"
        }
        If($tls12S.Enabled -eq $null) {
            Write-host "TLS 1.2: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n`n"
        }
        Else {
            $tls12SH = $tls12S.Enabled
            Write-host "TLS 1.2: Enabled: $tls12SH`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: $tls12SH`r`n`n"
        }
    }
    Else {
        Write-host "TLS 1.2: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.2: Enabled: 0, Registry folder key not present. Using OS Default.`r`n`n"
        Add-Content .\result.txt -value "TLS 1.2: Enabled: 0, Registry folder key not present. Using OS Default.`r`n`n"
    }
    Write-Host "[KeyExchangeAlgorithms]`r`n"
    Add-Content .\result.txt -value "[KeyExchangeAlgorithms]`r`n"
    $keyExchangeAlgo = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms"
    If( $keyExchangeAlgo -eq "True" ) {
        $PKCS = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\PKCS"
        If( $PKCS -eq "True" ) {
            $PKCSE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\PKCS"
        
            If ( $PKCSE.Enabled -eq $null ) {
                Write-Host "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed.  Value not set.`r`n`n"
                Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed.  Value not set.`r`n`n"
            }
            ElseIf( $PKCSE.Enabled -eq 0 ) {
                Write-Host "WARNING!!! PKCS is disabled.  No RSA-based SSL and TLS cipher suites will be allowed!`r`n`n"
                Add-Content .\result.txt -value "WARNING!!! PKCS is disabled.  No RSA-based SSL and TLS cipher suites will be allowed!`r`n`n"
            }
            Else {
                $PKCSEH = $PKCSE.Enabled
                $PKCSEHex = "{0:x8}" -f $PKCSEH
                Write-Host "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed. Value set to: 0x$PKCSEHex`r`n`n"
                Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed. Value set to: 0x$PKCSEHex`r`n`n"
            }
        }
        Else {
            Write-host "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
            Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
        }
    }
    Else {
       Write-host "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
       Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
    }
    Write-Host "[Hashes]`r`n"
    Add-Content .\result.txt -value "[Hashes]`r`n"
    $md5 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5"
    If( $md5 -eq "True" ) {
        $md5E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5\"
        If ( $md5E.Enabled -eq $null ) {
            Write-Host "MD5 Cipher Hashes are enabled. Value not set.`r"
            Add-Content .\result.txt -value "MD5 Cipher Hashes are enabled. Value not set.`r"
        }
        ElseIf( $md5E.Enabled -eq 0 ) {
            Write-Host "WARNING!!! MD5 based Cipher Suites have been disabled!`r"
            Add-Content .\result.txt -value "WARNING!!! MD5 based Cipher Suites have been disabled!`r"
        }
        Else {
            $md5EH = $md5E.Enabled
            $md5EHex = "{0:x8}" -f $md5EH
            Write-Host "Md5 Cipher Hashes are enabled.  Value set to: 0x$md5EHex`r"
			Add-Content .\result.txt -value "Md5 Cipher Hashes are enabled.  Value set to: 0x$md5EHex`r"
        }
    }
    Else {
       Write-host "MD5 Cipher Hashes are enabled.  Reg Key not present.`r"
       Add-Content .\result.txt -value "MD5 Cipher Hashes are enabled.  Reg Key not present.`r"
    }
    $SHA = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA"
    If( $SHA -eq "True" ) {
        $SHAE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA"
        If ( $SHAE.Enabled -eq $null ) {
            Write-Host "SHA-1 Cipher Hashes are enabled. Value not set.`r`n`n"
            Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled. Value not set.`r`n`n"
        }
        ElseIf( $SHAE.Enabled -eq 0 ) {
            Write-Host "WARNING!!! SHA-1 based Cipher Suites have been disabled!`r`n`n"
            Add-Content .\result.txt -value "WARNING!!! SHA-1 based Cipher Suites have been disabled!`r`n`n"
        }
        Else {
            $SHAEH = $SHAE.Enabled
            $SHAEHex = "{0:x8}" -f $SHAEH
            Write-Host "SHA-1 Cipher Hashes are enabled.  Value set to: 0x$SHAEHex`r`n`n"
            Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled.  Value set to: 0x$SHAEHex`r`n`n"
        }
    }
    Else {
       Write-host "SHA-1 Cipher Hashes are enabled.  Reg Key not present.`r`n`n"
       Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled.  Reg Key not present.`r`n`n"
    }
    Write-host "[Cipher Suites]`r`n"
    Add-Content .\result.txt -value "[Cipher Suites]`r`n"
    $nullValue = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL"
    if ($nullValue -eq "True") {
        $nullValueE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL"
        If($nullValueE.Enabled -eq $null -Or $nullValueE.Enabled -eq 0) {
            Write-host "Null is not set. Cipher Suites can be used.`r`n"
            Add-Content .\result.txt -value "Null is not set. Cipher Suites can be used.`r`n"
            $cipherAES256 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
            If ($cipherAES256 -eq "True") {
                $cipherAES256E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
                If($cipherAES256E.Enabled -eq $null) {
                    Write-host "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherAES256EH = $cipherAES256E.Enabled
                    Write-host "AES 256: Enabled: $ciperAES256EH`r"
					Add-Content .\result.txt -value "AES 256: Enabled: $ciperAES256EH`r"
                }
            }
            Else {
                Write-host "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherAES128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
            If ($cipherAES128 -eq "True") {
                $cipherAES128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
                If($cipherAES128E.Enabled -eq $null) {
                    Write-host "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherAES128EH = $cipherAES128E.Enabled
                    Write-host "AES 128: Enabled: $ciperAES128EH`r"
					Add-Content .\result.txt -value "AES 128: Enabled: $ciperAES128EH`r"
                }
            }
            Else {
                Write-host "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherDES56 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
            If ($cipherDES56 -eq "True") {
                $cipherDES56E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
                If($cipherDES56E.Enabled -eq $null) {
                    Write-host "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherDES56EH = $cipherDES56E.Enabled
                    Write-host "DES 56: Enabled: $ciperDES56EH`r"
					Add-Content .\result.txt -value "DES 56: Enabled: $ciperDES56EH`r"
                }
            }
            Else {
                Write-host "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC4128128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
            If ($cipherRC4128128 -eq "True") {
                $cipherRC4128128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
                If($cipherRC4128128E.Enabled -eq $null) {
                    Write-host "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC4128128EH = $cipherRC4128128E.Enabled
                    Write-host "RC4 128/128: Enabled: $ciperRC4128128EH`r"
					Add-Content .\result.txt -value "RC4 128/128: Enabled: $ciperRC4128128EH`r"
                }
            }
            Else {
                Write-host "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC464 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
            If ($cipherRC464 -eq "True") {
                $cipherRC464E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
                If($cipherRC464E.Enabled -eq $null) {
                    Write-host "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC464EH = $cipherRC464E.Enabled
                    Write-host "RC4 64/128: Enabled: $ciperRC464EH`r"
					Add-Content .\result.txt -value "RC4 64/128: Enabled: $ciperRC464EH`r"
                }
            }
            Else {
                Write-host "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC456 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
            If ($cipherRC456 -eq "True") {
                $cipherRC456E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
                If($cipherRC456E.Enabled -eq $null) {
                    Write-host "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC456EH = $cipherRC456E.Enabled
                    Write-host "RC4 56/128: Enabled: $ciperRC456EH`r"
					Add-Content .\result.txt -value "RC4 56/128: Enabled: $ciperRC456EH`r"
                }
            }
            Else {
                Write-host "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC440 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
            If ($cipherRC440 -eq "True") {
                $cipherRC440E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
                If($cipherRC440E.Enabled -eq $null) {
                    Write-host "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC440EH = $cipherRC440E.Enabled
                    Write-host "RC4 40/128: Enabled: $ciperRC440EH`r"
					Add-Content .\result.txt -value "RC4 40/128: Enabled: $ciperRC440EH`r"
                }
            }
            Else {
                Write-host "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipher3DES168 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
            If ($cipher3DES168 -eq "True") {
                $cipher3DES168E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
                If($cipher3DES168E.Enabled -eq $null) {
                    Write-host "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipher3DES168EH = $cipher3DES168E.Enabled
                    Write-host "Triple DES 168: Enabled: $ciper3DES168EH`r"
					Add-Content .\result.txt -value "Triple DES 168: Enabled: $ciper3DES168EH`r"
                }
            }
            Else {
                Write-host "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC2128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
            If ($cipherRC2128 -eq "True") {
                $cipherRC2128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
                If($cipherRC2128E.Enabled -eq $null) {
                    Write-host "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC2128EH = $cipherRC2128E.Enabled
                    Write-host "RC2 128/128: Enabled: $ciperRC2128EH`r"
					Add-Content .\result.txt -value "RC2 128/128: Enabled: $ciperRC2128EH`r"
                }
            }
            Else {
                Write-host "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC256128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
            If ($cipherRC256128 -eq "True") {
                $cipherRC256128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
                If($cipherRC256128E.Enabled -eq $null) {
                    Write-host "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC256128EH = $cipherRC256128E.Enabled
                    Write-host "RC2 56/128: Enabled: $ciperRC256128EH`r"
					Add-Content .\result.txt -value "RC2 56/128: Enabled: $ciperRC256128EH`r"
                }
            }
            Else {
                Write-host "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC240128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
            If ($cipherRC240128 -eq "True") {
                $cipherRC240128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
                If($cipherRC240128E.Enabled -eq $null) {
                    Write-host "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC240128EH = $cipherRC240128E.Enabled
                    Write-host "RC2 40/128: Enabled: $ciperRC240128EH`r"
					Add-Content .\result.txt -value "RC2 40/128: Enabled: $ciperRC240128EH`r"
                }
            }
            Else {
                Write-host "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC25656 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
            If ($cipherRC25656 -eq "True") {
                $cipherRC25656E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
                If($cipherRC25656E.Enabled -eq $null) {
                    Write-host "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
					Add-Content .\result.txt -value "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
                }
                Else {
                    $cipherRC25656EH = $cipherRC25656E.Enabled
                    Write-host "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
					Add-Content .\result.txt -value "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
                }
            }
            Else {
                Write-host "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
                Add-Content .\result.txt -value "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
            }
			Write-host "[00010002 Group Policy Cipher Reg Key Values]`r`n"
			Add-Content .\result.txt -value "[00010002 Group Policy Cipher Reg Key Values]`r`n"
			$cryptSSLGTest = Test-path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
			If ($cryptSSLGTest -eq "True") {
				If ($cryptSSLGTest.EccCurves -eq $null -And $cryptSSLG.Functions -eq $null){
					Write-Host "Group Policy is not set.  Local values will be used listed below.`r`n"
					Add-Content .\result.txt -value "Group Policy is not set.  Local values will be used listed below.`r`n`n"
					Write-host "[00010002 Local Cipher Reg Key Values]`r`n"
					Add-Content .\result.txt -value "[00010002 Local Cipher Reg Key Values]`r`n"
					$cryptSSLTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
					If ($cryptSSLTest -eq "True") {
						$cryptSSL = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
						If($cryptSSL.EccCurves -eq $null) {
							Write-host "EccCurves: Value is NULL!`r`n"
							Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
						}
						Else {
							$cryptSSLH = $cryptSSL.EccCurves
							Write-host "EccCurves: $cryptSSLH`r`n"
							Add-Content .\result.txt -value "EccCurves: $cryptSSLH`r`n"
						}
						If($cryptSSL.Functions -eq $null) {
							Write-host "Functions: Value is NULL!`r`n`n"
							Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
						}
						Else {
							$cryptSSLF = $cryptSSL.Functions
							Write-host "Functions: $cryptSSLF`r`n`n"
							Add-Content .\result.txt -value "Functions: $cryptSSLF`r`n`n"
						}
					}
					Else {
						Write-host "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
						Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
					}
				}
				Else {
					$cryptSSLG = Get-ItemProperty -path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
					If($cryptSSLG.EccCurves -eq $null) {
						Write-host "EccCurves: Value is NULL!`r`n"
						Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
					}
					Else {
						$cryptSSLGH = $cryptSSL.EccCurves
						Write-host "EccCurves: $cryptSSLGH`r`n"
						Add-Content .\result.txt -value "EccCurves: $cryptSSLGH`r`n"
					}
					If($cryptSSLG.Functions -eq $null) {
						Write-host "Functions: Value is NULL!`r`n`n"
						Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
					}
					Else {
						$cryptSSLGF = $cryptSSL.Functions
						Write-host "Functions: $cryptSSLGF`r`n`n"
						Add-Content .\result.txt -value "Functions: $cryptSSLGF`r`n`n"
					}
				}
			}
			Else {
				Write-host "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
				Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
			}
        }
        Else {
            $nullValueEH = $nullValueE.Enabled
            Write-Host "WARNING!!!  NULL is enabled!  No Cipher Suites are enabled regardless of Reg Key Set or Not!`r`n`n"
			Add-Content .\result.txt -value "WARNING!!!  NULL is enabled!  No Cipher Suites are enabled regardless of Reg Key Set or Not!`r`n`n"
        }
    }
    Else {
        Write-host "Null Reg Key not present.  Cipher Suites can be used.`r`n"
        Add-Content .\result.txt -value "Null Reg Key not present.  Cipher Suites can be used.`r`n"
        $cipherAES256 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
        If ($cipherAES256 -eq "True") {
            $cipherAES256E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
            If($cipherAES256E.Enabled -eq $null) {
                Write-host "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherAES256EH = $cipherAES256E.Enabled
                Write-host "AES 256: Enabled: $ciperAES256EH`r"
				Add-Content .\result.txt -value "AES 256: Enabled: $ciperAES256EH`r"
            }
        }
        Else {
            Write-host "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherAES128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
        If ($cipherAES128 -eq "True") {
            $cipherAES128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
            If($cipherAES128E.Enabled -eq $null) {
                Write-host "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherAES128EH = $cipherAES128E.Enabled
                Write-host "AES 128: Enabled: $ciperAES128EH`r"
				Add-Content .\result.txt -value "AES 128: Enabled: $ciperAES128EH`r"
            }
        }
        Else {
            Write-host "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherDES56 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
        If ($cipherDES56 -eq "True") {
            $cipherDES56E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
            If($cipherDES56E.Enabled -eq $null) {
                Write-host "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherDES56EH = $cipherDES56E.Enabled
                Write-host "DES 56: Enabled: $ciperDES56EH`r"
				Add-Content .\result.txt -value "DES 56: Enabled: $ciperDES56EH`r"
            }
        }
        Else {
            Write-host "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC4128128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
        If ($cipherRC4128128 -eq "True") {
            $cipherRC4128128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
            If($cipherRC4128128E.Enabled -eq $null) {
                Write-host "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC4128128EH = $cipherRC4128128E.Enabled
                Write-host "RC4 128/128: Enabled: $ciperRC4128128EH`r"
				Add-Content .\result.txt -value "RC4 128/128: Enabled: $ciperRC4128128EH`r"
            }
        }
        Else {
            Write-host "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC464 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
        If ($cipherRC464 -eq "True") {
            $cipherRC464E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
            If($cipherRC464E.Enabled -eq $null) {
                Write-host "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC464EH = $cipherRC464E.Enabled
                Write-host "RC4 64/128: Enabled: $ciperRC464EH`r"
				Add-Content .\result.txt -value "RC4 64/128: Enabled: $ciperRC464EH`r"
            }
        }
        Else {
            Write-host "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC456 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
        If ($cipherRC456 -eq "True") {
            $cipherRC456E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
            If($cipherRC456E.Enabled -eq $null) {
                Write-host "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC456EH = $cipherRC456E.Enabled
                Write-host "RC4 56/128: Enabled: $ciperRC456EH`r"
				Add-Content .\result.txt -value "RC4 56/128: Enabled: $ciperRC456EH`r"
            }
        }
        Else {
            Write-host "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC440 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
        If ($cipherRC440 -eq "True") {
            $cipherRC440E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
            If($cipherRC440E.Enabled -eq $null) {
                Write-host "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC440EH = $cipherRC440E.Enabled
                Write-host "RC4 40/128: Enabled: $ciperRC440EH`r"
				Add-Content .\result.txt -value "RC4 40/128: Enabled: $ciperRC440EH`r"
            }
        }
        Else {
            Write-host "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipher3DES168 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
        If ($cipher3DES168 -eq "True") {
            $cipher3DES168E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
            If($cipher3DES168E.Enabled -eq $null) {
                Write-host "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipher3DES168EH = $cipher3DES168E.Enabled
                Write-host "Triple DES 168: Enabled: $ciper3DES168EH`r"
				Add-Content .\result.txt -value "Triple DES 168: Enabled: $ciper3DES168EH`r"
            }
        }
        Else {
            Write-host "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC2128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
        If ($cipherRC2128 -eq "True") {
            $cipherRC2128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
            If($cipherRC2128E.Enabled -eq $null) {
                Write-host "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC2128EH = $cipherRC2128E.Enabled
                Write-host "RC2 128/128: Enabled: $ciperRC2128EH`r"
				Add-Content .\result.txt -value "RC2 128/128: Enabled: $ciperRC2128EH`r"
            }
        }
        Else {
            Write-host "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC256128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
        If ($cipherRC256128 -eq "True") {
            $cipherRC256128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
            If($cipherRC256128E.Enabled -eq $null) {
                Write-host "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC256128EH = $cipherRC256128E.Enabled
                Write-host "RC2 56/128: Enabled: $ciperRC256128EH`r"
				Add-Content .\result.txt -value "RC2 56/128: Enabled: $ciperRC256128EH`r"
            }
        }
        Else {
            Write-host "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC240128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
        If ($cipherRC240128 -eq "True") {
            $cipherRC240128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
            If($cipherRC240128E.Enabled -eq $null) {
                Write-host "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC240128EH = $cipherRC240128E.Enabled
                Write-host "RC2 40/128: Enabled: $ciperRC240128EH`r"
				Add-Content .\result.txt -value "RC2 40/128: Enabled: $ciperRC240128EH`r"
            }
        }
        Else {
            Write-host "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC25656 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
        If ($cipherRC25656 -eq "True") {
            $cipherRC25656E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
            If($cipherRC25656E.Enabled -eq $null) {
                Write-host "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
				Add-Content .\result.txt -value "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            }
            Else {
                $cipherRC25656EH = $cipherRC25656E.Enabled
                Write-host "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
				Add-Content .\result.txt -value "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
            }
        }
        Else {
            Write-host "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
            Add-Content .\result.txt -value "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
        }
		Write-host "[00010002 Group Policy Cipher Reg Key Values]`r`n"
		Add-Content .\result.txt -value "[00010002 Group Policy Cipher Reg Key Values]`r`n"
		$cryptSSLGTest = Test-path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
		If ($cryptSSLGTest -eq "True") {
			If ($cryptSSLGTest.EccCurves -eq $null -And $cryptSSLG.Functions -eq $null){
				Write-Host "Group Policy is not set.  Local values will be used listed below.`r`n`n"
				Add-Content .\result.txt -value "Group Policy is not set.  Local values will be used listed below.`r`n`n"
				Write-host "[00010002 Local Cipher Reg Key Values]`r`n"
				Add-Content .\result.txt -value "[00010002 Local Cipher Reg Key Values]`r`n"
				$cryptSSLTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
				If ($cryptSSLTest -eq "True") {
					$cryptSSL = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
					If($cryptSSL.EccCurves -eq $null) {
						Write-host "EccCurves: Value is NULL!`r`n"
						Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
					}
					Else {
						$cryptSSLH = $cryptSSL.EccCurves
						Write-host "EccCurves: $cryptSSLH`r`n"
						Add-Content .\result.txt -value "EccCurves: $cryptSSLH`r`n"
					}
					If($cryptSSL.Functions -eq $null) {
						Write-host "Functions: Value is NULL!`r`n`n"
						Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
					}
					Else {
						$cryptSSLF = $cryptSSL.Functions
						Write-host "Functions: $cryptSSLF`r`n`n"
						Add-Content .\result.txt -value "Functions: $cryptSSLF`r`n`n"
					}
				}
				Else {
					Write-host "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
					Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
				}
			}
			Else {
				$cryptSSLG = Get-ItemProperty -path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
				If($cryptSSLG.EccCurves -eq $null) {
					Write-host "EccCurves: Value is NULL!`r`n"
					Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
				}
				Else {
					$cryptSSLGH = $cryptSSL.EccCurves
					Write-host "EccCurves: $cryptSSLGH`r`n"
					Add-Content .\result.txt -value "EccCurves: $cryptSSLGH`r`n"
				}
				If($cryptSSLG.Functions -eq $null) {
					Write-host "Functions: Value is NULL!`r`n`n"
					Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
				}
				Else {
					$cryptSSLGF = $cryptSSL.Functions
					Write-host "Functions: $cryptSSLGF`r`n`n"
					Add-Content .\result.txt -value "Functions: $cryptSSLGF`r`n`n"
				}
			}
		}
		Else {
			Write-host "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
			Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
		}
    }
	Write-Host "[Fips Algorithm]`r`n"
	Add-Content .\result.txt -value "[Fips Algorithm]`r`n"
	$fipsAlgo = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
    If ($fipsAlgo -eq "True") {
        $fipsAlgoE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
        If($fipsAlgoE.Enabled -eq $null -And $fipsAlgoE.MDMEnabled -eq $null) {
            Write-Host "Disabled! Someone deleted values manually.  Please add REG_DWORD Values: Enabled: 0, MDMEnabled: 0 to correct."
			Add-Content .\result.txt -value "Disabled! Someone deleted values manually.  Please add REG_DWORD Values: Enabled: 0, MDMEnabled: 0 to correct."
        }
        ElseIf ($fipsAlgoE.Enabled -eq 0 -And $fipsAlgoE.MDMEnabled -eq 0){
            $fipsAlgoEH = $fipsAlgoE.Enabled
            Write-Host "Fips and MDM are both Disabled."
			Add-Content .\result.txt -value "Fips and MDM are both Disabled."
        }
		Else {
            If($fipsAlgoE.Enabled -eq $null){
                Write-Host "Fips value set to Null.  Not enabled.`r"
                Add-Content .\result.txt -value "Fips value set to Null. Not enabled.`r"
            }
            Else {
                $fipsAlgoEF = $fipsAlgoE.Enabled
                $fipsAlgoEHex = "{0:x8}" -f $fipsAlgoEF
                Write-Host "Fips Value set to Enabled: 0x$fipsAlgoEHex`r"
			    Add-Content .\result.txt -value "Fips Value set to Enabled: 0x$fipsAlgoEHex`r"
            }

            If($fipsAlgoE.MDMEnabled -eq $null){
                Write-Host "MDMEnabled value is set to Null. Not enabled.`r`n`n"
                Add-Content .\result.txt -value "MDMEnabled value is set to Null.  Not enabled.`r`n`n"
            }
            Else {
			    $fipsAlgoEC = $fipsAlgoE.MDMEnabled
			    $fipsAlgoECHex = "{0:x8}" -f $fipsAlgoEC
			    Write-Host "MDMEnabled Value set to Enabled: 0x$fipsAlgoECHex`r`n`n"
			    Add-Content .\result.txt -value "MDMEnabled Value set to Enabled: 0x$fipsAlgoECHex`r`n`n"
            }
		}
    }
    Else {
        Write-host "FipsAlgorithmPolicy Reg Key has been removed manually!  Please re-add the Reg Key! HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy]`r`n`n"
        Add-Content .\result.txt -value "FipsAlgorithmPolicy Reg Key has been removed manually!  Please re-add the Reg Key! HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy]`r`n`n"
    }

    Write-host "[WinHTTP Settings]`r`n"
    Add-Content .\result.txt -value "[WinHTTP Settings]`r`n"
    $IsKB3140245Installed = get-hotfix -id KB3140245 -EA SilentlyContinue
    $Hotfix = $IsKB3140245Installed.HotFixID
    If ($Hotfix -eq "KB3140245") {
        Write-host "KB3140245 detected.  WinHTTP values do apply!`r`n" 
        Add-Content .\result.txt -value "KB3140245 detected.  WinHTTP values do apply!`r`n" 
        If([System.IntPtr]::Size -eq 8) {
            $winHTTPSet = Test-Path $WinHttpDefaultSecureProtocols
            If($winHTTPSet -eq "True") {
                $winHTTPSetE = Get-ItemProperty -path "HKCU:\\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
                If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                    Write-Host "WinHTTP Key for 64-Bit is present.  Value is not.  Not enforced."
                    Add-Content .\result.txt -value "WinHTTP Key for 64-Bit is present.  Value is not.  Not enforced."
                }
                Else{
                    $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                    $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                    Write-Host "WinHTTP 64-Bit Key: $winHTTPSetEFHex`r"
                    Add-Content .\result.txt -value "WinHTTP 64-Bit Key: $winHTTPSetEFHex`r"
                }
            }
            Else {
                Write-Host "WinHTTP 64-bit Key is not present.`r"
                Add-Content .\result.txt -value "WinHTTP 64-bit Key is not present.`r"
            }
            $winHTTPSet = Test-path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
            If($winHTTPSet -eq "True") {
                $winHTTPSetE = Get-ItemProperty -path $X32WinHttpDefaultSecureProtocols
                If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                    Write-Host "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
                    Add-Content .\result.txt -value "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
                }
                Else{
                    $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                    $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                    Write-Host "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
                    Add-Content .\result.txt -value "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
                }
            }
            Else {
                Write-Host "WinHTTP 32-bit Key is not present.`r`n"
                Add-Content .\result.txt -value "WinHTTP 32-bit Key is not present.`r`n"
            }
        }
        Else {
           $winHTTPSet = Test-path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
           If($winHTTPSet -eq "True") {
               $winHTTPSetE = Get-ItemProperty -path $X32WinHttpDefaultSecureProtocols
                If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                    Write-Host "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
                    Add-Content .\result.txt -value "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
                }
                Else{
                    $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                    $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                    Write-Host "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
                    Add-Content .\result.txt -value "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
                }
            }
            Else {
                Write-Host "WinHTTP 32-bit Key is not present.`r`n"
                Add-Content .\result.txt -value "WinHTTP 32-bit Key is not present.`r`n"
            }        
        }
        Write-host "WinHTTP value requires XOR'ing.  XOR values below to allow multiple protocols: Example: 0xa80`r"
        Add-Content .\result.txt -value "WinHTTP value requires XOR'ing.  XOR values below to allow multiple protocols: Example: 0xa80`r"
        Write-host "0x00000008 - Enable SSL 2.0`r"
        Add-Content .\result.txt -value "0x00000008 - Enable SSL 2.0`r"
        Write-host "0x00000020 - Enable SSL 3.0`r"
        Add-Content .\result.txt -value "0x00000020 - Enable SSL 3.0`r"
        Write-host "0x00000080 - Enable TLS 1.0`r"
        Add-Content .\result.txt -value "0x00000080 - Enable TLS 1.0`r"
        Write-host "0x00000200 - Enable TLS 1.1`r"
        Add-Content .\result.txt -value "0x00000200 - Enable TLS 1.1`r"
        Write-host "0x00000800 - Enable TLS 1.2`r`n"
        Add-Content .\result.txt -value "0x00000800 - Enable TLS 1.2`r`n"
            
    
	}
    Else {
        Write-host "DefaultSecureProtocol does not apply."
        Add-Content .\result.txt -value "DefaultSecureProtocol does not apply."
    }
    
}
ElseIf ($osversionMajor -eq 6 -And $osversionMinor -eq 2) {
    Write-host "[Hostname] = $hostname`r"
	Add-Content .\result.txt -value "[Hostname] = $hostname`r"
    Write-host "[Machine Version] = Windows 8/8.1 or Server 2012/2012R2`r" 
    Add-Content .\result.txt -value "[Machine Version] = Windows 8/8.1 or Server 2012/2012R2`r"
    if ([System.IntPtr]::Size -eq 4) {
        Write-host "[Architecture] = 32-bit`r`n`n"
        Add-Content .\result.txt -value "[Architecture] = 32-bit`r`n`n" 
    } 
    else {
        Write-host "[Architecture] = 64-bit`r`n`n"
        Add-Content .\result.txt -value "[Architecture] = 64-bit`r`n`n"
    }
    Write-host "[Client Keys]`r`n"
    Add-Content .\result.txt -value "[Client Keys]`r`n"

    $ssl20CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
    If ($ssl20CTest -eq "True") {
        $ssl20C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
        If($ssl20C.DisabledByDefault -eq $null) {
            Write-host "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl20CH = $ssl20C.DisabledByDefault
            Write-host "SSL 2.0: DisabledByDefault: $ssl20CH`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: $ssl20CH`r"
        }
        If($ssl20C.Enabled -eq $null) {
            Write-host "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
			Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl20CH = $ssl20C.Enabled
            Write-host "SSL 2.0: Enabled: $ssl20CH`r`n"
			Add-Content .\result.txt -value "SSL 2.0: Enabled: $ssl20CH`r`n"
        }
    }
    Else {
        Write-host "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
		Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
    }   
    $ssl30CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
    If ($ssl30CTest -eq "True") {
        $ssl30C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
        If($ssl30C.DisabledByDefault -eq $null) {
            Write-host "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl30CH = $ssl30C.DisabledByDefault
            Write-host "SSL 3.0: DisabledByDefault: $ssl20CH`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: $ssl20CH`r"
        }
        If($ssl30C.Enabled -eq $null) {
            Write-host "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl30CH = $ssl30C.Enabled
            Write-host "SSL 3.0: Enabled: $ssl30CH`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: $ssl30CH`r`n"
        }
    }
    Else {
        Write-host "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $tls10CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
    If ($tls10CTest -eq "True") {
        $tls10C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
        If($tls10C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls10CH = $tls10C.DisabledByDefault
            Write-host "TLS 1.0: DisabledByDefault: $tls10CH`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: $tls10CH`r"
        }
        If($tls10C.Enabled -eq $null) {
            Write-host "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls10CH = $tls10C.Enabled
            Write-host "TLS 1.0: Enabled: $tls10CH`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: $tls10CH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls11CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
    If ($tls11CTest -eq "True") {
        $tls11C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
        If($tls11C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls11CH = $tls11C.DisabledByDefault
            Write-host "TLS 1.1: DisabledByDefault: $tls11CH`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: $tls11CH`r"
        }
        If($tls11C.Enabled -eq $null) {
            Write-host "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls11CH = $tls11C.Enabled
            Write-host "TLS 1.1: Enabled: $tls11CH`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: $tls11CH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls12CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
    If ($tls12CTest -eq "True") {
        $tls12C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
        If($tls12C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls12CH = $tls12C.DisabledByDefault
            Write-host "TLS 1.2: DisabledByDefault: $tls12CH`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: $tls12CH`r"
        }
        If($tls12C.Enabled -eq $null) {
            Write-host "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
        }
        Else {
            $tls12CH = $tls12C.Enabled
            Write-host "TLS 1.2: Enabled: $tls12CH`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: $tls12CH`r`n`n"
        }
    }
    Else {
        Write-host "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
        Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
    }

    Write-host "[Server Keys]`r`n"
    Add-Content .\result.txt -value "[Server Keys]`r`n"
    $ssl20STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
    If ($ssl20STest -eq "True") {
        $ssl20S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
        If($ssl20S.DisabledByDefault -eq $null) {
            Write-host "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl20SH = $ssl20S.DisabledByDefault
            Write-host "SSL 2.0: DisabledByDefault: $ssl20SH`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: $ssl20SH`r"
        }
        If($ssl20S.Enabled -eq $null) {
            Write-host "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl20SH = $ssl20S.Enabled
            Write-host "SSL 2.0: Enabled: $ssl20SH`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: $ssl20SH`r`n"
        }
    }
    Else {
        Write-host "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
    }   
    $ssl30STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
    If ($ssl30STest -eq "True") {
        $ssl30S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
        If($ssl30S.DisabledByDefault -eq $null) {
            Write-host "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl30SH = $ssl30S.DisabledByDefault
            Write-host "SSL 3.0: DisabledByDefault: $ssl30SH`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: $ssl30SH`r"
        }
        If($ssl30S.Enabled -eq $null) {
            Write-host "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl30SH = $ssl30S.Enabled
            Write-host "SSL 3.0: Enabled: $ssl30SH`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: $ssl30SH`r`n"
        }
    }
    Else {
        Write-host "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $tls10STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
    If ($tls10STest -eq "True") {
        $tls10S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
        If($tls10S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls10SH = $tls10S.DisabledByDefault
            Write-host "TLS 1.0: DisabledByDefault: $tls10SH`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: $tls10SH`r"
        }
        If($tls10S.Enabled -eq $null) {
            Write-host "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls10SH = $tls10S.Enabled
            Write-host "TLS 1.0: Enabled: $tls10SH`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: $tls10SH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls11STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
    If ($tls11STest -eq "True") {
        $tls11S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
        If($tls11S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls11SH = $tls11S.DisabledByDefault
            Write-host "TLS 1.1: DisabledByDefault: $tls11SH`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: $tls11SH`r"
        }
        If($tls11S.Enabled -eq $null) {
            Write-host "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls11SH = $tls11S.Enabled
            Write-host "TLS 1.1: Enabled: $tls11SH`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: $tls11SH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls12STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
    If ($tls12STest -eq "True") {
        $tls12S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
        If($tls12S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls12SH = $tls12S.DisabledByDefault
            Write-host "TLS 1.2: DisabledByDefault: $tls12SH`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: $tls12SH`r"
        }
        If($tls12S.Enabled -eq $null) {
            Write-host "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
        }
        Else {
            $tls12SH = $tls12S.Enabled
            Write-host "TLS 1.2: Enabled: $tls12SH`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: $tls12SH`r`n`n"
        }
    }
    Else {
        Write-host "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
        Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
    }
	Write-Host "[KeyExchangeAlgorithms]`r`n"
    Add-Content .\result.txt -value "[KeyExchangeAlgorithms]`r`n"
    $keyExchangeAlgo = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms"
    If( $keyExchangeAlgo -eq "True" ) {
        $PKCS = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\PKCS"
        If( $PKCS -eq "True" ) {
            $PKCSE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\PKCS"
        
            If ( $PKCSE.Enabled -eq $null ) {
                Write-Host "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed.  Value not set.`r`n`n"
                Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed.  Value not set.`r`n`n"
            }
            ElseIf( $PKCSE.Enabled -eq 0 ) {
                Write-Host "WARNING!!! PKCS is disabled.  No RSA-based SSL and TLS cipher suites will be allowed!`r`n`n"
                Add-Content .\result.txt -value "WARNING!!! PKCS is disabled.  No RSA-based SSL and TLS cipher suites will be allowed!`r`n`n"
            }
            Else {
                $PKCSEH = $PKCSE.Enabled
                $PKCSEHex = "{0:x8}" -f $PKCSEH
                Write-Host "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed. Value set to: 0x$PKCSEHex`r`n`n"
                Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed. Value set to: 0x$PKCSEHex`r`n`n"
            }
        }
        Else {
            Write-host "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
            Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
        }
    }
    Else {
       Write-host "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
       Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
    }
    Write-Host "[Hashes]`r`n"
    Add-Content .\result.txt -value "[Hashes]`r`n"
    $md5 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5"
    If( $md5 -eq "True" ) {
        $md5E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5\"
        If ( $md5E.Enabled -eq $null ) {
            Write-Host "MD5 Cipher Hashes are enabled. Value not set.`r"
            Add-Content .\result.txt -value "MD5 Cipher Hashes are enabled. Value not set.`r"
        }
        ElseIf( $md5E.Enabled -eq 0 ) {
            Write-Host "WARNING!!! MD5 based Cipher Suites have been disabled!`r"
            Add-Content .\result.txt -value "WARNING!!! MD5 based Cipher Suites have been disabled!`r"
        }
        Else {
            $md5EH = $md5E.Enabled
            $md5EHex = "{0:x8}" -f $md5EH
            Write-Host "Md5 Cipher Hashes are enabled.  Value set to: 0x$md5EHex`r"
			Add-Content .\result.txt -value "Md5 Cipher Hashes are enabled.  Value set to: 0x$md5EHex`r"
        }
    }
    Else {
       Write-host "MD5 Cipher Hashes are enabled.  Reg Key not present.`r"
       Add-Content .\result.txt -value "MD5 Cipher Hashes are enabled.  Reg Key not present.`r"
    }
    $SHA = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA"
    If( $SHA -eq "True" ) {
        $SHAE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA"
        If ( $SHAE.Enabled -eq $null ) {
            Write-Host "SHA-1 Cipher Hashes are enabled. Value not set.`r`n`n"
            Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled. Value not set.`r`n`n"
        }
        ElseIf( $SHAE.Enabled -eq 0 ) {
            Write-Host "WARNING!!! SHA-1 based Cipher Suites have been disabled!`r`n`n"
            Add-Content .\result.txt -value "WARNING!!! SHA-1 based Cipher Suites have been disabled!`r`n`n"
        }
        Else {
            $SHAEH = $SHAE.Enabled
            $SHAEHex = "{0:x8}" -f $SHAEH
            Write-Host "SHA-1 Cipher Hashes are enabled.  Value set to: 0x$SHAEHex`r`n`n"
            Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled.  Value set to: 0x$SHAEHex`r`n`n"
        }
    }
    Else {
       Write-host "SHA-1 Cipher Hashes are enabled.  Reg Key not present.`r`n`n"
       Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled.  Reg Key not present.`r`n`n"
    }
    Write-host "[Cipher Suites]`r`n"
    Add-Content .\result.txt -value "[Cipher Suites]`r`n"
    $nullValue = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL"
    if ($nullValue -eq "True") {
        $nullValueE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL"
        If($nullValueE.Enabled -eq $null -Or $nullValueE.Enabled -eq 0) {
            Write-host "Null is not set. Cipher Suites can be used.`r`n"
            Add-Content .\result.txt -value "Null is not set. Cipher Suites can be used.`r`n"
            $cipherAES256 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
            If ($cipherAES256 -eq "True") {
                $cipherAES256E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
                If($cipherAES256E.Enabled -eq $null) {
                    Write-host "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherAES256EH = $cipherAES256E.Enabled
                    Write-host "AES 256: Enabled: $ciperAES256EH`r"
					Add-Content .\result.txt -value "AES 256: Enabled: $ciperAES256EH`r"
                }
            }
            Else {
                Write-host "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherAES128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
            If ($cipherAES128 -eq "True") {
                $cipherAES128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
                If($cipherAES128E.Enabled -eq $null) {
                    Write-host "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherAES128EH = $cipherAES128E.Enabled
                    Write-host "AES 128: Enabled: $ciperAES128EH`r"
					Add-Content .\result.txt -value "AES 128: Enabled: $ciperAES128EH`r"
                }
            }
            Else {
                Write-host "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherDES56 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
            If ($cipherDES56 -eq "True") {
                $cipherDES56E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
                If($cipherDES56E.Enabled -eq $null) {
                    Write-host "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherDES56EH = $cipherDES56E.Enabled
                    Write-host "DES 56: Enabled: $ciperDES56EH`r"
					Add-Content .\result.txt -value "DES 56: Enabled: $ciperDES56EH`r"
                }
            }
            Else {
                Write-host "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC4128128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
            If ($cipherRC4128128 -eq "True") {
                $cipherRC4128128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
                If($cipherRC4128128E.Enabled -eq $null) {
                    Write-host "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC4128128EH = $cipherRC4128128E.Enabled
                    Write-host "RC4 128/128: Enabled: $ciperRC4128128EH`r"
					Add-Content .\result.txt -value "RC4 128/128: Enabled: $ciperRC4128128EH`r"
                }
            }
            Else {
                Write-host "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC464 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
            If ($cipherRC464 -eq "True") {
                $cipherRC464E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
                If($cipherRC464E.Enabled -eq $null) {
                    Write-host "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC464EH = $cipherRC464E.Enabled
                    Write-host "RC4 64/128: Enabled: $ciperRC464EH`r"
					Add-Content .\result.txt -value "RC4 64/128: Enabled: $ciperRC464EH`r"
                }
            }
            Else {
                Write-host "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC456 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
            If ($cipherRC456 -eq "True") {
                $cipherRC456E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
                If($cipherRC456E.Enabled -eq $null) {
                    Write-host "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC456EH = $cipherRC456E.Enabled
                    Write-host "RC4 56/128: Enabled: $ciperRC456EH`r"
					Add-Content .\result.txt -value "RC4 56/128: Enabled: $ciperRC456EH`r"
                }
            }
            Else {
                Write-host "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC440 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
            If ($cipherRC440 -eq "True") {
                $cipherRC440E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
                If($cipherRC440E.Enabled -eq $null) {
                    Write-host "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC440EH = $cipherRC440E.Enabled
                    Write-host "RC4 40/128: Enabled: $ciperRC440EH`r"
					Add-Content .\result.txt -value "RC4 40/128: Enabled: $ciperRC440EH`r"
                }
            }
            Else {
                Write-host "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipher3DES168 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
            If ($cipher3DES168 -eq "True") {
                $cipher3DES168E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
                If($cipher3DES168E.Enabled -eq $null) {
                    Write-host "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipher3DES168EH = $cipher3DES168E.Enabled
                    Write-host "Triple DES 168: Enabled: $ciper3DES168EH`r"
					Add-Content .\result.txt -value "Triple DES 168: Enabled: $ciper3DES168EH`r"
                }
            }
            Else {
                Write-host "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC2128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
            If ($cipherRC2128 -eq "True") {
                $cipherRC2128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
                If($cipherRC2128E.Enabled -eq $null) {
                    Write-host "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC2128EH = $cipherRC2128E.Enabled
                    Write-host "RC2 128/128: Enabled: $ciperRC2128EH`r"
					Add-Content .\result.txt -value "RC2 128/128: Enabled: $ciperRC2128EH`r"
                }
            }
            Else {
                Write-host "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC256128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
            If ($cipherRC256128 -eq "True") {
                $cipherRC256128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
                If($cipherRC256128E.Enabled -eq $null) {
                    Write-host "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC256128EH = $cipherRC256128E.Enabled
                    Write-host "RC2 56/128: Enabled: $ciperRC256128EH`r"
					Add-Content .\result.txt -value "RC2 56/128: Enabled: $ciperRC256128EH`r"
                }
            }
            Else {
                Write-host "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC240128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
            If ($cipherRC240128 -eq "True") {
                $cipherRC240128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
                If($cipherRC240128E.Enabled -eq $null) {
                    Write-host "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC240128EH = $cipherRC240128E.Enabled
                    Write-host "RC2 40/128: Enabled: $ciperRC240128EH`r"
					Add-Content .\result.txt -value "RC2 40/128: Enabled: $ciperRC240128EH`r"
                }
            }
            Else {
                Write-host "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC25656 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
            If ($cipherRC25656 -eq "True") {
                $cipherRC25656E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
                If($cipherRC25656E.Enabled -eq $null) {
                    Write-host "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
					Add-Content .\result.txt -value "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
                }
                Else {
                    $cipherRC25656EH = $cipherRC25656E.Enabled
                    Write-host "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
					Add-Content .\result.txt -value "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
                }
            }
            Else {
                Write-host "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
                Add-Content .\result.txt -value "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
            }
			Write-host "[00010002 Group Policy Cipher Reg Key Values]`r`n"
			Add-Content .\result.txt -value "[00010002 Group Policy Cipher Reg Key Values]`r`n"
			$cryptSSLGTest = Test-path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
			If ($cryptSSLGTest -eq "True") {
				If ($cryptSSLGTest.EccCurves -eq $null -And $cryptSSLG.Functions -eq $null){
					Write-Host "Group Policy is not set.  Local values will be used listed below.`r`n`n"
					Add-Content .\result.txt -value "Group Policy is not set.  Local values will be used listed below.`r`n`n"
					Write-host "[00010002 Local Cipher Reg Key Values]`r`n"
					Add-Content .\result.txt -value "[00010002 Local Cipher Reg Key Values]`r`n"
					$cryptSSLTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
					If ($cryptSSLTest -eq "True") {
						$cryptSSL = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
						If($cryptSSL.EccCurves -eq $null) {
							Write-host "EccCurves: Value is NULL!`r`n"
							Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
						}
						Else {
							$cryptSSLH = $cryptSSL.EccCurves
							Write-host "EccCurves: $cryptSSLH`r`n"
							Add-Content .\result.txt -value "EccCurves: $cryptSSLH`r`n"
						}
						If($cryptSSL.Functions -eq $null) {
							Write-host "Functions: Value is NULL!`r`n`n"
							Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
						}
						Else {
							$cryptSSLF = $cryptSSL.Functions
							Write-host "Functions: $cryptSSLF`r`n`n"
							Add-Content .\result.txt -value "Functions: $cryptSSLF`r`n`n"
						}
					}
					Else {
						Write-host "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
						Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
					}
				}
				Else {
					$cryptSSLG = Get-ItemProperty -path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
					If($cryptSSLG.EccCurves -eq $null) {
						Write-host "EccCurves: Value is NULL!`r`n"
						Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
					}
					Else {
						$cryptSSLGH = $cryptSSL.EccCurves
						Write-host "EccCurves: $cryptSSLGH`r`n"
						Add-Content .\result.txt -value "EccCurves: $cryptSSLGH`r`n"
					}
					If($cryptSSLG.Functions -eq $null) {
						Write-host "Functions: Value is NULL!`r`n`n"
						Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
					}
					Else {
						$cryptSSLGF = $cryptSSL.Functions
						Write-host "Functions: $cryptSSLGF`r`n`n"
						Add-Content .\result.txt -value "Functions: $cryptSSLGF`r`n`n"
					}
				}
			}
			Else {
				Write-host "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
				Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
			}
        }
        Else {
            $nullValueEH = $nullValueE.Enabled
            Write-Host "WARNING!!!  NULL is enabled!  No Cipher Suites are enabled regardless of Reg Key Set or Not!`r`n`n"
			Add-Content .\result.txt -value "WARNING!!!  NULL is enabled!  No Cipher Suites are enabled regardless of Reg Key Set or Not!`r`n`n"
        }
    }
    Else {
        Write-host "Null Reg Key not present.  Cipher Suites can be used.`r`n"
        Add-Content .\result.txt -value "Null Reg Key not present.  Cipher Suites can be used.`r`n"
        $cipherAES256 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
        If ($cipherAES256 -eq "True") {
            $cipherAES256E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
            If($cipherAES256E.Enabled -eq $null) {
                Write-host "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherAES256EH = $cipherAES256E.Enabled
                Write-host "AES 256: Enabled: $ciperAES256EH`r"
				Add-Content .\result.txt -value "AES 256: Enabled: $ciperAES256EH`r"
            }
        }
        Else {
            Write-host "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherAES128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
        If ($cipherAES128 -eq "True") {
            $cipherAES128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
            If($cipherAES128E.Enabled -eq $null) {
                Write-host "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherAES128EH = $cipherAES128E.Enabled
                Write-host "AES 128: Enabled: $ciperAES128EH`r"
				Add-Content .\result.txt -value "AES 128: Enabled: $ciperAES128EH`r"
            }
        }
        Else {
            Write-host "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherDES56 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
        If ($cipherDES56 -eq "True") {
            $cipherDES56E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
            If($cipherDES56E.Enabled -eq $null) {
                Write-host "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherDES56EH = $cipherDES56E.Enabled
                Write-host "DES 56: Enabled: $ciperDES56EH`r"
				Add-Content .\result.txt -value "DES 56: Enabled: $ciperDES56EH`r"
            }
        }
        Else {
            Write-host "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
        } 
		$cipherRC4128128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
        If ($cipherRC4128128 -eq "True") {
            $cipherRC4128128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
            If($cipherRC4128128E.Enabled -eq $null) {
                Write-host "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC4128128EH = $cipherRC4128128E.Enabled
                Write-host "RC4 128/128: Enabled: $ciperRC4128128EH`r"
				Add-Content .\result.txt -value "RC4 128/128: Enabled: $ciperRC4128128EH`r"
            }
        }
        Else {
            Write-host "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC464 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
        If ($cipherRC464 -eq "True") {
            $cipherRC464E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
            If($cipherRC464E.Enabled -eq $null) {
                Write-host "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC464EH = $cipherRC464E.Enabled
                Write-host "RC4 64/128: Enabled: $ciperRC464EH`r"
				Add-Content .\result.txt -value "RC4 64/128: Enabled: $ciperRC464EH`r"
            }
        }
        Else {
            Write-host "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC456 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
        If ($cipherRC456 -eq "True") {
            $cipherRC456E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
            If($cipherRC456E.Enabled -eq $null) {
                Write-host "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC456EH = $cipherRC456E.Enabled
                Write-host "RC4 56/128: Enabled: $ciperRC456EH`r"
				Add-Content .\result.txt -value "RC4 56/128: Enabled: $ciperRC456EH`r"
            }
        }
        Else {
            Write-host "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC440 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
        If ($cipherRC440 -eq "True") {
            $cipherRC440E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
            If($cipherRC440E.Enabled -eq $null) {
                Write-host "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC440EH = $cipherRC440E.Enabled
                Write-host "RC4 40/128: Enabled: $ciperRC440EH`r"
				Add-Content .\result.txt -value "RC4 40/128: Enabled: $ciperRC440EH`r"
            }
        }
        Else {
            Write-host "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipher3DES168 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
        If ($cipher3DES168 -eq "True") {
            $cipher3DES168E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
            If($cipher3DES168E.Enabled -eq $null) {
                Write-host "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipher3DES168EH = $cipher3DES168E.Enabled
                Write-host "Triple DES 168: Enabled: $ciper3DES168EH`r"
				Add-Content .\result.txt -value "Triple DES 168: Enabled: $ciper3DES168EH`r"
            }
        }
        Else {
            Write-host "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC2128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
        If ($cipherRC2128 -eq "True") {
            $cipherRC2128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
            If($cipherRC2128E.Enabled -eq $null) {
                Write-host "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC2128EH = $cipherRC2128E.Enabled
                Write-host "RC2 128/128: Enabled: $ciperRC2128EH`r"
				Add-Content .\result.txt -value "RC2 128/128: Enabled: $ciperRC2128EH`r"
            }
        }
        Else {
            Write-host "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC256128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
        If ($cipherRC256128 -eq "True") {
            $cipherRC256128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
            If($cipherRC256128E.Enabled -eq $null) {
                Write-host "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC256128EH = $cipherRC256128E.Enabled
                Write-host "RC2 56/128: Enabled: $ciperRC256128EH`r"
				Add-Content .\result.txt -value "RC2 56/128: Enabled: $ciperRC256128EH`r"
            }
        }
        Else {
            Write-host "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC240128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
        If ($cipherRC240128 -eq "True") {
            $cipherRC240128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
            If($cipherRC240128E.Enabled -eq $null) {
                Write-host "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC240128EH = $cipherRC240128E.Enabled
                Write-host "RC2 40/128: Enabled: $ciperRC240128EH`r"
				Add-Content .\result.txt -value "RC2 40/128: Enabled: $ciperRC240128EH`r"
            }
        }
        Else {
            Write-host "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC25656 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
        If ($cipherRC25656 -eq "True") {
            $cipherRC25656E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
            If($cipherRC25656E.Enabled -eq $null) {
                Write-host "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
				Add-Content .\result.txt -value "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            }
            Else {
                $cipherRC25656EH = $cipherRC25656E.Enabled
                Write-host "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
				Add-Content .\result.txt -value "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
            }
        }
        Else {
            Write-host "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
            Add-Content .\result.txt -value "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
        }
		Write-host "[00010002 Group Policy Cipher Reg Key Values]`r`n"
		Add-Content .\result.txt -value "[00010002 Group Policy Cipher Reg Key Values]`r`n"
		$cryptSSLGTest = Test-path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
		If ($cryptSSLGTest -eq "True") {
			If ($cryptSSLGTest.EccCurves -eq $null -And $cryptSSLG.Functions -eq $null){
				Write-Host "Group Policy is not set.  Local values will be used listed below.`r`n`n"
				Add-Content .\result.txt -value "Group Policy is not set.  Local values will be used listed below.`r`n`n"
				Write-host "[00010002 Local Cipher Reg Key Values]`r`n"
				Add-Content .\result.txt -value "[00010002 Local Cipher Reg Key Values]`r`n"
				$cryptSSLTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
				If ($cryptSSLTest -eq "True") {
					$cryptSSL = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
					If($cryptSSL.EccCurves -eq $null) {
						Write-host "EccCurves: Value is NULL!`r`n"
						Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
					}
					Else {
						$cryptSSLH = $cryptSSL.EccCurves
						Write-host "EccCurves: $cryptSSLH`r`n"
						Add-Content .\result.txt -value "EccCurves: $cryptSSLH`r`n"
					}
					If($cryptSSL.Functions -eq $null) {
						Write-host "Functions: Value is NULL!`r`n`n"
						Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
					}
					Else {
						$cryptSSLF = $cryptSSL.Functions
						Write-host "Functions: $cryptSSLF`r`n`n"
						Add-Content .\result.txt -value "Functions: $cryptSSLF`r`n`n"
					}
				}
				Else {
					Write-host "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
					Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
				}
			}
			Else {
				$cryptSSLG = Get-ItemProperty -path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
				If($cryptSSLG.EccCurves -eq $null) {
					Write-host "EccCurves: Value is NULL!`r`n"
					Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
				}
				Else {
					$cryptSSLGH = $cryptSSL.EccCurves
					Write-host "EccCurves: $cryptSSLGH`r`n"
					Add-Content .\result.txt -value "EccCurves: $cryptSSLGH`r`n"
				}
				If($cryptSSLG.Functions -eq $null) {
					Write-host "Functions: Value is NULL!`r`n`n"
					Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
				}
				Else {
					$cryptSSLGF = $cryptSSL.Functions
					Write-host "Functions: $cryptSSLGF`r`n`n"
					Add-Content .\result.txt -value "Functions: $cryptSSLGF`r`n`n"
				}
			}
		}
		Else {
			Write-host "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
			Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
		}
    }
	Write-Host "[Fips Algorithm]`r`n"
	Add-Content .\result.txt -value "[Fips Algorithm]`r`n"
	$fipsAlgo = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
    If ($fipsAlgo -eq "True") {
        $fipsAlgoE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
        If($fipsAlgoE.Enabled -eq $null -And $fipsAlgoE.MDMEnabled -eq $null) {
            Write-Host "Disabled! Someone deleted values manually.  Please add REG_DWORD Values: Enabled: 0, MDMEnabled: 0 to correct."
			Add-Content .\result.txt -value "Disabled! Someone deleted values manually.  Please add REG_DWORD Values: Enabled: 0, MDMEnabled: 0 to correct."
        }
        ElseIf ($fipsAlgoE.Enabled -eq 0 -And $fipsAlgoE.MDMEnabled -eq 0){
            $fipsAlgoEH = $fipsAlgoE.Enabled
            Write-Host "Fips and MDM are both Disabled."
			Add-Content .\result.txt -value "Fips and MDM are both Disabled."
        }
		Else {
            If($fipsAlgoE.Enabled -eq $null){
                Write-Host "Fips value set to Null.  Not enabled.`r"
                Add-Content .\result.txt -value "Fips value set to Null. Not enabled.`r"
            }
            Else {
                $fipsAlgoEF = $fipsAlgoE.Enabled
                $fipsAlgoEHex = "{0:x8}" -f $fipsAlgoEF
                Write-Host "Fips Value set to Enabled: 0x$fipsAlgoEHex`r"
			    Add-Content .\result.txt -value "Fips Value set to Enabled: 0x$fipsAlgoEHex`r"
            }

            If($fipsAlgoE.MDMEnabled -eq $null){
                Write-Host "MDMEnabled value is set to Null. Not enabled.`r`n`n"
                Add-Content .\result.txt -value "MDMEnabled value is set to Null.  Not enabled.`r`n`n"
            }
            Else {
			    $fipsAlgoEC = $fipsAlgoE.MDMEnabled
			    $fipsAlgoECHex = "{0:x8}" -f $fipsAlgoEC
			    Write-Host "MDMEnabled Value set to Enabled: 0x$fipsAlgoECHex`r`n`n"
			    Add-Content .\result.txt -value "MDMEnabled Value set to Enabled: 0x$fipsAlgoECHex`r`n`n"
            }
		}
    }
    Else {
        Write-host "FipsAlgorithmPolicy Reg Key has been removed manually!  Please re-add the Reg Key! HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy]`r`n`n"
        Add-Content .\result.txt -value "FipsAlgorithmPolicy Reg Key has been removed manually!  Please re-add the Reg Key! HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy]`r`n`n"
    }

    Write-host "[WinHTTP Settings]`r`n"
    Add-Content .\result.txt -value "[WinHTTP Settings]`r`n"
    $IsKB3140245Installed = get-hotfix -id KB3140245 -EA SilentlyContinue
    $Hotfix = $IsKB3140245Installed.HotFixID
    If ($Hotfix -eq "KB3140245") {
        Write-host "KB3140245 detected.  WinHTTP values do apply!`r`n" 
        Add-Content .\result.txt -value "KB3140245 detected.  WinHTTP values do apply!`r`n" 

        If([System.IntPtr]::Size -eq 8) {
           $winHTTPSet = Test-Path $WinHttpDefaultSecureProtocols
           If($winHTTPSet -eq "True") {
               $winHTTPSetE = Get-ItemProperty -path "HKCU:\\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
               If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                   Write-Host "WinHTTP Key for 64-Bit is present.  Value is not.  Not enforced."
                   Add-Content .\result.txt -value "WinHTTP Key for 64-Bit is present.  Value is not.  Not enforced."
               }
               Else{
                   $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                   $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                   Write-Host "WinHTTP 64-Bit Key: $winHTTPSetEFHex`r"
                   Add-Content .\result.txt -value "WinHTTP 64-Bit Key: $winHTTPSetEFHex`r"
               }
           }
           Else {
               Write-Host "WinHTTP 64-bit Key is not present.`r"
               Add-Content .\result.txt -value "WinHTTP 64-bit Key is not present.`r"
           }
           $winHTTPSet = Test-path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
           If($winHTTPSet -eq "True") {
               $winHTTPSetE = Get-ItemProperty -path $X32WinHttpDefaultSecureProtocols
               If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                   Write-Host "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
                   Add-Content .\result.txt -value "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
               }
               Else{
                   $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                   $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                   Write-Host "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
                   Add-Content .\result.txt -value "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
               }
           }
           Else {
               Write-Host "WinHTTP 32-bit Key is not present.`r`n"
               Add-Content .\result.txt -value "WinHTTP 32-bit Key is not present.`r`n"
           }
        }
        Else {
           $winHTTPSet = Test-path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
           If($winHTTPSet -eq "True") {
               $winHTTPSetE = Get-ItemProperty -path $X32WinHttpDefaultSecureProtocols
               If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                   Write-Host "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
                   Add-Content .\result.txt -value "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
               }
               Else{
                   $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                   $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                   Write-Host "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
                   Add-Content .\result.txt -value "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
               }
           }
           Else {
               Write-Host "WinHTTP 32-bit Key is not present.`r`n"
               Add-Content .\result.txt -value "WinHTTP 32-bit Key is not present.`r`n"
           }        
        }
        Write-host "WinHTTP value requires XOR'ing.  XOR values below to allow multiple protocols: Example: 0xa80`r"
        Add-Content .\result.txt -value "WinHTTP value requires XOR'ing.  XOR values below to allow multiple protocols: Example: 0xa80`r"
        Write-host "0x00000008 - Enable SSL 2.0`r"
        Add-Content .\result.txt -value "0x00000008 - Enable SSL 2.0`r"
        Write-host "0x00000020 - Enable SSL 3.0`r"
        Add-Content .\result.txt -value "0x00000020 - Enable SSL 3.0`r"
        Write-host "0x00000080 - Enable TLS 1.0`r"
        Add-Content .\result.txt -value "0x00000080 - Enable TLS 1.0`r"
        Write-host "0x00000200 - Enable TLS 1.1`r"
        Add-Content .\result.txt -value "0x00000200 - Enable TLS 1.1`r"
        Write-host "0x00000800 - Enable TLS 1.2`r`n"
        Add-Content .\result.txt -value "0x00000800 - Enable TLS 1.2`r`n"
            
    
	}
    Else {
        Write-host "DefaultSecureProtocol does not apply."
        Add-Content .\result.txt -value "DefaultSecureProtocol does not apply."
    }
}
ElseIf ($osversionMajor -eq 6 -And $osversionMinor -eq 3) {
    Write-host "[Hostname] = $hostname`r"
    Add-Content .\result.txt -value "[Hostname] = $hostname`r"
    Write-host "[Machine Version] = Windows 8.1 or Server 2012R2`r"
    Add-Content .\result.txt -value "[Machine Version] = Windows 8/8.1 or Server 2012/2012R2`r"
    if ([System.IntPtr]::Size -eq 4) {
        Write-host "[Architecture] = 32-bit`r`n`n"
        Add-Content .\result.txt -value "[Architecture] = 32-bit`r`n`n" 
    } 
    else {
        Write-host "[Architecture] = 64-bit`r`n`n"
        Add-Content .\result.txt -value "[Architecture] = 64-bit`r`n`n"
    }
    Write-host "[Client Keys]`r`n"
    Add-Content .\result.txt -value "[Client Keys]`r`n"

    $ssl20CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
    If ($ssl20CTest -eq "True") {
        $ssl20C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
        If($ssl20C.DisabledByDefault -eq $null) {
            Write-host "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
	        Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl20CH = $ssl20C.DisabledByDefault
            Write-host "SSL 2.0: DisabledByDefault: $ssl20CH`r"
	        Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: $ssl20CH`r"
        }
        If($ssl20C.Enabled -eq $null) {
            Write-host "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
	        Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl20CH = $ssl20C.Enabled
            Write-host "SSL 2.0: Enabled: $ssl20CH`r`n"
	        Add-Content .\result.txt -value "SSL 2.0: Enabled: $ssl20CH`r`n"
        }
    }
    Else {
        Write-host "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
    }   
    $ssl30CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
    If ($ssl30CTest -eq "True") {
        $ssl30C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
        If($ssl30C.DisabledByDefault -eq $null) {
            Write-host "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
	    Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl30CH = $ssl30C.DisabledByDefault
            Write-host "SSL 3.0: DisabledByDefault: $ssl20CH`r"
	    Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: $ssl20CH`r"
        }
        If($ssl30C.Enabled -eq $null) {
            Write-host "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl30CH = $ssl30C.Enabled
            Write-host "SSL 3.0: Enabled: $ssl30CH`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: $ssl30CH`r`n"
        }
    }
    Else {
        Write-host "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $tls10CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
    If ($tls10CTest -eq "True") {
        $tls10C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
        If($tls10C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
	    Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls10CH = $tls10C.DisabledByDefault
            Write-host "TLS 1.0: DisabledByDefault: $tls10CH`r"
	    Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: $tls10CH`r"
        }
        If($tls10C.Enabled -eq $null) {
            Write-host "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls10CH = $tls10C.Enabled
            Write-host "TLS 1.0: Enabled: $tls10CH`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: $tls10CH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls11CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
    If ($tls11CTest -eq "True") {
        $tls11C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
        If($tls11C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
	    Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls11CH = $tls11C.DisabledByDefault
            Write-host "TLS 1.1: DisabledByDefault: $tls11CH`r"
	    Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: $tls11CH`r"
        }
        If($tls11C.Enabled -eq $null) {
            Write-host "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls11CH = $tls11C.Enabled
            Write-host "TLS 1.1: Enabled: $tls11CH`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: $tls11CH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls12CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
    If ($tls12CTest -eq "True") {
        $tls12C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
        If($tls12C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls12CH = $tls12C.DisabledByDefault
            Write-host "TLS 1.2: DisabledByDefault: $tls12CH`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: $tls12CH`r"
        }
        If($tls12C.Enabled -eq $null) {
            Write-host "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
        }
        Else {
            $tls12CH = $tls12C.Enabled
            Write-host "TLS 1.2: Enabled: $tls12CH`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: $tls12CH`r`n`n"
        }
    }
    Else {
        Write-host "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
        Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
    }

    Write-host "[Server Keys]`r`n"
    Add-Content .\result.txt -value "[Server Keys]`r`n"
    $ssl20STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
    If ($ssl20STest -eq "True") {
        $ssl20S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
        If($ssl20S.DisabledByDefault -eq $null) {
            Write-host "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
	    Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl20SH = $ssl20S.DisabledByDefault
            Write-host "SSL 2.0: DisabledByDefault: $ssl20SH`r"
	    Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: $ssl20SH`r"
        }
        If($ssl20S.Enabled -eq $null) {
            Write-host "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl20SH = $ssl20S.Enabled
            Write-host "SSL 2.0: Enabled: $ssl20SH`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: $ssl20SH`r`n"
        }
    }
    Else {
        Write-host "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, Registry folder key not present. Using OS Default.`r`n"
    }   
    $ssl30STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
    If ($ssl30STest -eq "True") {
        $ssl30S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
        If($ssl30S.DisabledByDefault -eq $null) {
            Write-host "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
	    Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl30SH = $ssl30S.DisabledByDefault
            Write-host "SSL 3.0: DisabledByDefault: $ssl30SH`r"
	    Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: $ssl30SH`r"
        }
        If($ssl30S.Enabled -eq $null) {
            Write-host "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl30SH = $ssl30S.Enabled
            Write-host "SSL 3.0: Enabled: $ssl30SH`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: $ssl30SH`r`n"
        }
    }
    Else {
        Write-host "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $tls10STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
    If ($tls10STest -eq "True") {
        $tls10S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
        If($tls10S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
	    Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls10SH = $tls10S.DisabledByDefault
            Write-host "TLS 1.0: DisabledByDefault: $tls10SH`r"
	    Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: $tls10SH`r"
        }
        If($tls10S.Enabled -eq $null) {
            Write-host "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls10SH = $tls10S.Enabled
            Write-host "TLS 1.0: Enabled: $tls10SH`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: $tls10SH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls11STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
    If ($tls11STest -eq "True") {
        $tls11S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
        If($tls11S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls11SH = $tls11S.DisabledByDefault
            Write-host "TLS 1.1: DisabledByDefault: $tls11SH`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: $tls11SH`r"
        }
        If($tls11S.Enabled -eq $null) {
            Write-host "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls11SH = $tls11S.Enabled
            Write-host "TLS 1.1: Enabled: $tls11SH`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: $tls11SH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls12STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
    If ($tls12STest -eq "True") {
        $tls12S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
        If($tls12S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls12SH = $tls12S.DisabledByDefault
            Write-host "TLS 1.2: DisabledByDefault: $tls12SH`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: $tls12SH`r"
        }
        If($tls12S.Enabled -eq $null) {
            Write-host "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
        }
        Else {
            $tls12SH = $tls12S.Enabled
            Write-host "TLS 1.2: Enabled: $tls12SH`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: $tls12SH`r`n`n"
        }
    }
    Else {
        Write-host "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
        Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
    }
    Write-Host "[KeyExchangeAlgorithms]`r`n"
    Add-Content .\result.txt -value "[KeyExchangeAlgorithms]`r`n"
    $keyExchangeAlgo = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms"
    If( $keyExchangeAlgo -eq "True" ) {
        $PKCS = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\PKCS"
        If( $PKCS -eq "True" ) {
            $PKCSE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\PKCS"
        
            If ( $PKCSE.Enabled -eq $null ) {
                Write-Host "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed.  Value not set.`r`n`n"
                Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed.  Value not set.`r`n`n"
            }
            ElseIf( $PKCSE.Enabled -eq 0 ) {
                Write-Host "WARNING!!! PKCS is disabled.  No RSA-based SSL and TLS cipher suites will be allowed!`r`n`n"
                Add-Content .\result.txt -value "WARNING!!! PKCS is disabled.  No RSA-based SSL and TLS cipher suites will be allowed!`r`n`n"
            }
            Else {
                $PKCSEH = $PKCSE.Enabled
                $PKCSEHex = "{0:x8}" -f $PKCSEH
                Write-Host "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed. Value set to: 0x$PKCSEHex`r`n`n"
                Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed. Value set to: 0x$PKCSEHex`r`n`n"
            }
        }
        Else {
            Write-host "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
            Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
        }
    }
    Else {
       Write-host "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
       Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
    }
    Write-Host "[Hashes]`r`n"
    Add-Content .\result.txt -value "[Hashes]`r`n"
    $md5 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5"
    If( $md5 -eq "True" ) {
        $md5E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5\"
        If ( $md5E.Enabled -eq $null ) {
            Write-Host "MD5 Cipher Hashes are enabled. Value not set.`r"
            Add-Content .\result.txt -value "MD5 Cipher Hashes are enabled. Value not set.`r"
        }
        ElseIf( $md5E.Enabled -eq 0 ) {
            Write-Host "WARNING!!! MD5 based Cipher Suites have been disabled!`r"
            Add-Content .\result.txt -value "WARNING!!! MD5 based Cipher Suites have been disabled!`r"
        }
        Else {
            $md5EH = $md5E.Enabled
            $md5EHex = "{0:x8}" -f $md5EH
            Write-Host "Md5 Cipher Hashes are enabled.  Value set to: 0x$md5EHex`r"
			Add-Content .\result.txt -value "Md5 Cipher Hashes are enabled.  Value set to: 0x$md5EHex`r"
        }
    }
    Else {
       Write-host "MD5 Cipher Hashes are enabled.  Reg Key not present.`r"
       Add-Content .\result.txt -value "MD5 Cipher Hashes are enabled.  Reg Key not present.`r"
    }
    $SHA = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA"
    If( $SHA -eq "True" ) {
        $SHAE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA"
        If ( $SHAE.Enabled -eq $null ) {
            Write-Host "SHA-1 Cipher Hashes are enabled. Value not set.`r`n`n"
            Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled. Value not set.`r`n`n"
        }
        ElseIf( $SHAE.Enabled -eq 0 ) {
            Write-Host "WARNING!!! SHA-1 based Cipher Suites have been disabled!`r`n`n"
            Add-Content .\result.txt -value "WARNING!!! SHA-1 based Cipher Suites have been disabled!`r`n`n"
        }
        Else {
            $SHAEH = $SHAE.Enabled
            $SHAEHex = "{0:x8}" -f $SHAEH
            Write-Host "SHA-1 Cipher Hashes are enabled.  Value set to: 0x$SHAEHex`r`n`n"
            Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled.  Value set to: 0x$SHAEHex`r`n`n"
        }
    }
    Else {
       Write-host "SHA-1 Cipher Hashes are enabled.  Reg Key not present.`r`n`n"
       Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled.  Reg Key not present.`r`n`n"
    }
    Write-host "[Cipher Suites]`r`n"
    Add-Content .\result.txt -value "[Cipher Suites]`r`n"
    $nullValue = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL"
    if ($nullValue -eq "True") {
        $nullValueE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL"
        If($nullValueE.Enabled -eq $null -Or $nullValueE.Enabled -eq 0) {
            Write-host "Null is not set. Cipher Suites can be used.`r`n"
            Add-Content .\result.txt -value "Null is not set. Cipher Suites can be used.`r`n"
            $cipherAES256 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
            If ($cipherAES256 -eq "True") {
                $cipherAES256E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
                If($cipherAES256E.Enabled -eq $null) {
                    Write-host "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherAES256EH = $cipherAES256E.Enabled
                    Write-host "AES 256: Enabled: $ciperAES256EH`r"
					Add-Content .\result.txt -value "AES 256: Enabled: $ciperAES256EH`r"
                }
            }
            Else {
                Write-host "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherAES128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
            If ($cipherAES128 -eq "True") {
                $cipherAES128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
                If($cipherAES128E.Enabled -eq $null) {
                    Write-host "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherAES128EH = $cipherAES128E.Enabled
                    Write-host "AES 128: Enabled: $ciperAES128EH`r"
					Add-Content .\result.txt -value "AES 128: Enabled: $ciperAES128EH`r"
                }
            }
            Else {
                Write-host "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherDES56 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
            If ($cipherDES56 -eq "True") {
                $cipherDES56E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
                If($cipherDES56E.Enabled -eq $null) {
                    Write-host "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherDES56EH = $cipherDES56E.Enabled
                    Write-host "DES 56: Enabled: $ciperDES56EH`r"
					Add-Content .\result.txt -value "DES 56: Enabled: $ciperDES56EH`r"
                }
            }
            Else {
                Write-host "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC4128128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
            If ($cipherRC4128128 -eq "True") {
                $cipherRC4128128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
                If($cipherRC4128128E.Enabled -eq $null) {
                    Write-host "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC4128128EH = $cipherRC4128128E.Enabled
                    Write-host "RC4 128/128: Enabled: $ciperRC4128128EH`r"
					Add-Content .\result.txt -value "RC4 128/128: Enabled: $ciperRC4128128EH`r"
                }
            }
            Else {
                Write-host "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC464 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
            If ($cipherRC464 -eq "True") {
                $cipherRC464E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
                If($cipherRC464E.Enabled -eq $null) {
                    Write-host "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC464EH = $cipherRC464E.Enabled
                    Write-host "RC4 64/128: Enabled: $ciperRC464EH`r"
					Add-Content .\result.txt -value "RC4 64/128: Enabled: $ciperRC464EH`r"
                }
            }
            Else {
                Write-host "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC456 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
            If ($cipherRC456 -eq "True") {
                $cipherRC456E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
                If($cipherRC456E.Enabled -eq $null) {
                    Write-host "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC456EH = $cipherRC456E.Enabled
                    Write-host "RC4 56/128: Enabled: $ciperRC456EH`r"
					Add-Content .\result.txt -value "RC4 56/128: Enabled: $ciperRC456EH`r"
                }
            }
            Else {
                Write-host "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC440 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
            If ($cipherRC440 -eq "True") {
                $cipherRC440E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
                If($cipherRC440E.Enabled -eq $null) {
                    Write-host "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC440EH = $cipherRC440E.Enabled
                    Write-host "RC4 40/128: Enabled: $ciperRC440EH`r"
					Add-Content .\result.txt -value "RC4 40/128: Enabled: $ciperRC440EH`r"
                }
            }
            Else {
                Write-host "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipher3DES168 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
            If ($cipher3DES168 -eq "True") {
                $cipher3DES168E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
                If($cipher3DES168E.Enabled -eq $null) {
                    Write-host "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipher3DES168EH = $cipher3DES168E.Enabled
                    Write-host "Triple DES 168: Enabled: $ciper3DES168EH`r"
					Add-Content .\result.txt -value "Triple DES 168: Enabled: $ciper3DES168EH`r"
                }
            }
            Else {
                Write-host "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC2128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
            If ($cipherRC2128 -eq "True") {
                $cipherRC2128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
                If($cipherRC2128E.Enabled -eq $null) {
                    Write-host "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC2128EH = $cipherRC2128E.Enabled
                    Write-host "RC2 128/128: Enabled: $ciperRC2128EH`r"
					Add-Content .\result.txt -value "RC2 128/128: Enabled: $ciperRC2128EH`r"
                }
            }
            Else {
                Write-host "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC256128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
            If ($cipherRC256128 -eq "True") {
                $cipherRC256128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
                If($cipherRC256128E.Enabled -eq $null) {
                    Write-host "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC256128EH = $cipherRC256128E.Enabled
                    Write-host "RC2 56/128: Enabled: $ciperRC256128EH`r"
					Add-Content .\result.txt -value "RC2 56/128: Enabled: $ciperRC256128EH`r"
                }
            }
            Else {
                Write-host "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC240128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
            If ($cipherRC240128 -eq "True") {
                $cipherRC240128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
                If($cipherRC240128E.Enabled -eq $null) {
                    Write-host "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC240128EH = $cipherRC240128E.Enabled
                    Write-host "RC2 40/128: Enabled: $ciperRC240128EH`r"
					Add-Content .\result.txt -value "RC2 40/128: Enabled: $ciperRC240128EH`r"
                }
            }
            Else {
                Write-host "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC25656 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
            If ($cipherRC25656 -eq "True") {
                $cipherRC25656E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
                If($cipherRC25656E.Enabled -eq $null) {
                    Write-host "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
					Add-Content .\result.txt -value "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
                }
                Else {
                    $cipherRC25656EH = $cipherRC25656E.Enabled
                    Write-host "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
					Add-Content .\result.txt -value "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
                }
            }
            Else {
                Write-host "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
                Add-Content .\result.txt -value "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
            }
			Write-host "[00010002 Group Policy Cipher Reg Key Values]`r`n"
			Add-Content .\result.txt -value "[00010002 Group Policy Cipher Reg Key Values]`r`n"
			$cryptSSLGTest = Test-path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
			If ($cryptSSLGTest -eq "True") {
				If ($cryptSSLGTest.EccCurves -eq $null -And $cryptSSLG.Functions -eq $null){
					Write-Host "Group Policy is not set.  Local values will be used listed below.`r`n`n"
					Add-Content .\result.txt -value "Group Policy is not set.  Local values will be used listed below.`r`n`n"
					Write-host "[00010002 Local Cipher Reg Key Values]`r`n"
					Add-Content .\result.txt -value "[00010002 Local Cipher Reg Key Values]`r`n"
					$cryptSSLTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
					If ($cryptSSLTest -eq "True") {
						$cryptSSL = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
						If($cryptSSL.EccCurves -eq $null) {
							Write-host "EccCurves: Value is NULL!`r`n"
							Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
						}
						Else {
							$cryptSSLH = $cryptSSL.EccCurves
							Write-host "EccCurves: $cryptSSLH`r`n"
							Add-Content .\result.txt -value "EccCurves: $cryptSSLH`r`n"
						}
						If($cryptSSL.Functions -eq $null) {
							Write-host "Functions: Value is NULL!`r`n`n"
							Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
						}
						Else {
							$cryptSSLF = $cryptSSL.Functions
							Write-host "Functions: $cryptSSLF`r`n`n"
							Add-Content .\result.txt -value "Functions: $cryptSSLF`r`n`n"
						}
					}
					Else {
						Write-host "WARNING! REGISTRY KEY NOT PRESENT!  This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
						Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT!  This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
					}
				}
				Else {
					$cryptSSLG = Get-ItemProperty -path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
					If($cryptSSLG.EccCurves -eq $null) {
						Write-host "EccCurves: Value is NULL!`r`n"
						Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
					}
					Else {
						$cryptSSLGH = $cryptSSL.EccCurves
						Write-host "EccCurves: $cryptSSLGH`r`n"
						Add-Content .\result.txt -value "EccCurves: $cryptSSLGH`r`n"
					}
					If($cryptSSLG.Functions -eq $null) {
						Write-host "Functions: Value is NULL!`r`n`n"
						Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
					}
					Else {
						$cryptSSLGF = $cryptSSL.Functions
						Write-host "Functions: $cryptSSLGF`r`n`n"
						Add-Content .\result.txt -value "Functions: $cryptSSLGF`r`n`n"
					}
				}
			}
			Else {
				Write-host "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
				Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
			}
        }
        Else {
            $nullValueEH = $nullValueE.Enabled
            Write-Host "WARNING!!!  NULL is enabled!  No Cipher Suites are enabled regardless of Reg Key Set or Not!`r`n"
			Add-Content .\result.txt -value "WARNING!!!  NULL is enabled!  No Cipher Suites are enabled regardless of Reg Key Set or Not!`r`n"
        }
    }
    Else {
        Write-host "Null Reg Key not present.  Cipher Suites can be used.`r`n"
        Add-Content .\result.txt -value "Null Reg Key not present.  Cipher Suites can be used.`r`n"
        $cipherAES256 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
        If ($cipherAES256 -eq "True") {
            $cipherAES256E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
            If($cipherAES256E.Enabled -eq $null) {
                Write-host "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherAES256EH = $cipherAES256E.Enabled
                Write-host "AES 256: Enabled: $ciperAES256EH`r"
				Add-Content .\result.txt -value "AES 256: Enabled: $ciperAES256EH`r"
            }
        }
        Else {
            Write-host "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherAES128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
        If ($cipherAES128 -eq "True") {
            $cipherAES128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
            If($cipherAES128E.Enabled -eq $null) {
                Write-host "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherAES128EH = $cipherAES128E.Enabled
                Write-host "AES 128: Enabled: $ciperAES128EH`r"
				Add-Content .\result.txt -value "AES 128: Enabled: $ciperAES128EH`r"
            }
        }
        Else {
            Write-host "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherDES56 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
        If ($cipherDES56 -eq "True") {
            $cipherDES56E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
            If($cipherDES56E.Enabled -eq $null) {
                Write-host "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherDES56EH = $cipherDES56E.Enabled
                Write-host "DES 56: Enabled: $ciperDES56EH`r"
				Add-Content .\result.txt -value "DES 56: Enabled: $ciperDES56EH`r"
            }
        }
        Else {
            Write-host "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC4128128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
        If ($cipherRC4128128 -eq "True") {
            $cipherRC4128128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
            If($cipherRC4128128E.Enabled -eq $null) {
                Write-host "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC4128128EH = $cipherRC4128128E.Enabled
                Write-host "RC4 128/128: Enabled: $ciperRC4128128EH`r"
				Add-Content .\result.txt -value "RC4 128/128: Enabled: $ciperRC4128128EH`r"
            }
        }
        Else {
            Write-host "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC464 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
        If ($cipherRC464 -eq "True") {
            $cipherRC464E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
            If($cipherRC464E.Enabled -eq $null) {
                Write-host "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC464EH = $cipherRC464E.Enabled
                Write-host "RC4 64/128: Enabled: $ciperRC464EH`r"
				Add-Content .\result.txt -value "RC4 64/128: Enabled: $ciperRC464EH`r"
            }
        }
        Else {
            Write-host "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC456 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
        If ($cipherRC456 -eq "True") {
            $cipherRC456E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
            If($cipherRC456E.Enabled -eq $null) {
                Write-host "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC456EH = $cipherRC456E.Enabled
                Write-host "RC4 56/128: Enabled: $ciperRC456EH`r"
				Add-Content .\result.txt -value "RC4 56/128: Enabled: $ciperRC456EH`r"
            }
        }
        Else {
            Write-host "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC440 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
        If ($cipherRC440 -eq "True") {
            $cipherRC440E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
            If($cipherRC440E.Enabled -eq $null) {
                Write-host "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC440EH = $cipherRC440E.Enabled
                Write-host "RC4 40/128: Enabled: $ciperRC440EH`r"
				Add-Content .\result.txt -value "RC4 40/128: Enabled: $ciperRC440EH`r"
            }
        }
        Else {
            Write-host "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipher3DES168 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
        If ($cipher3DES168 -eq "True") {
            $cipher3DES168E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
            If($cipher3DES168E.Enabled -eq $null) {
                Write-host "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipher3DES168EH = $cipher3DES168E.Enabled
                Write-host "Triple DES 168: Enabled: $ciper3DES168EH`r"
				Add-Content .\result.txt -value "Triple DES 168: Enabled: $ciper3DES168EH`r"
            }
        }
        Else {
            Write-host "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC2128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
        If ($cipherRC2128 -eq "True") {
            $cipherRC2128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
            If($cipherRC2128E.Enabled -eq $null) {
                Write-host "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC2128EH = $cipherRC2128E.Enabled
                Write-host "RC2 128/128: Enabled: $ciperRC2128EH`r"
				Add-Content .\result.txt -value "RC2 128/128: Enabled: $ciperRC2128EH`r"
            }
        }
        Else {
            Write-host "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC256128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
        If ($cipherRC256128 -eq "True") {
            $cipherRC256128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
            If($cipherRC256128E.Enabled -eq $null) {
                Write-host "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC256128EH = $cipherRC256128E.Enabled
                Write-host "RC2 56/128: Enabled: $ciperRC256128EH`r"
				Add-Content .\result.txt -value "RC2 56/128: Enabled: $ciperRC256128EH`r"
            }
        }
        Else {
            Write-host "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC240128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
        If ($cipherRC240128 -eq "True") {
            $cipherRC240128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
            If($cipherRC240128E.Enabled -eq $null) {
                Write-host "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC240128EH = $cipherRC240128E.Enabled
                Write-host "RC2 40/128: Enabled: $ciperRC240128EH`r"
				Add-Content .\result.txt -value "RC2 40/128: Enabled: $ciperRC240128EH`r"
            }
        }
        Else {
            Write-host "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC25656 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
        If ($cipherRC25656 -eq "True") {
            $cipherRC25656E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
            If($cipherRC25656E.Enabled -eq $null) {
                Write-host "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
				Add-Content .\result.txt -value "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            }
            Else {
                $cipherRC25656EH = $cipherRC25656E.Enabled
                Write-host "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
				Add-Content .\result.txt -value Write-host "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
            }
        }
        Else {
            Write-host "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
            Add-Content .\result.txt -value "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
        }
		Write-host "[00010002 Group Policy Cipher Reg Key Values]`r`n"
		Add-Content .\result.txt -value "[00010002 Group Policy Cipher Reg Key Values]`r`n"
		$cryptSSLGTest = Test-path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
		If ($cryptSSLGTest -eq "True") {
			If ($cryptSSLGTest.EccCurves -eq $null -And $cryptSSLG.Functions -eq $null){
				Write-Host "Group Policy is not set.  Local values will be used listed below.`r`n`n"
				Add-Content .\result.txt -value "Group Policy is not set.  Local values will be used listed below.`r`n`n"
				Write-host "[00010002 Local Cipher Reg Key Values]`r`n"
				Add-Content .\result.txt -value "[00010002 Local Cipher Reg Key Values]`r`n"
				$cryptSSLTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
				If ($cryptSSLTest -eq "True") {
					$cryptSSL = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
					If($cryptSSL.EccCurves -eq $null) {
						Write-host "EccCurves: Value is NULL!`r`n"
						Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
					}
					Else {
						$cryptSSLH = $cryptSSL.EccCurves
						Write-host "EccCurves: $cryptSSLH`r`n"
						Add-Content .\result.txt -value "EccCurves: $cryptSSLH`r`n"
					}
					If($cryptSSL.Functions -eq $null) {
						Write-host "Functions: Value is NULL!`r`n`n"
						Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
					}
					Else {
						$cryptSSLF = $cryptSSL.Functions
						Write-host "Functions: $cryptSSLF`r`n`n"
						Add-Content .\result.txt -value "Functions: $cryptSSLF`r`n`n"
					}
				}
				Else {
					Write-host "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
					Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
				}
			}
			Else {
				$cryptSSLG = Get-ItemProperty -path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
				If($cryptSSLG.EccCurves -eq $null) {
					Write-host "EccCurves: Value is NULL!`r`n"
					Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
				}
				Else {
					$cryptSSLGH = $cryptSSL.EccCurves
					Write-host "EccCurves: $cryptSSLGH`r`n"
					Add-Content .\result.txt -value "EccCurves: $cryptSSLGH`r`n"
				}
				If($cryptSSLG.Functions -eq $null) {
					Write-host "Functions: Value is NULL!`r`n`n"
					Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
				}
				Else {
					$cryptSSLGF = $cryptSSL.Functions
					Write-host "Functions: $cryptSSLGF`r`n`n"
					Add-Content .\result.txt -value "Functions: $cryptSSLGF`r`n`n"
				}
			}
		}
		Else {
			Write-host "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
			Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
		}
    }
	Write-Host "[Fips Algorithm]`r`n"
	Add-Content .\result.txt -value "[Fips Algorithm]`r`n"
	$fipsAlgo = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
    If ($fipsAlgo -eq "True") {
        $fipsAlgoE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
        If($fipsAlgoE.Enabled -eq $null -And $fipsAlgoE.MDMEnabled -eq $null) {
            Write-Host "Disabled! Someone deleted values manually.  Please add REG_DWORD Values: Enabled: 0, MDMEnabled: 0 to correct."
			Add-Content .\result.txt -value "Disabled! Someone deleted values manually.  Please add REG_DWORD Values: Enabled: 0, MDMEnabled: 0 to correct."
        }
        ElseIf ($fipsAlgoE.Enabled -eq 0 -And $fipsAlgoE.MDMEnabled -eq 0){
            $fipsAlgoEH = $fipsAlgoE.Enabled
            Write-Host "Fips and MDM are both Disabled."
			Add-Content .\result.txt -value "Fips and MDM are both Disabled."
        }
		Else {
            If($fipsAlgoE.Enabled -eq $null){
                Write-Host "Fips value set to Null.  Not enabled.`r"
                Add-Content .\result.txt -value "Fips value set to Null. Not enabled.`r"
            }
            Else {
                $fipsAlgoEF = $fipsAlgoE.Enabled
                $fipsAlgoEHex = "{0:x8}" -f $fipsAlgoEF
                Write-Host "Fips Value set to Enabled: 0x$fipsAlgoEHex`r"
			    Add-Content .\result.txt -value "Fips Value set to Enabled: 0x$fipsAlgoEHex`r"
            }

            If($fipsAlgoE.MDMEnabled -eq $null){
                Write-Host "MDMEnabled value is set to Null. Not enabled.`r`n`n"
                Add-Content .\result.txt -value "MDMEnabled value is set to Null.  Not enabled.`r`n`n"
            }
            Else {
			    $fipsAlgoEC = $fipsAlgoE.MDMEnabled
			    $fipsAlgoECHex = "{0:x8}" -f $fipsAlgoEC
			    Write-Host "MDMEnabled Value set to Enabled: 0x$fipsAlgoECHex`r`n`n"
			    Add-Content .\result.txt -value "MDMEnabled Value set to Enabled: 0x$fipsAlgoECHex`r`n`n"
            }
		}
    }
    Else {
        Write-host "FipsAlgorithmPolicy Reg Key has been removed manually!  Please re-add the Reg Key! HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy]`r`n`n"
        Add-Content .\result.txt -value "FipsAlgorithmPolicy Reg Key has been removed manually!  Please re-add the Reg Key! HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy]`r`n`n"
    }
    Write-Host "[WinHTTP Settings]`r`n"
    Add-Content .\result.txt -value "[WinHTTP Settings]`r`n"
    If([System.IntPtr]::Size -eq 8) {
        $winHTTPSet = Test-path "HKCU:\\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
        If($winHTTPSet -eq "True") {
            $winHTTPSetE = Get-ItemProperty -path "HKCU:\\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
            If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                Write-Host "WinHTTP Key for 64-Bit is present.  Value is not.  Not enforced."
                Add-Content .\result.txt -value "WinHTTP Key for 64-Bit is present.  Value is not.  Not enforced."
            }
            Else{
                $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                Write-Host "WinHTTP 64-Bit Key: $winHTTPSetEFHex`r"
                Add-Content .\result.txt -value "WinHTTP 64-Bit Key: $winHTTPSetEFHex`r"
            }
        }
        Else {
            Write-Host "WinHTTP 64-bit Key is not present.`r"
            Add-Content .\result.txt -value "WinHTTP 64-bit Key is not present.`r"
        }
        $winHTTPSet = Test-path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
        If($winHTTPSet -eq "True") {
            $winHTTPSetE = Get-ItemProperty -path $X32WinHttpDefaultSecureProtocols
            If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                Write-Host "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
                Add-Content .\result.txt -value "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
            }
            Else{
                $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                Write-Host "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
                Add-Content .\result.txt -value "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
            }
        }
        Else {
            Write-Host "WinHTTP 32-bit Key is not present.`r`n"
            Add-Content .\result.txt -value "WinHTTP 32-bit Key is not present.`r`n"
        }

    }
    Else {
        $winHTTPSet = Test-path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
        If($winHTTPSet -eq "True") {
            $winHTTPSetE = Get-ItemProperty -path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
            If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                Write-Host "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
                Add-Content .\result.txt -value "WinHTTP Key for 32-Bit is present.  Value is not. Not enforced.`r`n"
            }
            Else{
                $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                Write-Host "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
                Add-Content .\result.txt -value "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
            }
        }
        Else {
            Write-Host "WinHTTP 32-bit Key is not present: Not enforced.`r`n"
            Add-Content .\result.txt -value "WinHTTP 32-bit Key is not present: Not enforced.`r`n"
        }
    }
    Write-host "WinHTTP value requires XOR'ing.  XOR values below to allow multiple protocols: Example: 0xa80`r"
    Add-Content .\result.txt -value "WinHTTP value requires XOR'ing.  XOR values below to allow multiple protocols: Example: 0xa80`r"
    Write-host "0x00000008 - Enable SSL 2.0`r"
    Add-Content .\result.txt -value "0x00000008 - Enable SSL 2.0`r"
    Write-host "0x00000020 - Enable SSL 3.0`r"
    Add-Content .\result.txt -value "0x00000020 - Enable SSL 3.0`r"
    Write-host "0x00000080 - Enable TLS 1.0`r"
    Add-Content .\result.txt -value "0x00000080 - Enable TLS 1.0`r"
    Write-host "0x00000200 - Enable TLS 1.1`r"
    Add-Content .\result.txt -value "0x00000200 - Enable TLS 1.1`r"
    Write-host "0x00000800 - Enable TLS 1.2`r`n"
    Add-Content .\result.txt -value "0x00000800 - Enable TLS 1.2`r`n"
}
ElseIf ($osversionMajor -eq 10 -And $osversionMinor -eq 0) {
    Write-host "[Hostname] = $hostname`r"
	Add-Content .\result.txt -value "[Hostname] = $hostname`r"
    Write-host "[Machine Version] = Windows 10 or Server 2016`r"
    Add-Content .\result.txt -value "[Machine Version] = Windows 10 or Server 2016`r"
    if ([System.IntPtr]::Size -eq 4) {
        Write-host "[Architecture] = 32-bit`r`n`n"
        Add-Content .\result.txt -value "[Architecture] = 32-bit`r`n`n" 
    } 
    else {
        Write-host "[Architecture] = 64-bit`r`n`n"
        Add-Content .\result.txt -value "[Architecture] = 64-bit`r`n`n"
    }
    Write-host "[Client Keys]`r`n"
    Add-Content .\result.txt -value "[Client Keys]`r`n"
    $ssl20CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
    If ($ssl20CTest -eq "True") {
        $ssl20C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client"
        If($ssl20C.DisabledByDefault -eq $null) {
            Write-host "SSL 2.0: DisabledByDefault: 1, SSL 2.0 is not supported on Windows 10/Server 2016.`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1, SSL 2.0 is not supported on Windows 10/Server 2016.`r"
        }
        Else {
            $ssl20CH = $ssl20C.DisabledByDefault
            Write-host "SSL 2.0: DisabledByDefault: $ssl20CH, SSL 2.0 is not supported on Windows 10/Server 2016. `r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: $ssl20CH, SSL 2.0 is not supported on Windows 10/Server 2016. `r"
        }
        If($ssl20C.Enabled -eq $null) {
            Write-host "SSL 2.0: Enabled: 0, SSL 2.0 is not supported on Windows 10/Server 2016.`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, SSL 2.0 is not supported on Windows 10/Server 2016.`r`n"
        }
        Else {
            $ssl20CH = $ssl20C.Enabled
            Write-host "SSL 2.0: Enabled: $ssl20CH, SSL 2.0 is not supported on Windows 10/Server 2016.`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: $ssl20CH, SSL 2.0 is not supported on Windows 10/Server 2016.`r`n"
        }
    }
    Else {
        Write-host "SSL 2.0: Not Supported on Windows 10/Server 2016, Registry is clean.`r`n"
		Add-Content .\result.txt -value "SSL 2.0: Not Supported on Windows 10/Server 2016, Registry is clean.`r`n"
    }   
    $ssl30CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
    If ($ssl30CTest -eq "True") {
        $ssl30C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
        If($ssl30C.DisabledByDefault -eq $null) {
            Write-host "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl30CH = $ssl30C.DisabledByDefault
            Write-host "SSL 3.0: DisabledByDefault: $ssl20CH`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: $ssl20CH`r"
        }
        If($ssl30C.Enabled -eq $null) {
            Write-host "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl30CH = $ssl30C.Enabled
            Write-host "SSL 3.0: Enabled: $ssl30CH`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: $ssl30CH`r`n"
        }
    }
    Else {
        Write-host "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $tls10CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
    If ($tls10CTest -eq "True") {
        $tls10C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
        If($tls10C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls10CH = $tls10C.DisabledByDefault
            Write-host "TLS 1.0: DisabledByDefault: $tls10CH`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: $tls10CH`r"
        }
        If($tls10C.Enabled -eq $null) {
            Write-host "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls10CH = $tls10C.Enabled
            Write-host "TLS 1.0: Enabled: $tls10CH`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: $tls10CH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls11CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
    If ($tls11CTest -eq "True") {
        $tls11C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client"
        If($tls11C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls11CH = $tls11C.DisabledByDefault
            Write-host "TLS 1.1: DisabledByDefault: $tls11CH`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: $tls11CH`r"
        }
        If($tls11C.Enabled -eq $null) {
            Write-host "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls11CH = $tls11C.Enabled
            Write-host "TLS 1.1: Enabled: $tls11CH`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: $tls11CH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls12CTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
    If ($tls12CTest -eq "True") {
        $tls12C = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"
        If($tls12C.DisabledByDefault -eq $null) {
            Write-host "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls12CH = $tls12C.DisabledByDefault
            Write-host "TLS 1.2: DisabledByDefault: $tls12CH`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: $tls12CH`r"
        }
        If($tls12C.Enabled -eq $null) {
            Write-host "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
        }
        Else {
            $tls12CH = $tls12C.Enabled
            Write-host "TLS 1.2: Enabled: $tls12CH`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: $tls12CH`r`n`n"
        }
    }
    Else {
        Write-host "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
        Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
    }

    Write-host "[Server Keys]`r`n"
    Add-Content .\result.txt -value "[Server Keys]`r`n"
    $ssl20STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
    If ($ssl20STest -eq "True") {
        $ssl20S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server"
        If($ssl20S.DisabledByDefault -eq $null) {
            Write-host "SSL 2.0: DisabledByDefault: 1, SSL 2.0 is not supported on Windows 10/Server 2016.`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: 1 SSL 2.0 is not supported on Windows 10/Server 2016.`r"
        }
        Else {
            $ssl20SH = $ssl20S.DisabledByDefault
            Write-host "SSL 2.0: DisabledByDefault: $ssl20SH, SSL 2.0 is not supported on Windows 10/Server 2016.`r"
			Add-Content .\result.txt -value "SSL 2.0: DisabledByDefault: $ssl20SH, SSL 2.0 is not supported on Windows 10/Server 2016.`r"
        }
        If($ssl20S.Enabled -eq $null) {
            Write-host "SSL 2.0: Enabled: 0, SSL 2.0 is not supported on Windows 10/Server 2016.`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: 0, SSL 2.0 is not supported on Windows 10/Server 2016.`r`n"
        }
        Else {
            $ssl20SH = $ssl20S.Enabled
            Write-host "SSL 2.0: Enabled: $ssl20SH, SSL 2.0 is not supported on Windows 10/Server 2016.`r`n"
            Add-Content .\result.txt -value "SSL 2.0: Enabled: $ssl20SH, SSL 2.0 is not supported on Windows 10/Server 2016.`r`n"
        }
    }
    Else {
        Write-host "SSL 2.0: Not Supported on Windows 10/Server 2016, Registry is clean.`r`n"
		Add-Content .\result.txt -value "SSL 2.0: Not Supported on Windows 10/Server 2016, Registry is clean.`r`n"
    }   
    $ssl30STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
    If ($ssl30STest -eq "True") {
        $ssl30S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
        If($ssl30S.DisabledByDefault -eq $null) {
            Write-host "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $ssl30SH = $ssl30S.DisabledByDefault
            Write-host "SSL 3.0: DisabledByDefault: $ssl30SH`r"
			Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: $ssl30SH`r"
        }
        If($ssl30S.Enabled -eq $null) {
            Write-host "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $ssl30SH = $ssl30S.Enabled
            Write-host "SSL 3.0: Enabled: $ssl30SH`r`n"
            Add-Content .\result.txt -value "SSL 3.0: Enabled: $ssl30SH`r`n"
        }
    }
    Else {
        Write-host "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "SSL 3.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "SSL 3.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }   
    $tls10STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
    If ($tls10STest -eq "True") {
        $tls10S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
        If($tls10S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls10SH = $tls10S.DisabledByDefault
            Write-host "TLS 1.0: DisabledByDefault: $tls10SH`r"
			Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: $tls10SH`r"
        }
        If($tls10S.Enabled -eq $null) {
            Write-host "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls10SH = $tls10S.Enabled
            Write-host "TLS 1.0: Enabled: $tls10SH`r`n"
            Add-Content .\result.txt -value "TLS 1.0: Enabled: $tls10SH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.0: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.0: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls11STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
    If ($tls11STest -eq "True") {
        $tls11S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server"
        If($tls11S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls11SH = $tls11S.DisabledByDefault
            Write-host "TLS 1.1: DisabledByDefault: $tls11SH`r"
			Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: $tls11SH`r"
        }
        If($tls11S.Enabled -eq $null) {
            Write-host "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n"
        }
        Else {
            $tls11SH = $tls11S.Enabled
            Write-host "TLS 1.1: Enabled: $tls11SH`r`n"
            Add-Content .\result.txt -value "TLS 1.1: Enabled: $tls11SH`r`n"
        }
    }
    Else {
        Write-host "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.1: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
        Add-Content .\result.txt -value "TLS 1.1: Enabled: 1, Registry folder key not present. Using OS Default.`r`n"
    }
    $tls12STest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
    If ($tls12STest -eq "True") {
        $tls12S = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
        If($tls12S.DisabledByDefault -eq $null) {
            Write-host "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry key folder present, value is missing.  Using OS default.`r"
        }
        Else {
            $tls12SH = $tls12S.DisabledByDefault
            Write-host "TLS 1.2: DisabledByDefault: $tls12SH`r"
            Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: $tls12SH`r"
        }
        If($tls12S.Enabled -eq $null) {
            Write-host "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry key folder present, value is missing.  Using OS default.`r`n`n"
        }
        Else {
            $tls12SH = $tls12S.Enabled
            Write-host "TLS 1.2: Enabled: $tls12SH`r`n`n"
            Add-Content .\result.txt -value "TLS 1.2: Enabled: $tls12SH`r`n`n"
        }
    }
    Else {
        Write-host "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
		Add-Content .\result.txt -value "TLS 1.2: DisabledByDefault: 0, Registry folder key not present. Using OS Default.`r"
        Write-host "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
        Add-Content .\result.txt -value "TLS 1.2: Enabled: 1, Registry folder key not present. Using OS Default.`r`n`n"
    }
    Write-Host "[KeyExchangeAlgorithms]`r`n"
    Add-Content .\result.txt -value "[KeyExchangeAlgorithms]`r`n"
    $keyExchangeAlgo = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms"
    If( $keyExchangeAlgo -eq "True" ) {
        $PKCS = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\PKCS"
        If( $PKCS -eq "True" ) {
            $PKCSE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\PKCS"
        
            If ( $PKCSE.Enabled -eq $null ) {
                Write-Host "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed.  Value not set.`r`n`n"
                Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed.  Value not set.`r`n`n"
            }
            ElseIf( $PKCSE.Enabled -eq 0 ) {
                Write-Host "WARNING!!! PKCS is disabled.  No RSA-based SSL and TLS cipher suites will be allowed!`r`n`n"
                Add-Content .\result.txt -value "WARNING!!! PKCS is disabled.  No RSA-based SSL and TLS cipher suites will be allowed!`r`n`n"
            }
            Else {
                $PKCSEH = $PKCSE.Enabled
                $PKCSEHex = "{0:x8}" -f $PKCSEH
                Write-Host "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed. Value set to: 0x$PKCSEHex`r`n`n"
                Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS cipher suites will be allowed. Value set to: 0x$PKCSEHex`r`n`n"
            }
        }
        Else {
            Write-host "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
            Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
        }
    }
    Else {
       Write-host "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
       Add-Content .\result.txt -value "PKCS is enabled. RSA-based SSL and TLS ciper suites will be allowed. Reg Key not present.`r`n`n"
    }
    Write-Host "[Hashes]`r`n"
    Add-Content .\result.txt -value "[Hashes]`r`n"
    $md5 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5"
    If( $md5 -eq "True" ) {
        $md5E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\MD5\"
        If ( $md5E.Enabled -eq $null ) {
            Write-Host "MD5 Cipher Hashes are enabled. Value not set.`r"
            Add-Content .\result.txt -value "MD5 Cipher Hashes are enabled. Value not set.`r"
        }
        ElseIf( $md5E.Enabled -eq 0 ) {
            Write-Host "WARNING!!! MD5 based Cipher Suites have been disabled!`r"
            Add-Content .\result.txt -value "WARNING!!! MD5 based Cipher Suites have been disabled!`r"
        }
        Else {
            $md5EH = $md5E.Enabled
            $md5EHex = "{0:x8}" -f $md5EH
            Write-Host "Md5 Cipher Hashes are enabled.  Value set to: 0x$md5EHex`r"
			Add-Content .\result.txt -value "Md5 Cipher Hashes are enabled.  Value set to: 0x$md5EHex`r"
        }
    }
    Else {
       Write-host "MD5 Cipher Hashes are enabled.  Reg Key not present.`r"
       Add-Content .\result.txt -value "MD5 Cipher Hashes are enabled.  Reg Key not present.`r"
    }
    $SHA = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA"
    If( $SHA -eq "True" ) {
        $SHAE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\SHA"
        If ( $SHAE.Enabled -eq $null ) {
            Write-Host "SHA-1 Cipher Hashes are enabled. Value not set.`r`n`n"
            Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled. Value not set.`r`n`n"
        }
        ElseIf( $SHAE.Enabled -eq 0 ) {
            Write-Host "WARNING!!! SHA-1 based Cipher Suites have been disabled!`r`n`n"
            Add-Content .\result.txt -value "WARNING!!! SHA-1 based Cipher Suites have been disabled!`r`n`n"
        }
        Else {
            $SHAEH = $SHAE.Enabled
            $SHAEHex = "{0:x8}" -f $SHAEH
            Write-Host "SHA-1 Cipher Hashes are enabled.  Value set to: 0x$SHAEHex`r`n`n"
            Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled.  Value set to: 0x$SHAEHex`r`n`n"
        }
    }
    Else {
       Write-host "SHA-1 Cipher Hashes are enabled.  Reg Key not present.`r`n`n"
       Add-Content .\result.txt -value "SHA-1 Cipher Hashes are enabled.  Reg Key not present.`r`n`n"
    }
    Write-Host "[Cipher Suites]`r`n"
    Add-Content .\result.txt -value "[Cipher Suites]`r`n"
    $nullValue = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL"
    if ($nullValue -eq "True") {
        $nullValueE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL"
        If($nullValueE.Enabled -eq $null -Or $nullValueE.Enabled -eq 0) {
            Write-host "Null is not set. Cipher Suites can be used.`r`n"
            Add-Content .\result.txt -value "Null is not set. Cipher Suites can be used.`r`n"
            $cipherAES256 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
            If ($cipherAES256 -eq "True") {
                $cipherAES256E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
                If($cipherAES256E.Enabled -eq $null) {
                    Write-host "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherAES256EH = $cipherAES256E.Enabled
                    Write-host "AES 256: Enabled: $ciperAES256EH`r"
					Add-Content .\result.txt -value "AES 256: Enabled: $ciperAES256EH`r"
                }
            }
            Else {
                Write-host "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherAES128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
            If ($cipherAES128 -eq "True") {
                $cipherAES128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
                If($cipherAES128E.Enabled -eq $null) {
                    Write-host "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherAES128EH = $cipherAES128E.Enabled
                    Write-host "AES 128: Enabled: $ciperAES128EH`r"
					Add-Content .\result.txt -value "AES 128: Enabled: $ciperAES128EH`r"
                }
            }
            Else {
                Write-host "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherDES56 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
            If ($cipherDES56 -eq "True") {
                $cipherDES56E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
                If($cipherDES56E.Enabled -eq $null) {
                    Write-host "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherDES56EH = $cipherDES56E.Enabled
                    Write-host "DES 56: Enabled: $ciperDES56EH`r"
					Add-Content .\result.txt -value "DES 56: Enabled: $ciperDES56EH`r"
                }
            }
            Else {
                Write-host "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC4128128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
            If ($cipherRC4128128 -eq "True") {
                $cipherRC4128128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
                If($cipherRC4128128E.Enabled -eq $null) {
                    Write-host "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC4128128EH = $cipherRC4128128E.Enabled
                    Write-host "RC4 128/128: Enabled: $ciperRC4128128EH`r"
					Add-Content .\result.txt -value "RC4 128/128: Enabled: $ciperRC4128128EH`r"
                }
            }
            Else {
                Write-host "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC464 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
            If ($cipherRC464 -eq "True") {
                $cipherRC464E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
                If($cipherRC464E.Enabled -eq $null) {
                    Write-host "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC464EH = $cipherRC464E.Enabled
                    Write-host "RC4 64/128: Enabled: $ciperRC464EH`r"
					Add-Content .\result.txt -value "RC4 64/128: Enabled: $ciperRC464EH`r"
                }
            }
            Else {
                Write-host "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC456 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
            If ($cipherRC456 -eq "True") {
                $cipherRC456E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
                If($cipherRC456E.Enabled -eq $null) {
                    Write-host "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC456EH = $cipherRC456E.Enabled
                    Write-host "RC4 56/128: Enabled: $ciperRC456EH`r"
					Add-Content .\result.txt -value "RC4 56/128: Enabled: $ciperRC456EH`r"
                }
            }
            Else {
                Write-host "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC440 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
            If ($cipherRC440 -eq "True") {
                $cipherRC440E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
                If($cipherRC440E.Enabled -eq $null) {
                    Write-host "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC440EH = $cipherRC440E.Enabled
                    Write-host "RC4 40/128: Enabled: $ciperRC440EH`r"
					Add-Content .\result.txt -value "RC4 40/128: Enabled: $ciperRC440EH`r"
                }
            }
            Else {
                Write-host "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipher3DES168 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
            If ($cipher3DES168 -eq "True") {
                $cipher3DES168E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
                If($cipher3DES168E.Enabled -eq $null) {
                    Write-host "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipher3DES168EH = $cipher3DES168E.Enabled
                    Write-host "Triple DES 168: Enabled: $ciper3DES168EH`r"
					Add-Content .\result.txt -value "Triple DES 168: Enabled: $ciper3DES168EH`r"
                }
            }
            Else {
                Write-host "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC2128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
            If ($cipherRC2128 -eq "True") {
                $cipherRC2128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
                If($cipherRC2128E.Enabled -eq $null) {
                    Write-host "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC2128EH = $cipherRC2128E.Enabled
                    Write-host "RC2 128/128: Enabled: $ciperRC2128EH`r"
					Add-Content .\result.txt -value "RC2 128/128: Enabled: $ciperRC2128EH`r"
                }
            }
            Else {
                Write-host "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC256128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
            If ($cipherRC256128 -eq "True") {
                $cipherRC256128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
                If($cipherRC256128E.Enabled -eq $null) {
                    Write-host "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC256128EH = $cipherRC256128E.Enabled
                    Write-host "RC2 56/128: Enabled: $ciperRC256128EH`r"
					Add-Content .\result.txt -value "RC2 56/128: Enabled: $ciperRC256128EH`r"
                }
            }
            Else {
                Write-host "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC240128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
            If ($cipherRC240128 -eq "True") {
                $cipherRC240128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
                If($cipherRC240128E.Enabled -eq $null) {
                    Write-host "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
					Add-Content .\result.txt -value "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
                }
                Else {
                    $cipherRC240128EH = $cipherRC240128E.Enabled
                    Write-host "RC2 40/128: Enabled: $ciperRC240128EH`r"
					Add-Content .\result.txt -value "RC2 40/128: Enabled: $ciperRC240128EH`r"
                }
            }
            Else {
                Write-host "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
                Add-Content .\result.txt -value "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            }
            $cipherRC25656 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
            If ($cipherRC25656 -eq "True") {
                $cipherRC25656E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
                If($cipherRC25656E.Enabled -eq $null) {
                    Write-host "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
					Add-Content .\result.txt -value "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
                }
                Else {
                    $cipherRC25656EH = $cipherRC25656E.Enabled
                    Write-host "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
					Add-Content .\result.txt -value "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
                }
            }
            Else {
                Write-host "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
                Add-Content .\result.txt -value "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
            }
			Write-host "[00010002 Group Policy Cipher Reg Key Values]`r`n"
			Add-Content .\result.txt -value "[00010002 Group Policy Cipher Reg Key Values]`r`n"
			$cryptSSLGTest = Test-path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
			If ($cryptSSLGTest -eq "True") {
				If ($cryptSSLGTest.EccCurves -eq $null -And $cryptSSLG.Functions -eq $null){
					Write-Host "Group Policy is not set.  Local values will be used listed below.`r`n`n"
					Add-Content .\result.txt -value "Group Policy is not set.  Local values will be used listed below.`r`n`n"
					Write-host "[00010002 Local Cipher Reg Key Values]`r`n"
					Add-Content .\result.txt -value "[00010002 Local Cipher Reg Key Values]`r`n"
					$cryptSSLTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
					If ($cryptSSLTest -eq "True") {
						$cryptSSL = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
						If($cryptSSL.EccCurves -eq $null) {
							Write-host "EccCurves: Value is NULL!`r`n"
							Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
						}
						Else {
							$cryptSSLH = $cryptSSL.EccCurves
							Write-host "EccCurves: $cryptSSLH`r`n"
							Add-Content .\result.txt -value "EccCurves: $cryptSSLH`r`n"
						}
						If($cryptSSL.Functions -eq $null) {
							Write-host "Functions: Value is NULL!`r`n`n"
							Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
						}
						Else {
							$cryptSSLF = $cryptSSL.Functions
							Write-host "Functions: $cryptSSLF`r`n`n"
							Add-Content .\result.txt -value "Functions: $cryptSSLF`r`n`n"
						}
					}
					Else {
						Write-host "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
						Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
					}
				}
				Else {
					$cryptSSLG = Get-ItemProperty -path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
					If($cryptSSLG.EccCurves -eq $null) {
						Write-host "EccCurves: Value is NULL!`r`n"
						Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
					}
					Else {
						$cryptSSLGH = $cryptSSL.EccCurves
						Write-host "EccCurves: $cryptSSLGH`r`n"
						Add-Content .\result.txt -value "EccCurves: $cryptSSLGH`r`n"
					}
					If($cryptSSLG.Functions -eq $null) {
						Write-host "Functions: Value is NULL!`r`n`n"
						Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
					}
					Else {
						$cryptSSLGF = $cryptSSL.Functions
						Write-host "Functions: $cryptSSLGF`r`n`n"
						Add-Content .\result.txt -value "Functions: $cryptSSLGF`r`n`n"
					}
				}
			}
			Else {
				Write-host "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
				Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
			}
        }
        Else {
            $nullValueEH = $nullValueE.Enabled
            Write-Host "WARNING!!!  NULL is enabled!  No Cipher Suites are enabled regardless of Reg Key Set or Not!`r`n`n"
			Add-Content .\result.txt -value "WARNING!!!  NULL is enabled!  No Cipher Suites are enabled regardless of Reg Key Set or Not!`r`n`n"
        }
    }
    Else {
        Write-host "Null Reg Key not present.  Cipher Suites can be used.`r`n"
        Add-Content .\result.txt -value "Null Reg Key not present.  Cipher Suites can be used.`r`n"
        $cipherAES256 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
        If ($cipherAES256 -eq "True") {
            $cipherAES256E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 256"
            If($cipherAES256E.Enabled -eq $null) {
                Write-host "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "AES 256: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherAES256EH = $cipherAES256E.Enabled
                Write-host "AES 256: Enabled: $ciperAES256EH`r"
				Add-Content .\result.txt -value "AES 256: Enabled: $ciperAES256EH`r"
            }
        }
        Else {
            Write-host "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "AES 256 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherAES128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
        If ($cipherAES128 -eq "True") {
            $cipherAES128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AES 128"
            If($cipherAES128E.Enabled -eq $null) {
                Write-host "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "AES 128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherAES128EH = $cipherAES128E.Enabled
                Write-host "AES 128: Enabled: $ciperAES128EH`r"
				Add-Content .\result.txt -value "AES 128: Enabled: $ciperAES128EH`r"
            }
        }
        Else {
            Write-host "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "AES 128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherDES56 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
        If ($cipherDES56 -eq "True") {
            $cipherDES56E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56"
            If($cipherDES56E.Enabled -eq $null) {
                Write-host "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "DES 56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherDES56EH = $cipherDES56E.Enabled
                Write-host "DES 56: Enabled: $ciperDES56EH`r"
				Add-Content .\result.txt -value "DES 56: Enabled: $ciperDES56EH`r"
            }
        }
        Else {
            Write-host "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "DES 56 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC4128128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
        If ($cipherRC4128128 -eq "True") {
            $cipherRC4128128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128"
            If($cipherRC4128128E.Enabled -eq $null) {
                Write-host "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC4128128EH = $cipherRC4128128E.Enabled
                Write-host "RC4 128/128: Enabled: $ciperRC4128128EH`r"
				Add-Content .\result.txt -value "RC4 128/128: Enabled: $ciperRC4128128EH`r"
            }
        }
        Else {
            Write-host "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC464 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
        If ($cipherRC464 -eq "True") {
            $cipherRC464E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128"
            If($cipherRC464E.Enabled -eq $null) {
                Write-host "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 64/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC464EH = $cipherRC464E.Enabled
                Write-host "RC4 64/128: Enabled: $ciperRC464EH`r"
				Add-Content .\result.txt -value "RC4 64/128: Enabled: $ciperRC464EH`r"
            }
        }
        Else {
            Write-host "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 64/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC456 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
        If ($cipherRC456 -eq "True") {
            $cipherRC456E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128"
            If($cipherRC456E.Enabled -eq $null) {
                Write-host "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC456EH = $cipherRC456E.Enabled
                Write-host "RC4 56/128: Enabled: $ciperRC456EH`r"
				Add-Content .\result.txt -value "RC4 56/128: Enabled: $ciperRC456EH`r"
            }
        }
        Else {
            Write-host "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC440 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
        If ($cipherRC440 -eq "True") {
            $cipherRC440E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128"
            If($cipherRC440E.Enabled -eq $null) {
                Write-host "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC4 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC440EH = $cipherRC440E.Enabled
                Write-host "RC4 40/128: Enabled: $ciperRC440EH`r"
				Add-Content .\result.txt -value "RC4 40/128: Enabled: $ciperRC440EH`r"
            }
        }
        Else {
            Write-host "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC4 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipher3DES168 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
        If ($cipher3DES168 -eq "True") {
            $cipher3DES168E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168"
            If($cipher3DES168E.Enabled -eq $null) {
                Write-host "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "Triple DES 168: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipher3DES168EH = $cipher3DES168E.Enabled
                Write-host "Triple DES 168: Enabled: $ciper3DES168EH`r"
				Add-Content .\result.txt -value "Triple DES 168: Enabled: $ciper3DES168EH`r"
            }
        }
        Else {
            Write-host "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "Triple DES 168 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC2128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
        If ($cipherRC2128 -eq "True") {
            $cipherRC2128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 128/128"
            If($cipherRC2128E.Enabled -eq $null) {
                Write-host "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 128/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC2128EH = $cipherRC2128E.Enabled
                Write-host "RC2 128/128: Enabled: $ciperRC2128EH`r"
				Add-Content .\result.txt -value "RC2 128/128: Enabled: $ciperRC2128EH`r"
            }
        }
        Else {
            Write-host "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 128/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC256128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
        If ($cipherRC256128 -eq "True") {
            $cipherRC256128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/128"
            If($cipherRC256128E.Enabled -eq $null) {
                Write-host "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 56/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC256128EH = $cipherRC256128E.Enabled
                Write-host "RC2 56/128: Enabled: $ciperRC256128EH`r"
				Add-Content .\result.txt -value "RC2 56/128: Enabled: $ciperRC256128EH`r"
            }
        }
        Else {
            Write-host "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 56/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC240128 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
        If ($cipherRC240128 -eq "True") {
            $cipherRC240128E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128"
            If($cipherRC240128E.Enabled -eq $null) {
                Write-host "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
				Add-Content .\result.txt -value "RC2 40/128: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r"
            }
            Else {
                $cipherRC240128EH = $cipherRC240128E.Enabled
                Write-host "RC2 40/128: Enabled: $ciperRC240128EH`r"
				Add-Content .\result.txt -value "RC2 40/128: Enabled: $ciperRC240128EH`r"
            }
        }
        Else {
            Write-host "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
            Add-Content .\result.txt -value "RC2 40/128 Cipher Suites are enabled.  Reg Key not present.`r"
        }
        $cipherRC25656 = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
        If ($cipherRC25656 -eq "True") {
            $cipherRC25656E = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 56/56"
            If($cipherRC25656E.Enabled -eq $null) {
                Write-host "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
				Add-Content .\result.txt -value "RC2 56/56: Enabled: Yes, Registry key folder present, value is missing.  Using OS default.`r`n`n"
            }
            Else {
                $cipherRC25656EH = $cipherRC25656E.Enabled
                Write-host "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
				Add-Content .\result.txt -value "RC2 56/56: Enabled: $ciperRC25656EH`r`n`n"
            }
        }
        Else {
            Write-host "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
            Add-Content .\result.txt -value "RC2 56/56 Cipher Suites are enabled.  Reg Key not present.`r`n`n"
        }
		Write-host "[00010002 Group Policy Cipher Reg Key Values]`r`n"
		Add-Content .\result.txt -value "[00010002 Group Policy Cipher Reg Key Values]`r`n"
		$cryptSSLGTest = Test-path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
		If ($cryptSSLGTest -eq "True") {
			If ($cryptSSLGTest.EccCurves -eq $null -And $cryptSSLG.Functions -eq $null){
				Write-Host "Group Policy is not set.  Local values will be used listed below.`r`n`n"
				Add-Content .\result.txt -value "Group Policy is not set.  Local values will be used listed below.`r`n`n"
				Write-host "[00010002 Local Cipher Reg Key Values]`r`n"
				Add-Content .\result.txt -value "[00010002 Local Cipher Reg Key Values]`r`n"
				$cryptSSLTest = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
				If ($cryptSSLTest -eq "True") {
					$cryptSSL = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
					If($cryptSSL.EccCurves -eq $null) {
						Write-host "EccCurves: Value is NULL!`r`n"
						Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
					}
					Else {
						$cryptSSLH = $cryptSSL.EccCurves
						Write-host "EccCurves: $cryptSSLH`r`n"
						Add-Content .\result.txt -value "EccCurves: $cryptSSLH`r`n"
					}
					If($cryptSSL.Functions -eq $null) {
						Write-host "Functions: Value is NULL!`r`n`n"
						Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
					}
					Else {
						$cryptSSLF = $cryptSSL.Functions
						Write-host "Functions: $cryptSSLF`r`n`n"
						Add-Content .\result.txt -value "Functions: $cryptSSLF`r`n`n"
					}
				}
				Else {
					Write-host "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
					Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! This is most likely the problem.  Please fill in the 'EccCurves' and 'Functions' Values.`r`n`n"
				}
			}
			Else {
				$cryptSSLG = Get-ItemProperty -path "HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
				If($cryptSSLG.EccCurves -eq $null) {
					Write-host "EccCurves: Value is NULL!`r`n"
					Add-Content .\result.txt -value "EccCurves: Value is NULL!`r`n"
				}
				Else {
					$cryptSSLGH = $cryptSSL.EccCurves
					Write-host "EccCurves: $cryptSSLGH`r`n"
					Add-Content .\result.txt -value "EccCurves: $cryptSSLGH`r`n"
				}
				If($cryptSSLG.Functions -eq $null) {
					Write-host "Functions: Value is NULL!`r`n`n"
					Add-Content .\result.txt -value "Functions: Value is NULL!`r`n`n"
				}
				Else {
					$cryptSSLGF = $cryptSSL.Functions
					Write-host "Functions: $cryptSSLGF`r`n`n"
					Add-Content .\result.txt -value "Functions: $cryptSSLGF`r`n`n"
				}
			}
		}
		Else {
			Write-host "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
			Add-Content .\result.txt -value "WARNING! REGISTRY KEY NOT PRESENT! Someone deleted something they shouldn't have.  Recreate the registry key HKLM:\\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002`r`n`n"
		}
    }
	Write-Host "[Fips Algorithm]`r`n"
	Add-Content .\result.txt -value "[Fips Algorithm]`r`n"
	$fipsAlgo = Test-path "HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
    If ($fipsAlgo -eq "True") {
        $fipsAlgoE = Get-ItemProperty -path "HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
        If($fipsAlgoE.Enabled -eq $null -And $fipsAlgoE.MDMEnabled -eq $null) {
            Write-Host "Disabled! Someone deleted values manually.  Please add REG_DWORD Values: Enabled: 0, MDMEnabled: 0 to correct."
			Add-Content .\result.txt -value "Disabled! Someone deleted values manually.  Please add REG_DWORD Values: Enabled: 0, MDMEnabled: 0 to correct."
        }
        ElseIf ($fipsAlgoE.Enabled -eq 0 -And $fipsAlgoE.MDMEnabled -eq 0){
            $fipsAlgoEH = $fipsAlgoE.Enabled
            Write-Host "Fips and MDM are both Disabled."
			Add-Content .\result.txt -value "Fips and MDM are both Disabled."
        }
		Else {
            If($fipsAlgoE.Enabled -eq $null){
                Write-Host "Fips value set to Null.  Not enabled.`r"
                Add-Content .\result.txt -value "Fips value set to Null. Not enabled.`r"
            }
            Else {
                $fipsAlgoEF = $fipsAlgoE.Enabled
                $fipsAlgoEHex = "{0:x8}" -f $fipsAlgoEF
                Write-Host "Fips Value set to Enabled: 0x$fipsAlgoEHex`r"
			    Add-Content .\result.txt -value "Fips Value set to Enabled: 0x$fipsAlgoEHex`r"
            }

            If($fipsAlgoE.MDMEnabled -eq $null){
                Write-Host "MDMEnabled value is set to Null. Not enabled.`r`n`n"
                Add-Content .\result.txt -value "MDMEnabled value is set to Null.  Not enabled.`r`n`n"
            }
            Else {
			    $fipsAlgoEC = $fipsAlgoE.MDMEnabled
			    $fipsAlgoECHex = "{0:x8}" -f $fipsAlgoEC
			    Write-Host "MDMEnabled Value set to Enabled: 0x$fipsAlgoECHex`r`n`n"
			    Add-Content .\result.txt -value "MDMEnabled Value set to Enabled: 0x$fipsAlgoECHex`r`n`n"
            }
		}
    }
    Else {
        Write-host "FipsAlgorithmPolicy Reg Key has been removed manually!  Please re-add the Reg Key! HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy]`r`n`n"
        Add-Content .\result.txt -value "FipsAlgorithmPolicy Reg Key has been removed manually!  Please re-add the Reg Key! HKLM:\\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy]`r`n`n"
    }
    Write-Host "[WinHTTP Settings]`r`n"
    Add-Content .\result.txt -value "[WinHTTP Settings]`r`n"
    If([System.IntPtr]::Size -eq 8) {
        $winHTTPSet = Test-path "HKCU:\\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
        If($winHTTPSet -eq "True") {
            $winHTTPSetE = Get-ItemProperty -path "HKCU:\\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
            If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                Write-Host "WinHTTP Key for 64-Bit is present.  Value is not.  Not enforced."
                Add-Content .\result.txt -value "WinHTTP Key for 64-Bit is present.  Value is not.  Not enforced."
            }
            Else{
                $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                Write-Host "WinHTTP 64-Bit Key: $winHTTPSetEFHex`r"
                Add-Content .\result.txt -value "WinHTTP 64-Bit Key: $winHTTPSetEFHex`r"
            }
        }
        Else {
            Write-Host "WinHTTP 64-bit Key is not present.`r"
            Add-Content .\result.txt -value "WinHTTP 64-bit Key is not present.`r"
        }
        $winHTTPSet = Test-path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
        If($winHTTPSet -eq "True") {
            $winHTTPSetE = Get-ItemProperty -path $X32WinHttpDefaultSecureProtocols
            If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                Write-Host "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
                Add-Content .\result.txt -value "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
            }
            Else{
                $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                Write-Host "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
                Add-Content .\result.txt -value "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
            }
        }
        Else {
            Write-Host "WinHTTP 32-bit Key is not present.`r`n"
            Add-Content .\result.txt -value "WinHTTP 32-bit Key is not present.`r`n"
        }

    }
    Else {
        $winHTTPSet = Test-path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
        If($winHTTPSet -eq "True") {
            $winHTTPSetE = Get-ItemProperty -path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"
            If($WinHTTPSetE.DefaultSecureProtocols -eq $null){
                Write-Host "WinHTTP Key for 32-Bit is present.  Value is not.  Not enforced.`r`n"
                Add-Content .\result.txt -value "WinHTTP Key for 32-Bit is present.  Value is not. Not enforced.`r`n"
            }
            Else{
                $winHTTPSetEF = $winHTTPSetE.DefaultSecureProtocols
                $winHTTPSetEFHex = "0x{0:x8}" -f $winHTTPSetEF
                Write-Host "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
                Add-Content .\result.txt -value "WinHTTP 32-Bit Key: $winHTTPSetEFHex`r`n"
            }
        }
        Else {
            Write-Host "WinHTTP 32-bit Key is not present: Not enforced.`r`n"
            Add-Content .\result.txt -value "WinHTTP 32-bit Key is not present: Not enforced.`r`n"
        }
    }
    Write-host "WinHTTP value requires XOR'ing.  XOR values below to allow multiple protocols: Example: 0xa80`r"
    Add-Content .\result.txt -value "WinHTTP value requires XOR'ing.  XOR values below to allow multiple protocols: Example: 0xa80`r"
    Write-host "0x00000008 - Enable SSL 2.0`r"
    Add-Content .\result.txt -value "0x00000008 - Enable SSL 2.0`r"
    Write-host "0x00000020 - Enable SSL 3.0`r"
    Add-Content .\result.txt -value "0x00000020 - Enable SSL 3.0`r"
    Write-host "0x00000080 - Enable TLS 1.0`r"
    Add-Content .\result.txt -value "0x00000080 - Enable TLS 1.0`r"
    Write-host "0x00000200 - Enable TLS 1.1`r"
    Add-Content .\result.txt -value "0x00000200 - Enable TLS 1.1`r"
    Write-host "0x00000800 - Enable TLS 1.2`r`n"
    Add-Content .\result.txt -value "0x00000800 - Enable TLS 1.2`r`n"
}
Else {
    write-host "This tool is not supported on your current OS."
	Add-Content .\result.txt -value "This tool is not supported on your current OS."
    exit 0
}
}