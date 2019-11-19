<#
=====================================
Script Created by - Binu Balan      
Script Created on - 12/27/2016
Script Updated on - ----------

Version - V 1.0

Requirement *
PowerShell Version = 3.0 or above
	 .__.
     (oo)____
     (__)    )\
        ll--ll '

=====================================
#>
cls
Write-Host "///////////////////////////////////////////////////" -ForegroundColor Red
Write-Host " "
Write-Host "          ##     ####     ####    #   #" -ForegroundColor Green
Write-Host "         #  #    #   #    #   #   #   #" -ForegroundColor Green
Write-Host "        #####    ####     ####    #   #" -ForegroundColor Green
Write-host "       #     #   #        #        ###" -ForegroundColor Green
Write-Host " " 
Write-Host "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\" -ForegroundColor Red
Write-Host " " 
Write-host "	           .__." -ForegroundColor Green
Write-host "                   (oo)____" -ForegroundColor Green
Write-host "                   (__)    )\" -ForegroundColor Green
Write-host "                      ll--ll '" -ForegroundColor Green
Write-Host "               SCRIPT BY BINU BALAN               " -ForegroundColor DarkYellow -BackgroundColor DarkBlue 
Write-Host "///////////////////////////////////////////////////" -ForegroundColor Red
Start-Sleep -Seconds 1
Write-Host " "
Write-Host " " 
Write-Host " ========================= Disclaimer ========================= " -ForegroundColor Yellow
Write-Host " This Script uses Open Source tool Openssl.exe to perform       "
Write-Host " Encryption and Decryption. The Default path for the Openssl.exe"
Write-Host " Should be User Profile folder C:\users\<username>\             "
Write-Host " If Openssl.exe is not available you might have to download and "
Write-Host " store at this location or Script will try to download          "
Write-Host " from the Internet.                                             "
Write-Host " ========================= Disclaimer ========================= " -ForegroundColor Yellow
Start-Sleep -Seconds 1
Write-Host " "
Write-Host " " 
Function Encry {
cls
Write-Host "=======================" -NoNewline -ForegroundColor Yellow
Write-Host " Begining Appu Encryption " -NoNewline -ForegroundColor Red -BackgroundColor Yellow
Write-Host "=======================" -ForegroundColor Yellow
$Input = Read-Host "Enter the Source path [Ex: D:\SecureData] "
$Output = Read-Host "Enter the Destination path [Ex: D:\EncryptedSecdata] "
$PrimaryPwd = Read-host "Enter Primary Password "
$SecondaryPwd = Read-host "Enter Secondary Password "
[string]$PMixpwd = "$PrimaryPwd$SecondaryPwd"
$ShufflePMixPwd = $PMixpwd
$RandomFileN = Get-Random
$KeyFile = "$Env:APPDATA\Microsoft\$RandomFileN.txt"
New-Item -ItemType "file" -Path $KeyFile | Out-Null
$EncryptPMixpwdKey = Echo $ShufflePMixPwd | .\openssl.exe dgst -sha256
$AllFiles = Get-ChildItem -Path $Input -Recurse | ?{$_.Extension -ne $null -and $_.Extension -ne ""}
ForEach ($EachFile in $AllFiles){
$fullPath = $EachFile.FullName
$FileName = $EachFile.Name
$FileEnc = Echo $FileName | .\openssl.exe dgst -sha256
Write-host "Encrypted File :" -ForegroundColor Black -BackgroundColor Green -NoNewline
Write-host " $FileName" -ForegroundColor Green -BackgroundColor Black
Add-Content -Path $KeyFile -Value "$FileEnc,$FileName"
.\openssl.exe enc -aes-256-cbc -salt -in $fullPath -out $Output\$FileEnc -k $EncryptPMixpwdKey
}
.\openssl.exe enc -aes-256-cbc -salt -in $KeyFile -out $Output"\Encryption.key" -k $EncryptPMixpwdKey
Write-Host " "
Write-Host " :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
Write-Host "                        Decryption File and Key                       " -BackgroundColor Green -ForegroundColor Black
Write-Host " "
Write-Host " Decryption key : " -ForegroundColor Yellow -NoNewline
Write-host "$EncryptPMixpwdKey" -ForegroundColor Black -BackgroundColor White
Write-Host " "
Write-Host " Decryption Key File : " -ForegroundColor Yellow -NoNewline
Write-host "$Output\Encryption.key " -ForegroundColor Black -BackgroundColor White
Write-Host " "
Write-Host " :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
Write-Host " "
Remove-Item $KeyFile -Force
}
Function Decry {
cls
Write-Host "=======================" -NoNewline -ForegroundColor Yellow
Write-Host " Begining Appu Decryption " -NoNewline -ForegroundColor Red -BackgroundColor Green
Write-Host "=======================" -ForegroundColor Yellow
$Input = Read-Host "Enter the Source path [Ex: D:\SecureData] "
$Output = Read-Host "Enter the Destination path [Ex: D:\EncryptedSecdata] "
$UniqueKey = Read-host "Enter Decryption Unique Key "
$KeyFile = Read-Host "Enter key file path [Ex: C:\Keyfile.key] "
$RandomkeyFileName = Get-Random
$KeyFileExtractPath = "$Env:APPDATA\Microsoft"
.\openssl.exe enc -aes-256-cbc -salt -d -in $KeyFile -out $KeyFileExtractPath\"$RandomkeyFileName.key" -k $UniqueKey
$ReadKey = Get-Content -Path $KeyFileExtractPath\"$RandomkeyFileName.key"
$AllFiles = Get-ChildItem -Path $Input | ?{$_.Extension -eq $null -or $_.Extension -eq ""}
ForEach ($EachFile in $AllFiles){
$fullPath = $EachFile.FullName
$FileName = $EachFile.Name
# Write-Host "allnames $EachFile"
# $FileDec = Echo $FileName | .\openssl.exe enc -d -aes-256-cbc -a -salt -k $PMixpwd
    ForEach ($FileNameS in $ReadKey){
        $FileH,$FileN = $FileNameS.split(",",2)
       Write-Host "$FileH" -ForegroundColor Yellow
       Write-Host "$FileName" -ForegroundColor Green
            if($FileH -eq $FileName){
                Write-Host "Decrypted File : $FileN" -ForegroundColor Black -BackgroundColor White
                .\openssl.exe enc -aes-256-cbc -salt -d -in $fullPath -out $Output\$FileN -k $UniqueKey
            }
    }
}
Remove-Item $KeyFileExtractPath\"$RandomkeyFileName.key" -Force
}

