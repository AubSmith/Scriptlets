install-Module -Name CredentialManager -Repository PSGallery

Start-Process PowerShell.exe -Credential ""

Import-Module CredentialManager

runas /user:admin "C:\Windows\notepad.exe"

Get-Credential -Username test -Message "Please enter your password: " | New-StoredCredential -Comment "Proxy access" -Persist LocalMachine -Target proxy.test.nz -Type Generic

Get-StoredCredential -AsCredentialObject

# Get the credential from the user with a windows credentials prompt:
$SessionCredential = Get-Credential -Message 'Please enter your server credentials'

# Save the credential object directly without unwrapping it:
New-StoredCredential -Credentials $SessionCredential -Target ServerCredentials -Persist Enterprise `
  -Comment "Server Credentials for $($SessionCredential.UserName)" > $null

# Open the credential later
# $SavedCred = Get-StoredCredential -Target ServerCredentials

# Delete if needed
Remove-StoredCredential -Target ServerCredentials




# install-Module -Name CredentialManager -Repository PSGallery

# Import-Module CredentialManager

# Get the credential from the user with a windows credentials prompt:
# $SessionCredential = Get-Credential -Message 'Please enter proxy credentials'

# Start-Process PowerShell .\client.ps1 -Credential ""

# Save the credential object directly without unwrapping it:
# New-StoredCredential -Credentials $SessionCredential -Comment "SWG Proxy configuration" -Persist LocalMachine -Target http://proxy.test.nz -Type DomainPassword

# Open the credential later
#$SavedCred = Get-StoredCredential -Target ServerCredentials

# Delete if needed
#Remove-StoredCredential -Target ServerCredentials

# Get-StoredCredential -AsCredentialObject




param([securestring]$SessionCredential="")

Import-Module CredentialManager

New-StoredCredential -Credentials $SessionCredential -Comment "SWG Proxy configuration" -Persist LocalMachine -Target http://proxy.test.nz -Type DomainPassword