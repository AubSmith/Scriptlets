Here is the source code for the Count-Ports.ps1:

## Author: frank.taglianetti@microsoft.com
## Displays port counts per  IP address
## Parameters = none 
## Modified 12/6/2011 to include Windows Vista or later
## TCP Parameters documented in http://support.microsoft.com/kb/953230
function MaxNumOfTcpPorts  #helper function to retrive number of ports per address
{
param 
    (
        [parameter(Mandatory=$true)]
         $tcpParams
    )
    #  Returns the maximum number of ports per TCP address
    #  Check for Windows Vista and later
    $IsVistaOrLater = Get-WmiObject -Class Win32_OperatingSystem | %{($_.Version -match "6\.\d+")}
    if($isVistaOrLater)
    {
        # Use netsh to retrieve the number of ports and parse out the string of numbers after "Number of Ports : "
        $maxPorts = netsh int ip show dynamicport tcp |
            Select-String -Pattern "Number of Ports : (\d*)"|
            %{$_.matches[0].Groups[1].Value}
        # Convert string to integer
        $maxPorts = [int32]::Parse($maxPorts)
        #  modify the PSCustomObject to simulate the MaxUserPort value for printout
        Add-Member -InputObject $tcpParams -MemberType NoteProperty -Name MaxUserPort -Value $maxPorts 
    }
    else  # this is Windows XP or older
    {
        # check of emphermal ports modified in registry
        $maxPorts = $($tcpParams | Select-Object MaxUserPort).MaxUserPort
        if($maxPorts -eq $null)
        {
            $maxPorts = 5000 - 1kb    #Windows Default range is from 1025 to 5000 inclusive
            Add-Member -InputObject $tcpParams -MemberType NoteProperty -Name MaxUserPort -Value $maxPorts
        }
    }
    return $maxPorts
}
function New-Port  # helper function to track number of ports per IP address
{
    Param
    (
        [string] $IPAddress = [String]::EmptyString,
        [int32] $PortsWaiting = 0,
        [int32] $MaxUserPort = 3976
    )
    $newPort = New-Object PSObject
    Add-Member -InputObject $newPort -MemberType NoteProperty -Name IPAddress -Value $IPAddress
    Add-Member -InputObject $newPort -MemberType NoteProperty -Name PortsUsed -Value 1
    Add-Member -InputObject $newPort -MemberType ScriptProperty -Name PercentUsed -Value {$this.PortsUsed / $this.MaxUserPort}
    Add-Member -InputObject $newPort -MemberType NoteProperty -Name PortsWaiting -Value $portsWaiting
    Add-Member -InputObject $newPort -MemberType ScriptProperty -Name PercentWaiting -Value {$this.PortsWaiting / [Math]::Max(1,$this.PortsUsed)}
    Add-Member -InputObject $newPort -MemberType NoteProperty -Name MaxUserPort -Value $maxUserPort
    return $newPort
}
######################### Beginning of the main routine ##########################
# Store MaxUserPort for percentage used calculations
$tcpParams = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters
$maxPorts = MaxNumOfTcpPorts($tcpParams)   # call function to return max # ports as per OS version
$tcpTimedWaitDelay = $($tcpParams | Select-Object TcpTimedWaitDelay).TcpTimedWaitDelay
if($tcpTimedWaitDelay -eq $Null)           #Value wasn't configured in registry
{
    $tcpTimedWaitDelay = 240               #Default Value if registry value doesn't exist
    Add-Member -InputObject $tcpParams -MemberType NoteProperty -Name TcpTimedWaitDelay -Value $tcpTimedWaitDelay  #fake reg value for output
}
# display current date and time
Write-Host -Object $(Get-Date)
# Display the MaxUserPort and TcpTimedWaitDelay settings in the registry if available
$tcpParams | Format-List MaxUserPort,TcpTimedWaitDelay
# collection of IP Address and port counts
[System.Collections.HashTable] $ports = New-Object System.Collections.HashTable
[int32] $intWait = 0
netstat -an | 
Select-String "TCP\s+.+\:.+\s+(.+)\:(\d+)\s+(\w+)" | 
ForEach-Object {
    $key = $_.matches[0].Groups[1].value      # use the IP address as hash key
    $Status = $_.matches[0].Groups[3].value   # Last group contains port status
    if("TIME_WAIT" -like $Status)
    {
        $intWait = 1                          # incr count
    }
    else
    {
        $intWait = 0                          # don't incr count
    }
    if(-not $ports.ContainsKey($key))         #IP Address not yet counted
    {
        $port = New-Port -IPAddress $key -PortsWaiting $intWait -MaxUserPort $maxPorts    #intialize new tracking object
        $ports.Add($key,$port)                #Add the tracking object to hashtable
    }
    else                                      #otherwise a tracking object exists for this IP
    {
        $port = $ports[$key]                  #retrieve the tracking object
        $port.PortsUsed ++                    # increment the port count (PortsUsed)
        $port.PortsWaiting += $intWait        # increment PortsWaiting if status is TIME_WAIT
    }
}
 
 
# Format-Table -InputObject $ports.Values -auto
$ports.Values | 
    Sort-Object -Property PortsUsed, PortsWaiting -Descending  |
    Format-Table -Property IPAddress,PortsWaiting,
        @{Name='%Waiting';Expression ={"{0:P}" -f $_.PercentWaiting};Alignment="Right"},
        PortsUsed,
        @{Name='%Used';Expression ={"{0:P}" -f $_.PercentUsed}; Alignment="Right"} -Auto
Remove-Variable -Name "ports"