Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        # installing Google Chrome 
 If  (Test-Path "HKLM:\SOFTWARE\Google\Chrome" )  
       { 
        Write-Host "Google Chrome already installed :)" -ForegroundColor Green
       }
                
Elseif ( Start-Process -FilePath "choco" -ArgumentList "install googlechrome -ignore-checksums -y --no-progress" -Wait)
        {
         Write-Host "intalliing Google Chorome server " -ForegroundColor Yellow
        }

         ##Installing MS office
if (Test-Path "HKLM:\SOFTWARE\Microsoft\Office\15.0")
        {
         Write-Host "Office alrady intalled on system :) " -ForegroundColor Green 
        }
Elseif ( Start-Process -FilePath "choco" -ArgumentList "Install Office365ProPlus -y " -Wait )
        { Write-Host "Intalling Office in-progress" -ForegroundColor Yellow 
        }
       
       ##Installiing carbon notepadplusplus winmerge 
if ( Test-Path HKLM:\SOFTWARE\Notepad++ )
        {
        Write-Host "carbon notepadplusplus winmerge already installed on system :)" -ForegroundColor Green
        }
Elseif ( Start-Process -FilePath "choco" -ArgumentList "install carbon notepadplusplus winmerge --no-progress" -Wait)
        {
         Write-Host "Intalling Corbon + Notepad + Winmerge..." -ForegroundColor Yellow
        }
         ##Installiing Net3
if ( Test-Path HKLM:\SOFTWARE\Microsoft\.NETFramework\v3.0 )
        {
        Write-Host " Microsoft .Net3.0 Already installed on system :)" -ForegroundColor Green
        }
Elseif ( Start-Process -FilePath "Choco" -ArgumentList "Intall dotnet3.5 dotnet4.5 --no-progress" -Wait)
        {
         Write-Host " Intalling Microsoft .Net3.0... " -ForegroundColor Yellow 
        }
        
###Installing SMTP Role
     $CheckSMTP = Get-WindowsFeature -Name "SMTP-Server"
if ( $CheckSMTP.InstallState -like "Installed" )
       { Write-Host "Windows SMTP-Server Already Enabled" -ForegroundColor Green}

 Elseif ( $SMTPInstall = Add-WindowsFeature SMTP-Server -IncludeAllSubFeature )
		{if ($IISInstall.RestartNeeded) {
			$Script:RebootNeeded = $true }
		  {Write-Host " Installing Windows SMTP-Server " -ForegroundColor Yellow } }
          


<# Install IIS server Role if restart needed it will restart server #>
$WinFetuers = Get-WindowsOptionalFeature -Online | where FeatureName -like 'IIS-WebServer'
if ( $WinFetuers.State -like "Enabled" )
    {
     Write-Host "Windows IIS-Webserver Already Enabled" -ForegroundColor Green
    }
Elseif  ( $IISInstall = Add-WindowsFeature -Name Web-Default-Doc,Web-Dir-Browsing,Web-Http-Errors,Web-Static-Content,Web-Http-Redirect,Web-Health,Web-Performance,Web-Filtering,Web-Basic-Auth,Web-Client-Auth,Web-Digest-Auth,Web-Cert-Auth,Web-IP-Security,Web-Url-Auth,Web-Windows-Auth,Web-App-Dev,Web-Net-Ext,Web-Net-Ext45,Web-ASP,Web-Asp-Net,Web-Asp-Net45,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Mgmt-Tools -IncludeAllSubFeature )
		{if ($IISInstall.RestartNeeded) {
			$Script:RebootNeeded = $true }
		  {
            Write-Host " Installing Windows IIS-Webserver " -ForegroundColor Yellow
          } }
          <# Install URLRewrite for Prirequsite wiht choco package manger  #>
         { Start-Process -FilePath "choco" -ArgumentList "install urlrewrite -y" -Wait}


<# SQL intallation Script Make sure before installing the SQL and creating database create User ShufflrrAdmin    #>

## Create User Account for database server ShufflrrAdmin

$Password = "Shufflrr@123" | ConvertTo-SecureString -AsPlainText -force
New-LocalUser  "ShufflrrAdmin" -Password $Password  | Add-LocalGroupMember -Group "administrators"


##Install database 

##Check SQL First if installed
If  (Test-Path “HKLM:\Software\Microsoft\Microsoft SQL Server\Instance Names\SQL”) 
        {  Write-host "SQL Server is already installed" -ForegroundColor Green }
			
    Else{ <# Installing SQL server #>
		Write-Progress -Activity "Installing SQL Server Express" -Status "SQL Server Installation"
		Start-Process -FilePath "choco" -ArgumentList 'install sql-server-express -ia "/QS /ACTION=install /FEATURES=SQL,Tools /INSTANCENAME=MSSQLSERVER /IACCEPTSQLSERVERLICENSETERMS=1 /ENU" -o -y' -Wait
		Start-Process -FilePath "choco" -ArgumentList "install sql-server-management-studio -y"
	    } 


## Now create database it will ask you server give server IP or hostname, then give datbasename

