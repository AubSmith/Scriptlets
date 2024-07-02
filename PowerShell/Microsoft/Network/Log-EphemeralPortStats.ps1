<#
    .SYNOPSIS
    Runs in an infinite loop getting the TCP ephemeral port and listening port statistics for each local IP address and outputs the data to a text file log.
    .DESCRIPTION
    Runs in an infinite loop getting the TCP ephemeral port and listening port statistics for each local IP address and outputs the data to a text file log. The script writes the ephemeral port stats every 60 seconds by default. To get data from remote computers, this script requires PsExec.exe (SysInternals) to be in the same directory as this script. WARNING: Credentials passed into PSExec are sent over the network in clear text! Prevent this by logging in interactively with a domain account that has administrator rights on the target computers and not specifying credentials to this script. PsExec is a Sysinternals tool owned by Microsoft Corporation. PsExec can be downloaded for free at http://live.sysinternals.com/psexec.exe.
    .Parameter CollectionInterval
	This must be an integer in seconds. This is how often you want the script to update the ephemeral port stats and write to the console and to the log. If omitted, 60 seconds is used.
	.Parameter OutputFilePath
	This must be a file path to write to. This will append to an existing text file. If omitted, .\EphemeralPortStats.log is used.
    .EXAMPLE
    .\Log-EphemeralStats.ps1
    This will get TCP ephemeral port and listening port statistics for each local IP address of this computer and outputs the data to a the console and log every 60 seconds by default.
	.EXAMPLE
	.\Log-EphemeralStats.ps1 -CollectionInterval 10
	This will get TCP ephemeral port and listening port statistics for each local IP address of this computer and outputs the data to a the console and log (.\EphemeralPortStats.log is the default) every 10 seconds.
	.EXAMPLE
	.\Log-EphemeralStats.ps1 -CollectionInterval 10 -OutputFilePath '.\output.log'
	This will get TCP ephemeral port and listening port statistics for each local IP address of this computer and outputs the data to a the console and log (in this case .\output.log) every 10 seconds.	
    .Notes
    Name: Log-EphemeralStats.ps1
    Author: Clint Huffman (clinth@microsoft.com)
    LastEdit: December 3rd, 2011
	Version: 1.0
    Keywords: PowerShell, TCP, ephemeral, ports, listening
	.Link
	Download PsExec (Sysinternals owned by Microsoft corporation) http://live.sysinternals.com/psexec.exe
#>
param([string]$Computers="$env:computername",[string]$User='',[string]$Password='',[int]$CollectionInterval=5,[string]$OutputFilePath='.\EphemeralPortStats.log')

#// Argument processing
$global:Computers = $Computers
$global:User = $User
$global:Password = $Password
$global:CollectionInterval = $CollectionInterval
$global:OutputFilePath = $OutputFilePath

#// Remove all of the jobs that might be running previously to this session.
If (@(Get-Job).Count -gt 0)
{
    Remove-Job -Name * -Force
}

#// Stop any network traces already running
netsh trace stop

#// Start the network trace
netsh trace start capture=yes tracefile=$env:WINDIR\Tools\NetTrace_DO_NOT_COPY_YET.etl maxsize=1024 filemode=circular overwrite=yes persistent=yes

Function ProcessArguments
{    
	#// Processes the arguments passed into the script such as getting the appropriate credentials if specified.
    $global:aComputers = $global:Computers.Split(';')
    If ($global:aComputers -isnot [System.String[]])
    {
        $global:aComputers = @($global:Computers)
    }
    
    #// If credentials are passed into this script, then make them secure.
    If ($global:User -ne '')
    {        
        If ($global:Password -ne '')
        {
            $global:Password = ConvertTo-SecureString -AsPlainText -Force -String $global:Password
            $global:oCredential = New-Object System.Management.Automation.PsCredential($global:User,$global:Password)            
        }
        Else
        {
            $global:oCredential = Get-Credential -Credential $global:User
        }  
    }
}

