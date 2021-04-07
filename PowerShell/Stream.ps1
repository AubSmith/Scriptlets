function Write-Messages

{

    [CmdletBinding()]

    param()   

    Write-Host "Host message"

    Write-Output "Output message"

    Write-Verbose "Verbose message"

    Write-Warning "Warning message"

    Write-Error "Error message"

    Write-Debug "Debug message"

}

 

# Writes all messages to console.

Write-Messages -Verbose -Debug

# Writes output to the file

# Writes all other messages to console.

Write-Messages -Verbose -Debug > .\OutputFile.txt

# Writes all output except Host messages to file

Write-Messages -Verbose -Debug *> .\OutputFile.txt

# Writes all output (except Host messages) to output stream, then saves them in a file.

Write-Messages -Verbose -Debug *>&1 | Out-File -FilePath .\OutputFile.txt

# Writes all messages to console and then saves all but host messages in a file.

Write-Messages -Verbose -Debug *>&1 | Tee-Object -FilePath .\OutputFile.txt