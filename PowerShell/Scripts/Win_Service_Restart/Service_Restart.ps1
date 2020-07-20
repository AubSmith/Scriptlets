#*************************************************************************************
#	Script Name:	ServiceRestart.PS1
#	Date Created:	02/09/2016
#	Author:		Ramesh Shetty
#	Purpose:	This script used to restart the services for application based on country code provided
#    
#	Functions:(Repeat for each function. List in Alphabetical order)
#				LogWrite()-	Writes LogMessage to Log file defined in start of the code
#				FuncRestartService() - Performs core action (start/stop/restart) on passed service and server
#    
#---------------------------------------------------------------------------------
#    Change History: (Latest version at top)
#---------------------------------------------------------------------------------
#    Version Number:	1.0
#    Version Author:	Ramesh Shetty
#    Version Date:	02/09/2016
#    Version Overview:	Initial Script
#---------------------------------------------------------------------------------
#
#Requirements / Pre-requisites: Service account running this script should have access to services in target computer
#		<List of requirements one per line>
#*************************************************************************************
#
#GLOBAL VARIABLES (GLOBAL Variable Declarations in Alphabetical order)
#
#*************************************************************************************
$global:ReturnCode = 0
$global:LogFile
$global:LogMessage
#*************************************************************************************
#VARIABLES (Variable Declarations in Alphabetical order)
#
#*************************************************************************************

#

#*************************************************************************************
#
#FUNCTIONS USED BY BELOW CODE SECTION (In Alphabetical Order)
#
#*************************************************************************************
#
#Function Name:	LogWrite
#Inputs:		Input String to write to log file>
#Outputs:		Null
#Purpose:		Write input string to Log file path available in global variable
#

Function LogWrite
{
   Param ([string]$logstring)

   $logstring = "[$([DateTime]::Now)] $logstring"

   Add-content $Logfile -value $logstring
}


#*************************************************************************************
#
#Function Name:		FuncRestartService
#Inputs:		Action (Start/stop/restart), Server Name, Sarvice Name
#Outputs:		Return the error code. 0 for success
#Purpose:		Action on the service passed in target computer
#

function FuncRestartService
{
	param($Action, $serverName, $ServiceName)

	try
	{
	  $arrService = Get-Service  -Computer $ServerName -Name $ServiceName -ErrorAction Stop
	}
	Catch
	{
	  LogWrite "	*********************ERROR	ERROR	ERROR**********************"
	  $LogMessage = "ERROR: Unable to get service details for $ServiceName in server $ServerName"
	  LogWrite $LogMessage
	  $Global:ReturnCode = 8
	  $ErrorMessage = $_.Exception.Message
	  LogWrite $ErrorMessage 
	}

	  if ($arrService.Status -ne "Running")
	  {
	    $LogMessage = "Current Status: Service $ServiceName in server $ServerName is NOT Running (Stopped)."
	    LogWrite $LogMessage
	  }
	  else
    	  {
	    $LogMessage = "Current Status: Service $ServiceName in server $ServerName is in Running status (Started)."
	    LogWrite $LogMessage
	  }

	
	If ($Action -eq "stop")
	{
	  $LogMessage = "Stopping $ServiceName service in server $ServerName"
	  LogWrite $LogMessage

	  try
	  {
	    Stop-Service -InputObject $arrService -ErrorAction Stop
	  }
	Catch
	{
	  LogWrite "	*********************ERROR	ERROR	ERROR**********************"
	  $LogMessage = "ERROR: Unable to STOP service $ServiceName in server $ServerName"
	  LogWrite $LogMessage
	  $Global:ReturnCode = 8
	  $ErrorMessage = $_.Exception.Message
	  LogWrite $ErrorMessage 
	}

	  sleep 10
	  $ServiceStatus = Get-Service  -Computer $ServerName -Name $ServiceName

	  if ($ServiceStatus.Status -ne "Running")
	  {
	    $LogMessage = "Service $ServiceName stopped successfully in server $ServerName.Status of service is STOPPED"
	    LogWrite $LogMessage
	  }
	  else
    	  {
	   $LogMessage = "	*********************ERROR	ERROR	ERROR**********************"
           LogWrite $LogMessage
	   $LogMessage = "Service $ServiceName in server $ServerName could NOT be stopped.Status of service is STARTED.Please stop service manually"
	   LogWrite $LogMessage
	   $Global:ReturnCode = 4
	  }
	}

	ElseIf($Action -eq "start")
	{
	  $LogMessage = "Starting $ServiceName service in server $ServerName"
	  LogWrite $LogMessage

	  try
	  {
	    Start-Service  -InputObject $arrService -ErrorAction Stop
	  }
	Catch
	{
	  LogWrite "	*********************ERROR	ERROR	ERROR**********************"
	  $LogMessage = "ERROR: Unable to START service $ServiceName in server $ServerName"
	  LogWrite $LogMessage
	  $Global:ReturnCode = 8
	  $ErrorMessage = $_.Exception.Message
	  LogWrite $ErrorMessage 
	}

	  If ($ServiceName -eq "MBGateway")
	  {
		sleep 90
	  }
	  else
	  {
		sleep 10
	  }
	  



	  $ServiceStatus = Get-Service  -Computer $ServerName -Name $ServiceName

	  if ($ServiceStatus.Status -eq "Running")
	  {
	    $LogMessage = "Service $ServiceName started successfully in server $ServerName.Status of service is STARTED"
	    LogWrite $LogMessage
	  }
	  else
    	  {
	   $LogMessage = "	*********************ERROR	ERROR	ERROR**********************"
	   LogWrite $LogMessage
	   $LogMessage = "Service $ServiceName in server $ServerName could NOT be started.Status of service is STOPPED.Please start service manually"
	   LogWrite $LogMessage
	   $Global:ReturnCode = 4
	  }
	}

	ElseIf($Action -eq "restart")
	{
	  $LogMessage = "ReStarting $ServiceName service in server $ServerName"
	  LogWrite $LogMessage

	  try
	  {
	    Restart-Service  -InputObject  $arrService -ErrorAction Stop
	  }
	Catch
	{
	  LogWrite "	*********************ERROR	ERROR	ERROR**********************"
	  $LogMessage = "ERROR: Unable to START service $ServiceName in server $ServerName"
	  LogWrite $LogMessage
	  $Global:ReturnCode = 8
	  $ErrorMessage = $_.Exception.Message
	  LogWrite $ErrorMessage 
	}

	  If ($ServiceName -eq "MBGateway")
	  {
		sleep 90
	  }
	  else
	  {
		sleep 10
	  }

	  $ServiceStatus = Get-Service  -Computer $ServerName -Name $ServiceName

	  if ($ServiceStatus.Status -eq "Running")
	  {
	    $LogMessage = "Service $ServiceName RESTARTED successfully in server $ServerName.Status of service is STARTED"
 	    LogWrite $LogMessage
	  }
	  else
    	  {
	   $LogMessage = "	*********************ERROR	ERROR	ERROR**********************"
	   LogWrite $LogMessage
	   $LogMessage = "Service $ServiceName in server $ServerName could NOT be restarted.Status of service is STOPPED.Please start service manually"
	   LogWrite $LogMessage
	   $Global:ReturnCode = 4
	  }
	}

	Else
	{
	  LogWrite "	WARNING WARNING WARNING"
	  $LogMessage = "Invalid action parameter passed.NO ACTION TAKEN BY SCRIPT. Valid parameter for actions are start/stop/restart. Parameter Passed: $Action"
	  LogWrite $LogMessage
	  $Global:ReturnCode = 2
	}

}




