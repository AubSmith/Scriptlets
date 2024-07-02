param([securestring]$SessionCredential="")

Import-Module CredentialManager

New-StoredCredential -Credentials $SessionCredential -Comment "SWG Proxy configuration" -Persist LocalMachine -Target http://proxy.test.nz -Type DomainPassword