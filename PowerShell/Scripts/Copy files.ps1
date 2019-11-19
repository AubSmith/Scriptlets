<#
.SYNOPSIS
    Copies folder content from source location to destination including ACLs.    
.DESCRIPTION
    Copies folder content from source location to destination including ACLs. 
    If the files and folders in the destination location already exist, the script performs an incremental copy.
    Every item that was changed before the copy process started will be copied to the destination.
    The error log file is created and populated with errors that occurred during the copy process, if any. 
.PARAMETER Source
    Path to the folder of the network share that will be copied.
.PARAMETER Destination
    Path to the folder of the network share where the source content will be copied.  
.PARAMETER Log
    Path to the log file to save copy errors if any. If omitted, it will save logs to the c:\temp\copylog.txt file.
    
.EXAMPLE
    PS C:\Scripts\> .\Copy_Folders_and_subfilders_with_Error_Logging_Incrementaly.ps1 -Source \\windows10\share1 -Destination \\windows10\share2 -Log c:\temp\copylog.log
    This example copies files and folders from the \\windows10\share1 location to the \\windows10\share2 one and stores errors in the c:\temp\copylog.log file.
.NOTES
    Author: Alex Chaika
    Date:   May 17, 2016    
#>
[CmdletBinding()]
Param(
   [Parameter(Mandatory=$True)]
   [string]$Source,
   [Parameter(Mandatory=$True)]
   [String]$Destination,
   [Parameter(Mandatory=$False)]
   [String]$Log
)
if (!($Log)) {
    $Log = "c:\temp\copylog.txt"
}
$Error.Clear()
$Dt = Get-Date
New-Item -ItemType file -Path $Log -Force
"Starting incremental sync process for: $Source folder at $Dt" | Out-File $Log -Append
xcopy $Source $Destination /c /s /e /r /h /d /y /x
$Dt = Get-Date
"Incremental sync process for: $Source folder has completed at $Dt The following errors occurred:" | Out-File $Log -Append
" " | Out-File $Log -Append
"$Error" | Out-File $Log -Append