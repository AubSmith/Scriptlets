New-SelfSignedCertificate -Subject 'Smith Secure' -Type DocumentEncryptionCertLegacyCsp

Protect-CmsMessage -To cert_thumbprint -Path 'D:\Code\Test.txt' -OutFile 'D:\Code\Test2.txt'

Unprotect-CmsMessage -Path 'D:\Code\Test2.txt' -To cert_thumbprint 