Function Invoke-PsExec
{
	#// Executes PsExec to get data from remote computers.
	param([string]$Computer,[string]$Command)
	
	If ($global:User -ne '')
	{
		If ($global:Password -eq '')
		{
			$global:Password = $global:oCredential.GetNetworkCredential().Password
		}
		$sPsCmd = '.\psexec \\' + "$Computer" + ' /AcceptEula -u ' + "$global:User" + ' -p "' + "$global:Password" + '" -s ' + $Command + ' 2> $null'
		Write-Warning 'Credentials sent in clear text to the remote computer using PsExec! Prevent this by not providing credentials to this script and logging in with a domain account with admin privileges to the remote computer or by using network encryption such as IPSec.'
	}
	Else
	{
		$sPsCmd = ".\psexec \\$Computer /AcceptEula $Command"
	}
	Invoke-Expression -Command $sPsCmd
}

Function Get-TcpDynamicPortRange
{
	param($Computer="$env:computername")
	
	If ($Computer -eq $env:COMPUTERNAME)
	{
		$bIsLocal = $true	
	}
	Else
	{
		$bIsLocal = $false
	}
	
	If ($bIsLocal -eq $true)
	{
		$oOutput = Invoke-Expression -Command 'netsh int ipv4 show dynamicportrange tcp'
	}
	Else
	{
		#// Use PsExec		
		$sCmd = 'netsh int ipv4 show dynamicportrange tcp'
		$oOutput = Invoke-PsExec -Computer $Computer -Command $sCmd -User $global:User -Password $global:Password
	}
	
	$oDynamicPortRange = New-Object pscustomobject
	Add-Member -InputObject $oDynamicPortRange -MemberType NoteProperty -Name StartPort -Value 0
    Add-Member -InputObject $oDynamicPortRange -MemberType NoteProperty -Name EndPort -Value 0
	Add-Member -InputObject $oDynamicPortRange -MemberType NoteProperty -Name NumberOfPorts -Value 0
	
	ForEach ($sLine in $oOutput)
	{
		If ($($sLine.IndexOf('Start Port')) -ge 0)
		{
			$aLine = $sLine.Split(':')
			[System.Int32] $oDynamicPortRange.StartPort = $aLine[1]
		}
		
		If ($($sLine.IndexOf('Number of Ports')) -ge 0)
		{
			$aLine = $sLine.Split(':')
			[System.Int32] $oDynamicPortRange.NumberOfPorts = $aLine[1]
		}
	}
	$oDynamicPortRange.EndPort = ($($oDynamicPortRange.StartPort) + $($oDynamicPortRange.NumberOfPorts)) - 1
	$oDynamicPortRange
}

Function Get-ActiveTcpConnections
{
	param($Computer="$env:computername")
	
	If ($Computer -eq $env:COMPUTERNAME)
	{
		$bIsLocal = $true	
	}
	Else
	{
		$bIsLocal = $false
	}
	
	If ($bIsLocal -eq $true)
	{
		$oOutput = Invoke-Expression -Command 'netstat -ano -p tcp'
	}
	Else
	{
		#// Use PsExec		
		$sCmd = 'netstat -ano -p tcp'
		$oOutput = Invoke-PsExec -Computer $Computer -Command $sCmd -User $global:User -Password $global:Password
	}
	
	If ($oOutput -ne $null)
	{
	    $u = $oOutput.GetUpperBound(0)
	    $oOutput = $oOutput[4..$u]
		$aActiveConnections = @()
		ForEach ($sLine in $oOutput)
		{
			$iPropertyIndex = 0
			$aLine = $sLine.Split(' ')
			$oActiveConnection = New-Object System.Object
			For ($c = 0; $c -lt $aLine.Count;$c++)
			{
				If ($aLine[$c] -ne '')
				{
					switch ($iPropertyIndex)
					{
						0 {Add-Member -InputObject $oActiveConnection -MemberType NoteProperty -Name Proto -Value $($aLine[$c])}
						1 {
							$aIpPort = $aLine[$c].Split(':')
							Add-Member -InputObject $oActiveConnection -MemberType NoteProperty -Name LocalAddress -Value $($aIpPort[0])
							Add-Member -InputObject $oActiveConnection -MemberType NoteProperty -Name LocalPort -Value $([System.Int32] $aIpPort[1])
						  }
						2 {
							$aIpPort = $aLine[$c].Split(':')
							Add-Member -InputObject $oActiveConnection -MemberType NoteProperty -Name ForeignAddress -Value $($aIpPort[0])
							Add-Member -InputObject $oActiveConnection -MemberType NoteProperty -Name ForeignPort -Value $([System.Int32] $aIpPort[1])
						  }
						3 {Add-Member -InputObject $oActiveConnection -MemberType NoteProperty -Name State -Value $($aLine[$c])}
						4 {Add-Member -InputObject $oActiveConnection -MemberType NoteProperty -Name PID -Value $([System.Int32] $aLine[$c])}
					}
					$iPropertyIndex++
				}
			}
			$aActiveConnections += $oActiveConnection
		}
		$aActiveConnections
	}
}