$Action=$args[0]
$CountryCode=$args[1]
$SRCSystem=$args[2]

$InputDirectory = Split-Path $script:MyInvocation.MyCommand.Path

$LogFile = "$InputDirectory\JobRunLog.log"
$SRCFile = "$InputDirectory\$SRCSystem"

$CCNotFound = $TRUE

LogWrite " "
LogWrite " "
$LogMessage = "Parameter passed Action: $Action . Country: $CountryCode . Input file: $SRCFile"
LogWrite $LogMessage

try
{
  $ServerList = Get-Content $SRCFile  -ErrorAction Stop
}

	Catch
	{
	  LogWrite "	*********************ERROR	ERROR	ERROR**********************"
	  $LogMessage = "ERROR: Unable read input file $SRCFile"
	  LogWrite $LogMessage
	  $Global:ReturnCode = 8
	  $ErrorMessage = $_.Exception.Message
	  LogWrite $ErrorMessage 
	  Break
	}



  foreach ($InputLine in $ServerList)
  {


	$TotalLength = $InputLine.length
	$ServiceNameLength = $TotalLength - 17

	$FileCC = $InputLine.substring(0,2)
	$ServerName = $InputLine.substring(2,15)
	$ServiceName = $InputLine.substring(17,$ServiceNameLength)


	

	If (($FileCC -eq $CountryCode) -or ($CountryCode -eq "ALL"))
	{

		$CCNotFound = $FALSE
		If (Test-Connection -ComputerName $ServerName -Quiet)
		{
			LogWrite " "
 			LogWrite "Validation successful. Actioning on service $ServiceName in server $ServerName"

    			FuncRestartService $Action $ServerName $ServiceName
		}
		else
		{
 			LogWrite "	*********************ERROR	ERROR	ERROR**********************"
 			$LogMessage = "Unable to ping server $ServerName. Please check server is up and running"
 			LogWrite $LogMessage
        	}

	}

  }

	if ($CCNotFound)
	{
 		LogWrite "	*********************ERROR	ERROR	ERROR**********************"
 		$LogMessage = "Country code passed $CountryCode not matching with CC (First 2 letter) present in source file $SRCFile"
 		LogWrite $LogMessage
		$ReturnCode = 8
	}
		

  if($ReturnCode -gt 0)
  {
    $LogMessage = "Job failed with return code: $ReturnCode"
    LogWrite $LogMessage
  }
  else
  {
    $LogMessage = "Job completed successfully with return code: $ReturnCode"
    LogWrite $LogMessage
  }

#################################################################################
#This return code added temparary to avoid job failing due to access issue. Remove this line once access issue sorted
		$ReturnCode = 0
#################################################################################

Exit $ReturnCode