Function Create-Database {
    Param(
        [Parameter(Mandatory = $true)]
        [String]$Server ,
        [Parameter(Mandatory = $true)]
        [String]$DBName,
        [Parameter(Mandatory = $false)]
        [int]$SysFileSize = 5,
        [Parameter(Mandatory = $false)]
        [int]$UserFileSize = 25,
        [Parameter(Mandatory = $false)]
        [int]$LogFileSize = 25,
        [Parameter(Mandatory = $false)]
        [int]$UserFileGrowth = 5,
        [Parameter(Mandatory = $false)]
        [int]$UserFileMaxSize = 100,
        [Parameter(Mandatory = $false)]
        [int]$LogFileGrowth = 5,
        [Parameter(Mandatory = $false)]
        $LogFileMaxSize = 100,
        [Parameter(Mandatory = $false)]
        [String]$DBRecModel = 'FULL'
    )
 
    try {
        # Set server object
        $srv = New-Object ('Microsoft.SqlServer.Management.SMO.Server') $server
        $DB = $srv.Databases[$DBName]
    
        # Define the variables
        # Set the file sizes (sizes are in KB, so multiply here to MB)
        $SysFileSize = [double]($SysFileSize * 1024.0)
        $UserFileSize = [double] ($UserFileSize * 1024.0)
        $LogFileSize = [double] ($LogFileSize * 1024.0)
        $UserFileGrowth = [double] ($UserFileGrowth * 1024.0)
        $UserFileMaxSize = [double] ($UserFileMaxSize * 1024.0)
        $LogFileGrowth = [double] ($LogFileGrowth * 1024.0)
        $LogFileMaxSize = [double] ($LogFileMaxSize * 1024.0)
   
 
        Write-Output "Creating database: $DBName"
 
        # Set the Default File Locations
        $DefaultDataLoc = $srv.Settings.DefaultFile
        $DefaultLogLoc = $srv.Settings.DefaultLog
 
        # If these are not set, then use the location of the master db mdf/ldf
        if ($DefaultDataLoc.Length -EQ 0) {$DefaultDataLoc = $srv.Information.MasterDBPath}
        if ($DefaultLogLoc.Length -EQ 0) {$DefaultLogLoc = $srv.Information.MasterDBLogPath}
 
        # new database object
        $DB = New-Object ('Microsoft.SqlServer.Management.SMO.Database') ($srv, $DBName)
 
        # new filegroup object
        $PrimaryFG = New-Object ('Microsoft.SqlServer.Management.SMO.FileGroup') ($DB, 'PRIMARY')
        # Add the filegroup object to the database object
        $DB.FileGroups.Add($PrimaryFG )
 
        # Best practice is to separate the system objects from the user objects.
        # So create a seperate User File Group
        $UserFG = New-Object ('Microsoft.SqlServer.Management.SMO.FileGroup') ($DB, 'UserFG')
        $DB.FileGroups.Add($UserFG)
 
        # Create the database files
        # First, create a data file on the primary filegroup.
        $SystemFileName = $DBName + "_System"
        $SysFile = New-Object ('Microsoft.SqlServer.Management.SMO.DataFile') ($PrimaryFG , $SystemFileName)
        $PrimaryFG.Files.Add($SysFile)
        $SysFile.FileName = $DefaultDataLoc + $SystemFileName + ".MDF"
        $SysFile.Size = $SysFileSize
        $SysFile.GrowthType = "None"
        $SysFile.IsPrimaryFile = 'True'
 
        # Now create the data file for the user objects
        $UserFileName = $DBName + "_User"
        $UserFile = New-Object ('Microsoft.SqlServer.Management.SMO.Datafile') ($UserFG, $UserFileName)
        $UserFG.Files.Add($UserFile)
        $UserFile.FileName = $DefaultDataLoc + $UserFileName + ".NDF"
        $UserFile.Size = $UserFileSize
        $UserFile.GrowthType = "KB"
        $UserFile.Growth = $UserFileGrowth
        $UserFile.MaxSize = $UserFileMaxSize
 
        # Create a log file for this database
        $LogFileName = $DBName + "_Log"
        $LogFile = New-Object ('Microsoft.SqlServer.Management.SMO.LogFile') ($DB, $LogFileName)
        $DB.LogFiles.Add($LogFile)
        $LogFile.FileName = $DefaultLogLoc + $LogFileName + ".LDF"
        $LogFile.Size = $LogFileSize
        $LogFile.GrowthType = "KB"
        $LogFile.Growth = $LogFileGrowth
        $LogFile.MaxSize = $LogFileMaxSize
 
        #Set the Recovery Model
        $DB.RecoveryModel = $DBRecModel
        #Create the database
        $DB.Create()
 
        #Make the user filegroup the default
        $UserFG = $DB.FileGroups['UserFG']
        $UserFG.IsDefault = $true
        $UserFG.Alter()
        $DB.Alter()
 
        Write-Output " $DBName Created"
        Write-Output "System File"
        $SysFile| Select Name, FileName, Size, MaxSize, GrowthType| Format-List
        Write-Output "User File"
        $UserFile| Select Name, FileName, Size, MaxSize, GrowthType, Growth| Format-List
        Write-Output "LogFile"
        $LogFile| Select Name, FileName, Size, MaxSize, GrowthType, Growth| Format-List
        Write-Output "Recovery Model"
        $DB.RecoveryModel
 
    }
    Catch {
        $error[0] | fl * -force
    }
}