$global:htDynamicPortRange = @{}

Function Get-EphemeralPortStats
{
	param($ArrayOfComputerNames)
	
	$aLocalAddressStats = @()
	
	ForEach ($Computer in $ArrayOfComputerNames)
	{	
		If ($($global:htDynamicPortRange.ContainsKey($Computer)) -eq $false)
		{
			$oDynamicPortRange = Get-TcpDynamicPortRange -Computer $Computer
			[System.Int32] $iDynamicStartPort = $oDynamicPortRange.StartPort
			[System.Int32] $iDynamicEndPort = $oDynamicPortRange.EndPort
			[System.Int32] $iDynamicNumberOfPorts = $oDynamicPortRange.NumberOfPorts
			[Void] $global:htDynamicPortRange.Add($Computer,$oDynamicPortRange)
		}
		Else
		{
			$oDynamicPortRange = $global:htDynamicPortRange[$Computer]
			[System.Int32] $iDynamicStartPort = $oDynamicPortRange.StartPort
			[System.Int32] $iDynamicEndPort = $oDynamicPortRange.EndPort
			[System.Int32] $iDynamicNumberOfPorts = $oDynamicPortRange.NumberOfPorts		
		}


		$oActiveConnections = Get-ActiveTcpConnections -Computer $Computer | Sort-Object LocalPort -Descending
		$aUniqueLocalAddresses = $oActiveConnections | Sort-Object -Property LocalAddress | Select LocalAddress | Get-Unique -AsString
		$aDynamicPortRangeConnections = $oActiveConnections | Where-Object -FilterScript {($_.LocalPort -ge $iDynamicStartPort) -and ($_.LocalPort -le $iDynamicEndPort)}

		ForEach ($oUniqueLocalAddress in $aUniqueLocalAddresses)
		{
			If ($($oUniqueLocalAddress.LocalAddress) -ne '0.0.0.0')
			{
				#// Ephemeral ports of each LocalAddress
				[string] $sUniqueLocalAddress = $oUniqueLocalAddress.LocalAddress
				$aIpEphemeralPortConnections = @($aDynamicPortRangeConnections | Where-Object -FilterScript {($_.LocalAddress -eq $sUniqueLocalAddress)} | Select LocalPort, PID | Sort-Object | Get-Unique -AsString)
				If ($aIpEphemeralPortConnections -ne $null)
				{	
					$oStats = New-Object System.Object
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'Computer' -Value $Computer
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'DateTime' -Value $(Get-Date)
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'LocalAddress' -Value $sUniqueLocalAddress
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'InUse' -Value $([System.Int32] $aIpEphemeralPortConnections.Count)
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'Max' -Value $([System.Int32] $oDynamicPortRange.NumberOfPorts)
					$iPercentage = ($([System.Int32] $aIpEphemeralPortConnections.Count) / $([System.Int32] $oDynamicPortRange.NumberOfPorts)) * 100
					$iPercentage = [Math]::Round($iPercentage,1)
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'Percent' -Value $iPercentage
				}
				Else
				{
					$oStats = New-Object System.Object
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'Computer' -Value $Computer
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'DateTime' -Value $(Get-Date)
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'LocalAddress' -Value $sUniqueLocalAddress
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'InUse' -Value 0
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'Max' -Value $([System.Int32] $oDynamicPortRange.NumberOfPorts)
					$iPercentage = 0
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'Percent' -Value $iPercentage		
				}
				#// Listening ports of each LocalAddress
				$aIpListeningPorts = $oActiveConnections | Where-Object -FilterScript {($_.State -eq 'LISTENING') -and (($_.LocalAddress -eq $sUniqueLocalAddress) -or ($_.LocalAddress -eq '0.0.0.0'))} | Select LocalPort | Sort-Object LocalPort | Get-Unique -AsString

				If ($aIpListeningPorts -ne $null)
				{	
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'Listening' -Value $([System.Int32] $aIpListeningPorts.Count)
				}
				Else
				{
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'Listening' -Value 0
				}
				
				#// Number of PIDs
				$aIpPids = $oActiveConnections | Where-Object -FilterScript {($_.LocalAddress -eq $sUniqueLocalAddress) -or ($_.LocalAddress -eq '0.0.0.0')} | Select PID | Sort-Object PID
                $aUniquePids = $aIpPids | Get-Unique -AsString
				If ($aUniquePids -ne $null)
				{	
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'NumOfPids' -Value $([System.Int32] $aUniquePids.Count)
				}
				Else
				{
					Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'NumOfPids' -Value 0
				}

                $aPidStats = @()
                ForEach ($iPid in $aUniquePids)
                {
                    $iPidCount = @($aIpPids | Where-Object -FilterScript {$_.PID -eq $iPid.PID}).Count
                    $oPidStats = New-Object System.Object
					Add-Member -InputObject $oPidStats -MemberType NoteProperty -Name 'PID' -Value $iPid.PID
                    Add-Member -InputObject $oPidStats -MemberType NoteProperty -Name 'Count' -Value $iPidCount
                    $aPidStats += $oPidStats
                }
                Add-Member -InputObject $oStats -MemberType NoteProperty -Name 'PidStats' -Value $aPidStats
                $aLocalAddressStats += $oStats
			}
		}
	}
	$aLocalAddressStats
}

