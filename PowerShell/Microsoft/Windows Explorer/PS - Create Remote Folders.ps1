$ComputerName = ""
$DriveLetter = "D"
$Path1 = "Software"
$Path2 = "Microsoft"
$Path3 = "3rd Party"
New-Item -Path \\$ComputerName\$DriveLetter$\$Path1 -Type Directory -Force
New-Item -Path \\$ComputerName\$DriveLetter$\$Path1\$Path2 -Type Directory -Force
New-Item -Path \\$ComputerName\$DriveLetter$\$Path1\$Path3 -Type Directory -Force