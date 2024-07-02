<#
.SYNOPSIS

This script is used to protect sensitive information that is stored/transferred publicly. 

.DESCRIPTION

This script is to be used to create encrypt sensitive files using the public key of a digital certificate. The private key is used to decrypt it.

.INPUTS

The thumbprint of, or a path to a certificate which will be used to secure the files.

.OUTPUTS

Output of the script is an encrypted file in the same location as the source file.

.NOTES

  Version:   1.0
  Author:    Aubrey Smith
  Created:   04 May 2018 (Star Wars Day - may the fourth be with you!)
  Change:    Initial script development

.Example

Execute from an elevated PowerShell shell.

#>

$Files = Get-ChildItem -Path .\ -Filter *.crt -Recurse -File

$Files | % {$_
                
         {Protect-CmsMessage -To -Path $_ -OutFile $_.cms}}

# END