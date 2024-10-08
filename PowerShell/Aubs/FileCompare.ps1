# Example usage:
# PowerShell .\FileCompare.ps1 ".\file1.txt" ".\file2.txt"

[CmdletBinding()]
Param(
  [parameter(mandatory=$true,Position=1)]
  [string]$FilePath1,
  [parameter(mandatory=$true,Position=2)]
  [string]$FilePath2
)

function Compare-Files {
	param (
		[string]$FilePath1,
		[string]$FilePath2,
		[string]$LogFilePath = "FileComparisonLog.txt"
	)

	# Read the contents of the files into arrays
	$file1Content = Get-Content -Path $FilePath1
	$file2Content = Get-Content -Path $FilePath2

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


Compare-Files -FilePath1 $FilePath1 -FilePath2 $FilePath2
