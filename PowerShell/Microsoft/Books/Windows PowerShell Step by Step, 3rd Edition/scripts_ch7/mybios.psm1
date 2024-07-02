function Get-MyBios
{
 <#
.Synopsis
   Gets bios information from local or remote computer
.DESCRIPTION
   This function gets bios information from local or remote computer
.Parameter computername
 The name of the remote computer
.EXAMPLE
   Get-MyBios
   Gets bios information from local computer
.EXAMPLE
   Get-MyBios -cn remoteComputer
   Gets bios information from remote computer named remotecomputer 
#>
#requires -version 3.0
    [CmdletBinding()]
    Param
    (
        # name of remote computer
        [Alias("cn")]
        [Parameter(ValueFromPipeline=$true,
                   Position=0,
                   ParametersetName="remote")]
        [string]
        $ComputerName)     
    Process
    {
     Switch ($PSCmdlet.ParameterSetName)
     {
      "remote" { Get-CimInstance -ClassName win32_bios -cn $ComputerName }
      DEFAULT { Get-CimInstance -ClassName Win32_BIOS }
     } #end switch
    } #end process
} #end function Get-MyBios

New-Alias -Name gmb -Value Get-MyBios
Export-ModuleMember -Function * -Alias *
