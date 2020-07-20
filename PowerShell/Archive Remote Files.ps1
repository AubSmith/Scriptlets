#Enter remote interactive PowerShell session

$HostName = ""
$Cred = Get-Credential

Enter-PSSession $HostName -Credential $Cred

# Wait 10 seconds, otherwise the script may run from the wrong session location

Start-Sleep 10

#Change to the source directory

$Location = "D:\Source\"

Set-Location $Location

# Set the target destination

$Destination = "D:\Code\"

# Find the target specific file types and copy them to the target path

#Get-ChildItem -Path .\ -Filter *.docx -Recurse -File | Copy-Item -Destination $Destination -Recurse -Force

# Download entire directory

Get-ChildItem -Path .\ -Recurse | Copy-Item -Destination $Destination -Recurse -Force

# Exit the remote interactive PowerShell session

Exit-PSSession