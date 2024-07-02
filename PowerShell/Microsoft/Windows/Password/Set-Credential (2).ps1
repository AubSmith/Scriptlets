# install-Module -Name CredentialManager -Repository PSGallery

# Import-Module CredentialManager

$credential = Get-Credential # You will be prompted for the username and password here.

Enter-PSSession -Credential $credential

# Run your PowerShell commands here.

# Exit-PSSession

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
