# PowerShell script to get a list of AD groups that a user belongs to

# Prompt for the user's SamAccountName
$UserSamAccountName = Read-Host "Please enter the user's SamAccountName"

# Get the user object including the groups they are a member of
$User = Get-ADUser -Identity $UserSamAccountName -Properties MemberOf

# Extract the group names from the MemberOf property
$GroupNames = $User.MemberOf | ForEach-Object { (Get-ADGroup -Identity $_).Name }

# Display the group names
$GroupNames | ForEach-Object { Write-Host $_ }
