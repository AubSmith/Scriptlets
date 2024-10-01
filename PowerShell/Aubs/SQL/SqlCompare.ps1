# Example usage:
# PowerShell .\SqlCompare.ps1


# Import the SqlServer module
Import-Module SqlServer


# Define the function to get the environment
function Get-Environment {
    # Prompt for environment selection
    $environment = Read-Host -Prompt "Select the environment to compare:
                                      Prod
                                      OAT
                                      SIT
                                      DEV
Enter your environment"

	# Set variables based on the environment
	switch ($environment) {
	    "Prod" {
	        $instance = "DESKTOP-EM8HVC2"
	        $dbName = "AdventureWorks2022"
	    }
	    "OAT" {
	        $instance = "DESKTOP-EM8HVC2"
	        $dbName = "AdventureWorks2019"
	    }
	    "SIT" {
	        $instance = "SITServer"
	        $dbName = "SITDatabase"
	    }
	    "DEV" {
	        $instance = "DEVServer"
	        $dbName = "DEVDatabase"
	    }
	    default {
	        Write-Output "Invalid environment selected. Please select one of the following:
	                      Prod
	                      OAT
	                      SIT
	                      DEV

						 Environment: "

	        exit
	    }
	}

    return $environment, $instance, $dbName
}


# Define the function to get credentials
function Get-Credentials {
    $username = Read-Host -Prompt "Use downlevel login in the form: domain\username
Enter your username"

    $password = Read-Host -AsSecureString -Prompt "Enter your password"

    return $username, $password
}


# Define the function to query a SQL database
function Get-SqlQuery {
	param (
        [string]$instance,
        [string]$dbName,
		[string]$username,
		[securestring]$password,
		[string]$environment
	)

    Write-Output "Connecting to to SQL..."

    # Define the connection string
    # $connectionString = "Server=$instance; Database=$dbName; UID=$username; PWD=$password; Integrated Security=true;"
	$connectionString = "Server=$server; Database=$databaseName; Integrated Security=true; TrustServerCertificate=True;"

    # Define the SQL query
    $query = "SELECT TOP (5) [LocationID]
		,[Name]
		,[CostRate]
		,[Availability]
		,[ModifiedDate]
	FROM [AdventureWorks2022].[Production].[Location]
	ORDER BY LocationID ASC;"

    # Execute the query
    $result = Invoke-Sqlcmd -ConnectionString $connectionString -Query $query

    # Write the results to the file
    $result | Export-Csv -Path ".\$environment.csv" -NoTypeInformation

}


# Define the function to compare two files
function Compare-Files {
	param (
		[string]$firstEnv,
		[string]$secondEnv,
		[string]$LogFilePath = ".\Difference_Log.txt"
	)

	# Read the contents of the files into arrays
	$file1Content = Get-Content -Path ".\$firstEnv.csv"
	$file2Content = Get-Content -Path ".\$secondEnv.csv"

	# Find lines that are in the first file but not in the second (removed lines)
	$removedLines = $file1Content | Where-Object { $_ -notin $file2Content }

	# Find lines that are in the second file but not in the first (added lines)
	$addedLines = $file2Content | Where-Object { $_ -notin $file1Content }

	# Write the differences to the log file
	$logContent = @()
	$logContent += "Rows in $firstEnv not in $secondEnv :"
	$logContent += $removedLines
	$logContent += ""
	$logContent += "Rows in $secondEnv not in $firstEnv :"
	$logContent += $addedLines

	$logContent | Out-File -FilePath $LogFilePath

	Write-Output "Comparison complete. Log written to $LogFilePath"
}


try {
    $environment, $instance, $dbName = Get-Environment
	
    $username, $password = Get-Credentials

	Get-SqlQuery $instance $dbName $username $password $environment

	$firstEnv = $environment

}
catch {
    Write-Output $_
    Exit 1
}

try {
    $environment, $instance, $dbName = Get-Environment
	
    $username, $password = Get-Credentials

	Get-SqlQuery $instance $dbName $username $password $environment

	$secondEnv = $environment

}
catch {
    Write-Output $_
    Exit 1
}


try {
	Compare-Files $firstEnv $secondEnv
}
catch {
	Write-Output $_
    Exit 1	
}
