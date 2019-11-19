<#
 .SYNOPSIS
     .
 .DESCRIPTION
     Creates application pool folder structure, IIS application pool and web application under one or all IIS websites except the default one. 
 .PARAMETER WebSiteName
     This is the name of an existing IIS site under which the new web application will be created.
     You can put "All" in that parameter so the application pool and the web application will be created under every an existing IIS site, except the default one
 .PARAMETER WebAppName
     Name of the web application you want to create; the name will also be used as the name for the application pool.  
 .PARAMETER managedRuntimeVersion
     Specifies a managedRuntimeVersion for the application pool.
 .PARAMETER managedPipelineMode
     Specifies a managedPipelineMode for the application pool. 
 .PARAMETER enable32BitAppOnWin64
     Specifies a enable32BitAppOnWin64 boolean value for the application pool. 
 .PARAMETER RootFSFolder
     Specifies a root folder where all the web sites reside. If omitted it will try to 
     use c:\webs as default root folder.
 .PARAMETER Help
     Displays the help
     
 .EXAMPLE
     PS .\CreateIISAppPools.ps1 -WebSiteName All -WebAppName webapp -managedRuntimeVersion v4.0 -managedPipelineMode 0 -enable32BitAppOnWin64 $true
     Creates the webapp web application and application pool under all but default IIS web sites
     
 .NOTES
     Author: Alex Chaika
     Date:   May 17, 2016    
 #>
 
 
 [CmdletBinding()]

<#
The CmdletBinding() keyword tells PowerShell that it should treat the script like a compiled C# cmdle. The param section establishes parameters that the script accepts. The script then determines whether each of those parameters is mandatory.
#>

 Param(
   [Parameter(Mandatory=$True)]
    [string]$WebSiteName,
   [Parameter(Mandatory=$True)]
    [string]$WebAppName,
   [Parameter(Mandatory=$False)]
    [string]$managedRuntimeVersion,
   [Parameter(Mandatory=$False)]
    [int]$managedPipelineMode,
   [Parameter(Mandatory=$False)]
    [bool]$enable32BitAppOnWin64,
   [Parameter(Mandatory=$False)]
    [string]$RootFSFolder
          
 )
 
 if (!($managedRuntimeVersion)) {
     $managedRuntimeVersion = ""
    }
 if (!($RootFSFolder)) {
     $RootFSFolder = "c:\webs\"
    } 

<#
Those “if” statements check if non-mandatory parameters $managedRuntimeVersion and $RootFSFolder were provided by the user. If not, it establishes the default values for them.
#>

 import-module WebAdministration
 
 function CreatePhysicalPath {
     Param([string] $fpath)
     
     if(Test-path $fpath) {
         Write-Host "The folder $fpath already exists" -ForegroundColor Yellow
         exit
         }
     else{
         New-Item -ItemType directory -Path $fpath -Force
        }
    }
 Function CreateAppPool {
         Param([string] $appPoolName)
 
         if(Test-Path ("IIS:\AppPools\" + $appPoolName)) {
             Write-Host "The App Pool $appPoolName already exists" -ForegroundColor Yellow
             exit
         }
 
         $appPool = New-WebAppPool -Name $appPoolName
     }
 
 Function SetProperties {
         Param([string] $WebAppName,
               [string] $managedRuntimeVersion,
               [int]$managedPipelineMode,
               [bool]$enable32BitAppOnWin64)
         Set-ItemProperty IIS:\AppPools\$WebAppName managedRuntimeVersion $managedRuntimeVersion
         if ($managedPipelineMode){
             Set-ItemProperty IIS:\AppPools\$WebAppName managedPipelineMode $managedPipelineMode
            }
         if ($enable32BitAppOnWin64){
              Set-ItemProperty IIS:\AppPools\$WebAppName enable32BitAppOnWin64 $enable32BitAppOnWin64
            }
     }
             
 Function CreateWebApp {
          Param([string] $WebSiteName,
                [string] $WebAppName,
                [string] $AppFolder)
          if (Test-Path ("IIS:\Sites\$WebSiteName\$WebAppName")){
              Write-Host "Web App $WebAppName already exists" -ForegroundColor Yellow
              return
             }
          else {
              New-WebApplication -Site $WebSiteName -name $WebAppName  -PhysicalPath $AppFolder -ApplicationPool $WebAppName
             }
          }
 
 if ($WebSiteName -ne "All"){
    if(!(Test-Path "IIS:\Sites\$WebSiteName")){
       Write-Host "The website $WebsiteName doesn't exist, create a Web Site first" -ForegroundColor Yellow
       exit
     }
    if(!(Test-Path $RootFSFolder)){
        Write-Host "The folder $RootFSFolder doesn't exist, create a folder structure first" -ForegroundColor Yellow
        exit
     }
    else {
        $AppFolder = $RootFSFolder + "\" + $WebSiteName + "\" + $WebAppName
        CreateAppPool $WebAppName
        CreatePhysicalPath $AppFolder
        SetProperties $WebAppName $managedRuntimeVersion $managedPipelineMode $enable32BitAppOnWin64
        CreateWebApp $WebSiteName $WebAppName $AppFolder   
     }
  
  }
 
 elseif ($WebSiteName -eq "All"){
     $i = 0
     get-Website | ? {$_.Name -ne "Default Web Site"} | % {
     $i++
     $AppFolder = $RootFSFolder + "\" + $_.Name + "\" + $WebAppName + $i
     $iWebAppName = $WebAppName + $i
     CreateAppPool $iWebAppName
     CreatePhysicalPath $AppFolder
     SetProperties $iWebAppName $managedRuntimeVersion $managedPipelineMode $enable32BitAppOnWin64
     CreateWebApp $_.Name $iWebAppName $AppFolder 
     }
   }