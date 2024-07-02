Test-NetConnection wayneent.com -port 389
Test-NetConnection wayneent.com -port 636
Test-NetConnection wayneent.com -Port 88

# Trust Status
Get-ADTrust -Filter {Name -eq "wayneent.com"}

# Verify Hotfix
Get-Hotfix | Where-Object {$_.hotfixid -eq "KB5014011"}