ProcessArguments
$bNeverTrue = $false
do 
{
    $oPortStats = Get-EphemeralPortStats -ArrayOfComputerNames $global:aComputers

    $oPortStats | Select Computer, DateTime, LocalAddress, InUse, Max, Percent, Listening | Format-Table -AutoSize
    $oPortStats | Select Computer, DateTime, LocalAddress, InUse, Max, Percent, Listening | Format-Table -AutoSize >> $OutputFilePath

    $iCount = @($oPortStats | Where-Object {$_.Percent -ge 10}).Count
    If ($iCount -gt 0)
    {
        Tasklist /svc >> $OutputFilePath
        ForEach ($oItem in $oPortStats)
        {
            $oItem.LocalAddress >> $OutputFilePath
            $oItem.PidStats | Sort-Object Count -Descending | ft -AutoSize >> $OutputFilePath

            ForEach ($oPid in $oItem.PidStats)
            {
                If ($oPid.Count -ge 1000)
                {
                    gwmi -Query "SELECT * FROM Win32_Process WHERE Handle = $($oPid.PID)" | SELECT Name, ProcessId, HandleCount, Path | Format-List >> $OutputFilePath
                    gwmi -Query "ASSOCIATORS OF {Win32_Process.Handle=$($oPid.PID)} WHERE ResultClass = CIM_DataFile" | SELECT Caption, LastModified, Manufacturer, Version | Format-List >> $OutputFilePath
                }
            }
        }

        $sDateTime = (Get-Date).ToString('yyyyMMddHHmmss')
        $sNewNetTraceName = "$env:WINDIR\Tools\$($sDateTime)_NetTrace.etl"
        netsh trace stop
        Rename-Item -Path $env:WINDIR\Tools\NetTrace_DO_NOT_COPY_YET.etl -NewName $sNewNetTraceName

        netsh trace start capture=yes tracefile=$env:WINDIR\Tools\NetTrace_DO_NOT_COPY_YET.etl maxsize=1024 filemode=circular overwrite=yes persistent=yes
    }

	Write-Host "Sleeping for $global:CollectionInterval seconds..." -NoNewline
	Start-Sleep -Seconds $global:CollectionInterval
	Write-Host 'Done!'
} until ($bNeverTrue)
