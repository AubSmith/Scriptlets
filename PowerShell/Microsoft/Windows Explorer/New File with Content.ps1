New-Item -Path 'C:\temp\New Folder' -ItemType Directory

New-Item -Path 'C:\temp\New Folder\file.txt' -ItemType File

Remove-Item -Path 'C:\temp\New Folder' -Recurse

New-Item .\Test.txt
Set-Content .\Test.txt "Ethan was here!"