Function Recover {
$PrimaryPwd = Read-host "Enter Primary Password "
$SecondaryPwd = Read-host "Enter Secondary Password "
[string]$PMixpwd = "$PrimaryPwd$SecondaryPwd"
$EncryptPMixpwdKey = Echo $PMixpwd | .\openssl.exe dgst -sha256

Write-Host " "
Write-Host "========================================================================"
Write-Host "Key : " $EncryptPMixpwdKey
Write-Host "========================================================================"
Write-Host " "

}

cd C:
cd $env:USERPROFILE
Write-Host " "
Write-Host "Validating package               " -NoNewline
$OpenSSLCheck = Test-Path $env:USERPROFILE\Openssl.exe
if($OpenSSLCheck) {
Write-Host "[ SUCCESS ]" -ForegroundColor Green
} Else {
Write-Host "[ FAILED ]" -ForegroundColor Red
Write-Host "Trying to download the package   " -NoNewline
$url = "http://downloads.sourceforge.net/gnuwin32/openssl-0.9.8h-1-bin.zip"
$outputZip = "$env:USERPROFILE\Openssl.zip"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $outputZip)
$RandomFold = Get-Random
$foldPath = "$env:USERPROFILE\$RandomFold"
$outputZip = "$env:USERPROFILE\Openssl.zip"
Add-Type -assembly “system.io.compression.filesystem”
[io.compression.zipfile]::ExtractToDirectory($outputZip, $foldPath)
$OpenSSLPath = "$foldPath\bin\Openssl.exe"
$testdownload = Test-Path $OpenSSLPath
# Write-Host "Testing download and extraction - $OpenSSLPath"
Copy-Item $OpenSSLPath $env:USERPROFILE
Start-Sleep -Seconds 5
$PostDownloadcheck = Test-Path $env:USERPROFILE\Openssl.exe
if ($PostDownloadcheck) {
Write-Host "[ SUCCESS ]" -ForegroundColor Green
} Else {
Write-Host "[ FAILED ]" -ForegroundColor Green
Write-Host " "
Write-Host "Kindly download the file manually from the following link, and extract the openssl.exe in path: $env:USERPROFILE " -ForegroundColor Yellow -BackgroundColor Red
Write-Host "http://downloads.sourceforge.net/gnuwin32/openssl-0.9.8h-1-bin.zip" -ForegroundColor Black -BackgroundColor White
}
}
Write-Host " "
Write-Host " "
Write-Host "1. Encrypt contents of Folder !!" -ForegroundColor White -BackgroundColor Red
Write-Host "2. Decrypt contents of Folder !!" -ForegroundColor Black -BackgroundColor Green
Write-Host "3. Recover Lost Key !!" -ForegroundColor Green -BackgroundColor Black
Write-Host " "
$Opt = Read-Host "Enter Option "
If ($Opt -eq 1) {
Encry
} elseif ($opt -eq 2) {
Decry
} elseif ($opt -eq 3) {
Recover
} Else {
Write-Warning "You have entered invalid option !! Try again..."
}
# SIG # Begin signature block
# MIIJGAYJKoZIhvcNAQcCoIIJCTCCCQUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUpZaNstWSTAjbqJoh+TT/MPxP
# CNigggaBMIIGfTCCBWWgAwIBAgITLwAAAAVRHPs962JO4gAAAAAABTANBgkqhkiG
# 9w0BAQsFADBJMRMwEQYKCZImiZPyLGQBGRYDY29tMRQwEgYKCZImiZPyLGQBGRYE
# YXBwdTEcMBoGA1UEAxMTQXBwdSBEb21haW4gUm9vdCBDQTAeFw0xNjEyMjIxNjUx
# MDVaFw0xODEyMjIxNzAxMDVaMFcxEzARBgoJkiaJk/IsZAEZFgNjb20xFDASBgoJ
# kiaJk/IsZAEZFgRhcHB1MRMwEQYDVQQLEwpQcm9kdWN0aW9uMRUwEwYDVQQDEwxB
# cHB1IFNjcmlwdHMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDDaHsd
# ZANhKks+cKHjcp7Gi4S39eye5LfgO8S5rfojXyBxFfF0kHx+zKckrszS2zutL3gg
# nDSeD4tTWUgnK6qQNRqBfPJHHMC51IaZtdgEcfMXWWnjtf3OzUBhewI5tLqUyEKT
# zQaNrcAhgDphdiG7KA5wtEJVZV6r90ZoM0/8RWM/DB838G24nfhybWGCN0THQf4j
# LZZo2H0L8z3Bx0VPsbpWGMCpzZcsyOHUZYC/eDpCN44XB5eMs2YQrd5jXdLg5yzj
# xYcsdYtxcni1dHC6mB0y3BQ01//5uL/f0X2vLB/Ap12Inq9hvhj7yXgGcZC+lCnW
# MqpdpZpDTJXt9Bd/AgMBAAGjggNOMIIDSjA8BgkrBgEEAYI3FQcELzAtBiUrBgEE
# AYI3FQiH6+UOhvSjVYXZiTaFr+ZggZCrTz+t9AWE84RdAgFmAgEAMBMGA1UdJQQM
# MAoGCCsGAQUFBwMDMA4GA1UdDwEB/wQEAwIHgDAbBgkrBgEEAYI3FQoEDjAMMAoG
# CCsGAQUFBwMDMB0GA1UdDgQWBBTTHs+v/dvVMVqmVlMRhIueMEMcHjAfBgNVHSME
# GDAWgBQsx2obUB7JbC/k9olwnnHpOdjyVDCCASEGA1UdHwSCARgwggEUMIIBEKCC
# AQygggEIhoHAbGRhcDovLy9DTj1BcHB1JTIwRG9tYWluJTIwUm9vdCUyMENBLENO
# PUFQUFVST09UQ0EsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENO
# PVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9YXBwdSxEQz1jb20/Y2VydGlm
# aWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1
# dGlvblBvaW50hkNodHRwOi8vQVBQVVJPT1RDQS5hcHB1LmNvbS9DZXJ0RW5yb2xs
# L0FwcHUlMjBEb21haW4lMjBSb290JTIwQ0EuY3JsMIIBLwYIKwYBBQUHAQEEggEh
# MIIBHTCBtQYIKwYBBQUHMAKGgahsZGFwOi8vL0NOPUFwcHUlMjBEb21haW4lMjBS
# b290JTIwQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNl
# cnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9YXBwdSxEQz1jb20/Y0FDZXJ0aWZp
# Y2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwYwYI
# KwYBBQUHMAKGV2h0dHA6Ly9BUFBVUk9PVENBLmFwcHUuY29tL0NlcnRFbnJvbGwv
# QVBQVVJPT1RDQS5hcHB1LmNvbV9BcHB1JTIwRG9tYWluJTIwUm9vdCUyMENBLmNy
# dDAwBgNVHREEKTAnoCUGCisGAQQBgjcUAgOgFwwVQXBwdS5TY3JpcHRzQGFwcHUu
# Y29tMA0GCSqGSIb3DQEBCwUAA4IBAQBd4CqXoea8hTaKxpiyUCVc7lQPNUZ2eYHQ
# vqJymqZoO7lwNBvS9ZQO4iVKCo8F62fCyEaZoEnatzyE0idC9qNNxQWTeWkcwAgy
# d3TnJfUwqyDzG+UbS9pfz9FOK9U+KzGp5zbFtdPiIsYKYw5RsPdSEZjVwtGyZjOm
# /kw6td/o1nsv0hiergvxjUzt4kQMV4MBdt3m+1dlkXb124agQmk3uA+vdSSxdzzK
# OtLqiH+iH/oVe5ka2g/PYGX0jvo9iTlFRwe95Bfbcv2pnAhJD1ojKZXYVKA9xqK1
# 1Zradp4/lSE1SC5TvnlwqksJiXojOwv9o52JI1gPIrVvuIjItngaMYICATCCAf0C
# AQEwYDBJMRMwEQYKCZImiZPyLGQBGRYDY29tMRQwEgYKCZImiZPyLGQBGRYEYXBw
# dTEcMBoGA1UEAxMTQXBwdSBEb21haW4gUm9vdCBDQQITLwAAAAVRHPs962JO4gAA
# AAAABTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkq
# hkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGC
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUe/IKYX1pXJZD62IrnnMgvVRW/LkwDQYJKoZI
# hvcNAQEBBQAEggEASY2yjZYLMn6jrkKzcj8NP2tljj7WIvNv/WLFaNE7mh9y/PxF
# 5OeY5txcCYASWc+06YpBdTVwG770aurDRsjv0qGeA/xMg2zf3MRxOO0hCglRfGYS
# oBTkzxJ4bQoU5M5QIemMjQegEotWWDyIqtzbI8Tc5Zk5NrA8fy0yqxjIwa8u8fRB
# sW0dWFNhAuDB1X/sZKhZx1l4QTYC8T0dnVhyfMAHGYQF8TPNJLe98A56uYKYYR6e
# 2wjm1B7iQZ+EGnALM2g0dJdWgQtnkrfXdS1kZBOLGZceGpDFLJVn/yKUlq1+Ks7r
# fDTE5KjgQ81Ec3A3dUC7bc9j27vO8q2x82rwgA==
# SIG # End signature block
