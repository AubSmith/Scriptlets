#requires -Version 3

#Setting Global variables

$Global:logDir = 'c:\\wwwlogs\\' #Location of IIS logs
$Global:archDir = 'c:\wwwlogs-archive\' #archive directory location
$Global:logFile = 'c:\temp\maintain-iislogs.txt'
$global:logTime = Get-Date -Format 'MM-dd-yyyy_hh-mm-ss'

Clear-Content $LogFile

function Compress-Logs 
{
    
    <#### 7 zip variable I got it from the below link
            #### http://mats.gardstad.se/matscodemix/2009/02/05/calling-7-zip-from-powershell/ 
    # Alias for 7-zip ##>
    
    if (-not (Test-Path -Path "$env:ProgramFiles\7-Zip\7z.exe"))  #update path to point to the location of 7-zip
    {
        throw "$env:ProgramFiles\7-Zip\7z.exe needed"
    }
    Set-Alias -Name sz -Value "$env:ProgramFiles\7-Zip\7z.exe"


    $days = '-6' #this will result in 7 days of non-zipped log files

    $logs = Get-ChildItem -Recurse -Path $logdir -Attributes !Directory -Filter *.log  | Where-Object -FilterScript {
        $_.LastWriteTime -lt (Get-Date).AddDays($days)
    }


    foreach ($log in $logs) 
    {
        $name = $log.name
        $directory = $log.DirectoryName
        $LastWriteTime = $log.LastWriteTime
        $zipfile = $name.Replace('.log','.7z')
        
        sz a -t7z "$directory\$zipfile" "$directory\$name"
        
        if($LastExitCode -eq 0) 
        {
            Get-ChildItem $directory -Filter $zipfile | % {$_.LastWriteTime = $LastWriteTime} #sets the LastWriteTime of the zip file to match the original log file
            Remove-Item -Path $directory\$name
            $logtime + ': Created archive ' + $directory + '\' + $zipfile + '. Deleted original logfile: ' + $name | Out-File $logfile -Encoding UTF8 -Append
        }
    }

    ########### END OF FUNCTION ##########
}


function Archive-Logs 
{
    $archiveDays = '-13' #this will provide 7 days of zipped log files in the original directory - all others will be archived
    $logFolders = Get-ChildItem -Path $logdir -Attributes Directory
    $zipLogs = Get-ChildItem -Recurse -Path $logdir -Attributes !Directory -Filter *.7z  | Where-Object -FilterScript {
        $_.LastWriteTime -lt (Get-Date).AddDays($archiveDays)
    }   
    
    foreach ($logFolder in $logFolders)
    {
        $folder = $logFolder.name
        $folder = $folder -replace $logdir, ''
        $targetDir = $archdir + $folder
        if (!(Test-Path -Path $targetDir -PathType Container)) 
        {
            New-Item -ItemType directory -Path $targetDir
        }
    }
    
            
    foreach ($ziplog in $zipLogs) 
    {
        $origZipDir = $ziplog.DirectoryName
        $fileName = $ziplog.Name
        $source = $origZipDir + '\' + $fileName
        $destDir = $origZipDir -replace $logdir, ''
        $destination = $archdir + $destDir + '\' + $fileName
        Move-Item $source -Destination $destination
        $logtime + ': Moved archive ' + $source + ' to ' + $destination | Out-File $logfile -Encoding UTF8 -Append
    }            
}


Function Delete-logs {

    $delMonths = '-6' #retains 6 months of logs - adjust to meet your company's retention plan
    $delLogs = Get-ChildItem -Recurse -Path $archdir -Attributes !Directory -Filter *.7z  | Where-Object -FilterScript {
        $_.LastWriteTime -lt (Get-Date).AddMonths($delMonths)
        } 
   
    Foreach ($delLog in $delLogs) {
        $filename = $delLog.Name
        $delDir = $delLog.DirectoryName
        $delFile = $delDir+ '\' + $filename
        #Move-Item $delFile -Destination 'c:\Temp\cya'
        Remove-Item $delFile
        $logtime + ': Deleted archive ' + $delfile | Out-File $logfile -Encoding UTF8 -Append 
    }

}
        



Compress-Logs
Archive-Logs
Delete-Logs