# Here are the requirements for the public key certificate:
# The certificate must include the "Data Encipherment" or "Key Encipherment" Key Usage in the property details of the certificate.
# The certificate must include the "Document Encryption" Enhanced Key Usage (EKU), which is identified by OID number 1.3.6.1.4.1.311.80.1.
# To confirm that your intended certificate meets these requirements, double-click the certificate file (.cer) to view its properties, go to the Details tab, and confirm that the "Enhanced Key Usage" property at least includes this line:
# Document Encryption (1.3.6.1.4.1.311.80.1)
# And also in that certificate's properties, confirm that the "Key Usage" field includes one or both of these:
# Key Encipherment
# Data Encipherment

New-SelfSignedCertificate -Subject 'Smith Secure' -Type DocumentEncryptionCertLegacyCsp
New-SelfSignedCertificate -DnsName pewa2303 -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsage KeyEncipherment,DataEncipherment,KeyAgreement -Type DocumentEncryptionCert
Export-PfxCertificate -Cert Cert:\CurrentUser\My\9209C2F587CC95B6F229279ACDB8B3765C1D054B -FilePath C:\Temp\cert.pfx -Password (ConvertTo-SecureString -AsPlainText '123' -Force)

New-Item -ItemType File -Path C:\Temp\pwd.txt
'password' | Protect-CmsMessage -To cn=pewa2303 -OutFile C:\Temp\pwd.txt
Unprotect-CmsMessage -Path C:\Temp\pwd.txt

$password = ConvertTo-SecureString (Unprotect-CmsMessage -Path C:\Temp\pwd.txt) -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ('sid-500\administrator', $password )
Enter-PSSession -ComputerName dc01 -Credential $cred

# C:\Program Files\Windows PowerShell\Modules\Enter-PSSessionPW\Enter-PSSessionPW.psm1

function Enter-PSSessionPW {
 
    [CmdletBinding()]
     
    param (
     
    [Parameter(Position=0)]
    $ComputerName='localhost'
     
    )
     
    $password = ConvertTo-SecureString (Unprotect-CmsMessage -Path C:\Temp\pwd.txt) -AsPlainText -Force
    $cred= New-Object System.Management.Automation.PSCredential ("sid-500\administrator", $password)
     
    Enter-PSSession -ComputerName $ComputerName -Credential $cred
     
    }





# A couple helper functions to go to/from Base64 and binary:
function Convert-FromBinaryFileToBase64
{
[CmdletBinding()]
Param
(
[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)] $Path,
[Switch] $InsertLineBreaks
)
 
if ($InsertLineBreaks){ $option = [System.Base64FormattingOptions]::InsertLineBreaks }
else { $option = [System.Base64FormattingOptions]::None }
 
[System.Convert]::ToBase64String( $(Get-Content -ReadCount 0 -Encoding Byte -Path $Path) , $option )
}
 
  
 
function Convert-FromBase64ToBinaryFile
{
[CmdletBinding()]
Param( [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)] $String ,
[Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $False)] $OutputFilePath )
 
[System.Convert]::FromBase64String( $String ) | Set-Content -OutputFilePath $Path -Encoding Byte
 
}





# To encrypt the contents of a variable using an exported certificate:
$x = get-process            #Some object data to protect
Protect-CmsMessage -To .\ExportedCert.cer -Content $x -OutFile EncryptedVar.cms
 
# To encrypt a TEXT file using an exported certificate, saving the output to a new file:
Protect-CmsMessage -To .\ExportedCert.cer -Path .\SecretDocument.txt -OutFile EncryptedDoc.cms
 
# To encrypt a variable or TEXT file using an exported certificate, capturing the output to a new variable:
$CipherText1 = Protect-CmsMessage -To .\ExportedCert.cer -Content $x
$ciphertext1 = Protect-CmsMessage -To .\ExportedCert.cer -Path .\SecretDocument.txt
 
# To decrypt CMS ciphertext, assuming you have the private key:
$plaintext = Unprotect-CmsMessage -Path .\EncryptedVar.cms
$plaintext = Unprotect-CmsMessage -Content $CipherText1
$plaintext = Unprotect-CmsMessage -Path .\EncryptedFile.cms
Write-Output $plaintext


# Convert the binary file to Base64 strings, then encrypt:
Get-ChildItem .\InputFile.exe | Convert-FromBinaryFileToBase64 | Protect-CmsMessage -To .\ExportedCert.cer -OutFile OutputFile.cms # dir = alias for Get-ChildItem

# Then the file can be decrypted and the Base64 converted back into a binary file again:
Unprotect-CmsMessage -Path .\OutputFile.cms | Convert-FromBase64ToBinaryFile -OutputFilePath .\RestoredFile.exe
 
# Now the hashes will match:
Get-FileHash -Path .\InputFile.exe,.\RestoredFile.exe

Protect-CmsMessage -To cert_thumbprint -Path 'D:\Source\Sensitive.crt' -OutFile 'D:\Source\Protected.crt'

Unprotect-CmsMessage -Path 'D:\Code\Protected.crt' -To cert_thumbprint
