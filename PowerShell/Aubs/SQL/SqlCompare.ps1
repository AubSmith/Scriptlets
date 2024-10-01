# Example usage:
# PowerShell .\SqlCompare.ps1


# Import the SqlServer module
Import-Module SqlServer


# Define the function to get the environment
function Get-Environment {
    # Prompt for environment selection
    $environment = Read-Host -Prompt "Select the environment to compare:
                                      Production
                                      OAT
                                      SIT
                                      DEV"

    return $environment
}


# Define the function to get credentials
function Get-Credentials {
    $username = Read-Host -Prompt "Use downlevel login in the form: domain\username
                                   Enter your username"

    $password = Read-Host -AsSecureString -Prompt "Enter your password"

    return $username, $password
}


# Define the function to query a SQL database
function Query-Sql {
	param (
        [string]$instance,
        [string]$databaseName,
		[string]$username,
		[string]$password,
        [string]$query
	)

    Write-Output "Connecting to to SQL..."

    # Define the connection string
    $connectionString = 'Server=$server;Database=$databaseName;UID=$username;PWD=$password;Integrated Security=true;'

    # Define the SQL query
    $query = Get-Content -Path .\SqlQuery.sql

    # Execute the query
    Invoke-Sqlcmd -ConnectionString $connectionString -Query $query

    # Define the output file path
    $outputFilePath = "C:\path\to\output.txt"

    # Write the results to the file
    $result | Out-File -FilePath $outputFilePath

}


# Define the function to compare two files
function Compare-Files {
	param (
		[string]$extractEnvironment1,
		[string]$extractEnvironment2,
		[string]$LogFilePath = "Difference_Log.txt"
	)

	# Read the contents of the files into arrays
	$file1Content = Get-Content -Path $extractEnvironment1
	$file2Content = Get-Content -Path $extractEnvironment2

	# Find lines that are in the first file but not in the second (removed lines)
	$removedLines = $file1Content | Where-Object { $_ -notin $file2Content }

	# Find lines that are in the second file but not in the first (added lines)
	$addedLines = $file2Content | Where-Object { $_ -notin $file1Content }

	# Write the differences to the log file
	$logContent = @()
	$logContent += "Removed Lines:"
	$logContent += $removedLines
	$logContent += ""
	$logContent += "Added Lines:"
	$logContent += $addedLines

	$logContent | Out-File -FilePath $LogFilePath

	Write-Output "Comparison complete. Log written to $LogFilePath"
}


try {
    $environment1 = Get-Environment()
    
    $username1, $password1 = Get-Credentials()
}
catch {
    Write-Output $_
    Exit 1
}





# Set variables based on the environment
switch ($environment) {
    "Production" {
        $instance = "DESKTOP-EM8HVC2"
        $databaseName = "AdventureWorks2022"
    }
    "OAT" {
        $instance = "OATServer"
        $databaseName = "OATDatabase"
    }
    "SIT" {
        $instance = "SITServer"
        $databaseName = "SITDatabase"
    }
    "DEV" {
        $instance = "DEVServer"
        $databaseName = "DEVDatabase"
    }
    default {
        Write-Output "Invalid environment selected. Please select one of the following:
                      Production
                      OAT
                      SIT
                      DEV"
        exit
    }
}




<#
select environment 1
    get creds
    set vars

select environment 2
    get creds
    set vars

query sql
#>