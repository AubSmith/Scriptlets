# Using New-PSSession starts a persistent session

$ComputerName = 

New-PSSession -ComputerName $ComputerName

# Using Invoke-Command used to exit a single command or script

$ComputerName =
$ScriptPath =

Invoke-Command -ComputerName $ComputerName -FilePath $ScriptPath

# Start an interactive PowerShell session

$ComputerName =

Enter-PSSession $ComputerName

# End the interactive PowerShell session

Exit-PSSession