<# 
     
    .SYNOPSIS 
     
        GetIISVersion.ps1 is powershell script to retrieve the IIS version from multiple servers specified on a text file. 
     
     
    .DESCRIPTION 
     
        GetIISVersion.ps1 is powershell script to retrieve the IIS version from multiple servers specified on a text file. 
         
        This uses REG.EXE that is already present in most windows host machines. 
 
        You must have admin/rdp access to the computers; Doing so is the only way to ensure you have permission to query the registry 
            
     
    .PARAMETER serverlistTXT 
     
        input a file with .txt extension where you will feed the list of servers. 1 server per line, avoid spaces. 
         
     
    .EXAMPLE 
     
        .\GetIISVersion.ps1 -serverlistTXT .\servers.txt 
     
     
    .EXAMPLE 
     
        .\GetIISVersion.ps1 .\servers.txt 
     
     
    .NOTES            
     
        Author: Joana Marie Buna <JoanaMarie.Buna@outlook.com> 
     
        Requirements 
            PowerShell Version 3 or later 
         
        Script Version 
            1.0 
            Initial Creation | 10-13-2017 
 
#> 
 
param( 
[Parameter(Mandatory=$true,Position=0)] 
[string]$serverlistTXT) 
 
 
$machines = (Get-content "$serverlistTXT").Trim() 
$ErrorActionPreference = "SilentlyContinue" 
$datetime = Get-Date -Format "MMddyy-HHmmss" 
 
#Clear Job Cache 
Get-Job | Remove-Job -Force 
 
$jobscript = { 
 
Param($machine) 
     
    $pingstate = "" 
 
    $pingstate = Test-Connection $machine -Count 3 -Quiet 
 
    $IISVersionString = "" 
     
    $IISVersionString = ((reg query \\$machine\HKLM\SOFTWARE\Microsoft\InetStp\ | findstr VersionString).Replace(" ","")).Replace("VersionStringREG_SZ","") 
 
    if ($IISVersionString -eq ""){ 
 
        $IISVersionString = "Not Installed." 
     
    } 
 
    $results = [PSCustomObject]@{ 
     
        ServerName = $machine 
        IISVersion = $IISVersionString 
        Pingable = $pingstate 
 
    } 
 
    $results 
 
} 
 
 
Foreach($machine in $machines){ 
 
Start-Job -ScriptBlock $jobscript -ArgumentList $machine 
 
} 
 
$output = Get-Job | Wait-Job | Receive-Job  
 
$output | Export-Csv $PSScriptRoot\IISversionQuery_$datetime.csv -NoTypeInformation -Append 
 
Clear-Host 
 
$output