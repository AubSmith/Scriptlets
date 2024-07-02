$oSSL = "D:\Software\openssl.exe"
$targetHost = "https://www.microsoft.com"
$port = "443"
$status = & $oSSL s_client -connect $targetHost`:$port -ssl3
$status