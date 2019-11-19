################################################################################################
# Verify-Autoruns.ps1
# 
# AUTHOR: Robin Granberg (robin.granberg@microsoft.com)
#
# THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED 
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR 
# FITNESS FOR A PARTICULAR PURPOSE.
#
# This sample is not supported under any Microsoft standard support program or service. 
# The script is provided AS IS without warranty of any kind. Microsoft further disclaims all
# implied warranties including, without limitation, any implied warranties of merchantability
# or of fitness for a particular purpose. The entire risk arising out of the use or performance
# of the sample and documentation remains with you. In no event shall Microsoft, its authors,
# or anyone else involved in the creation, production, or delivery of the script be liable for 
# any damages whatsoever (including, without limitation, damages for loss of business profits, 
# business interruption, loss of business information, or other pecuniary loss) arising out of 
# the use of or inability to use the sample or documentation, even if Microsoft has been advised 
# of the possibility of such damages.
################################################################################################
<#-------------------------------------------------------------------------------
<#
.Synopsis
   Analyze autoruns and verify with previuos boot.

   Requires version 13.51 and above of Autorunsc.exe
   Requires version 2.50 and above of SigCheck.exe

.DESCRIPTION
   To protect and keep track of new binaries running at start up this script analyses current autoruns with previuos to find new entries or modifcations of your machines autoruns.

.PARAMETER Analyze
 Generates a CSV file of the system autoruns in C:\AutrunsLogs by default.

.PARAMETER Prompt
 This switch will let use prompt the checks done on screen.

.PARAMETER LogPath
 This parameter let you define an option path to where to put and store results. Defaults to C:\AutorunsLogs

 .PARAMETER autorunscdir
 This parameter let you define an option path to where you store Autorunsc.exe and SigCheck. Defaults to C:\Sysinternals

.PARAMETER NotificationIcon
 Use it to get the notifcation icon in the task bar eventhough nothing changed. Normally the notifications icon is displayed only when new things detected.

 .PARAMETER SystemCheck
 This option let you check the entire systmes autoruns with Virus Total.
  
 .PARAMETER Offline
 Check all system autoruns with Virus Total but offline, creates an offline file

.EXAMPLE
      .\Verify-Autoruns.ps1 
      
      (Requires a analyze CSV file to be created before.)
      If there is a previous analyze filed saved of the latest boot a report will be created.
      Then a report of differences between the current boot and the previuos boot autoruns will be logged to the log directory.


.EXAMPLE
      .\Verify-Autoruns.ps1 -Analyze
      
      This command willl create a new file of all autoruns on the system using Autorunsc.exe
      Then a report of differences between the current boot and the previuos boot autoruns will be logged to the log directory.

.EXAMPLE
      .\Verify-Autoruns.ps1 -Analyze -Prompt

      This command willl create a new file of all autoruns on the system using Autorunsc.exe
      Then a report of differences between the current boot and the previuos boot autoruns will be logged to the log directory.
      The result will be prompted to the powershell prompt

.EXAMPLE
   .\Verify-Autoruns.ps1 -prompt

   This command willl create a report of differences between the current boot and the previuos boot autoruns.
   The result will be prompted to the powershell prompt

.EXAMPLE
   .\Verify-Autoruns.ps1 -SystemCheck

   This command will check the entire systmes autoruns with Virus Total and display it in a Window.

.EXAMPLE
   .\Verify-Autoruns.ps1 -SystemCheck -Offline

   This command will create an offline file to use with SigCheck to check with Virus Total.

.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>


    [CmdletBinding(DefaultParameterSetName='Analyze', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Create new autorunsc report
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='All')]
        [Alias("New")] 
        [switch]
        $Analyze = $false,
        # Prompt to screen option
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
                   ParameterSetName='All')]
        [Alias("Display")] 
        [switch]
        $Prompt = $false,
        # Custom log path
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false, 
                   Position=2,
                   ParameterSetName='All')]
        [Alias("LogDir")] 
        [string]
        $LogPath = "C:\AutorunsLogs",
        # Path to executables (Autorunsc.exe and SigCheck.exe)
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false, 
                   Position=3,
                   ParameterSetName='All')]
        [Alias("Dir")] 
        [string]
        $autorunscdir = "C:\Sysinternals",
        # Force Notification Icon
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false, 
                   Position=4,
                   ParameterSetName='All')]
        [Alias("Icon")] 
        [switch]
        $NotificationIcon,
        # Check all system autoruns with Virus Total
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false, 
                   Position=5,
                   ParameterSetName='VirusTotal')]
        [Alias("TotalCheck")] 
        [switch]
        $SystemCheck,
        # Check all system autoruns with Virus Total but offline, creates an offline file
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$false,
                   ValueFromPipelineByPropertyName=$false, 
                   ValueFromRemainingArguments=$false, 
                   Position=5,
                   ParameterSetName='VirusTotal')]
        [Alias("NoInternet")] 
        [switch]
        $Offline
    )

    Begin
    {
        Add-Type -Assembly PresentationFramework
        $strBootTime = get-cimInstance -ClassName Win32_OperatingSystem | select LastBootUptime
        $LastBoottime = get-date($strBootTime.LastBootUptime) -Format yyyyMMdd-HHmm
        $strAutorunscEXE = "$autorunscdir\autorunsc.exe"
        $strSigCheckEXE = "$autorunscdir\sigcheck.exe"
        $strPrevBootTimeEvent = Get-EventLog "System" | Where-Object {$_.EventID -eq 6009} | select -Property TimeGenerated -First 1 -Skip 1
        $objReportInfo = $null
        #Store the current date for the report
        $NowDate = get-date -Format yyyyMMdd-HHmm
        #Define the report file path
        $LogFile = $env:temp + "\AutorunsC_Log_$NowDate.txt"
        #Define the new additions CSV file path
        $NewAutorunsFile = "$LogPath\AutorunsC_New_$LastBoottime.csv"
        if(Test-Path($NewAutorunsFile))
        {
            Remove-Item $NewAutorunsFile -Force 
        }
        #Define the total additions overtime CSV file path
        $TotalAutorunsFile = "$LogPath\AutorunsC_Total.csv"
        
        #Save date to report
        "Log Date: $NowDate" | out-file $LogFile ascii
        #TimeSpan for searching for CSV , withi allowing diff in time between boot and Event Id 6009 generated
        $intTimeSpan = -15
        $pswindow = $host.ui.rawui
        $newsize = $pswindow.buffersize
        $newsize.height = 3000
        $newsize.Width = 350
        $pswindow.buffersize = $newsize 
                     
    }
    Process
    {

Function CheckSysinternalsEULA
{

    $strSigCheckEXE = "C:\sysinternals\sigcheck.exe"
    $strAutorunscEXE = "C:\sysinternals\autorunsc.exe"

    #Check if the reg key for Sysinternals Exist
    #if(Get-ChildItem -Path "HKCU:\SOFTWARE" -Recurse -Depth 0 | where PSChildName -eq "Sysinternals")
    if(Get-Item -Path "HKCU:\SOFTWARE\Sysinternals" -ErrorAction SilentlyContinue)
    {
        #Check if the reg key for SigCheck Exist
        if(Get-ChildItem -Path "HKCU:\SOFTWARE\Sysinternals" -Recurse | ForEach-Object{Get-ItemProperty -Path $_.PSPath} | where PSChildName -eq SigCheck)
        {

            #Check if the EulaAccepted Property is set
            $SigCheckEULA = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Sysinternals\SigCheck").EulaAccepted
            If(($SigCheckEULA -eq 0) -or ($SigCheckEULA -eq $null) )
            {
                #Prompt SigCheck EULA & Virust Total Terms
                Write-Output "Must accept Autoruns EULA"
                $prog="cmd.exe"
                $params=@("/c";$strSigCheckEXE;"-v";"sigcheck")
                Start-Process "cmd" -ArgumentList $params -Wait
            }
            #Check if the VirusTotalTermsAccepted Property is set
            $SigCheckVTTerms = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Sysinternals\SigCheck\VirusTotal").VirusTotalTermsAccepted
            If(($SigCheckVTTerms -eq 0) -or ($SigCheckVTTerms -eq $null) )
            {
                #Prompt SigCheck Virust Total Terms
                Write-Output "Must accept Virust Total Terms"
                $prog="cmd.exe"
                $params=@("/c";$strSigCheckEXE;"-v";"sigcheck")
                Start-Process "cmd" -ArgumentList $params -Wait

            }
        }
        else
        {
            #Prompt SigCheck Virust Total Terms
            Write-Output "Must accept Virust Total Terms"
            $prog="cmd.exe"
            $params=@("/c";$strSigCheckEXE;"-v";"sigcheck")
            Start-Process "cmd" -ArgumentList $params -Wait
        }
        #Check if the reg key for Autoruns Exist
        if(Get-ChildItem -Path "HKCU:\SOFTWARE\Sysinternals" -Recurse | ForEach-Object{Get-ItemProperty -Path $_.PSPath} | where PSChildName -eq Autoruns)
        {
            #Check if the EulaAccepted Property is set
            $AutorRunsEULA = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Sysinternals\Autoruns").EulaAccepted    
            If(($AutorRunsEULA -eq 0) -or ($AutorRunsEULA -eq $null) )
            {
            #Prompt Autoruns EUAL
            Write-Output "Must accept Autoruns EULA"
            $prog="cmd.exe"
            $params=@("/c";$strAutorunscEXE;"-a";"b")
            Start-Process "cmd" -ArgumentList $params -Wait
            }
        }
        else
        {
            #Prompt Autoruns EUAL
            Write-Output "Must accept Autoruns EULA"
            $prog="cmd.exe"
            $params=@("/c";$strAutorunscEXE;"-a";"b")
            Start-Process "cmd" -ArgumentList $params -Wait
        }

    }
    else
    {
            #Prompt SigCheck Virust Total Term
            Write-Output "Must accept Virust Total Terms"
            $prog="cmd.exe"
            $params=@("/c";$strSigCheckEXE;"-v";"sigcheck")
            Start-Process "cmd" -ArgumentList $params -Wait

            #Prompt Autoruns EUAL
            Write-Output "Must accept Autoruns EULA"
            $prog="cmd.exe"
            $params=@("/c";$strAutorunscEXE;"-a";"b")
            Start-Process "cmd" -ArgumentList $params -Wait
    }
}
#Get Gurrent User SID with Whomai
$rr = whoami /user /fo csv 
$rr  | out-file  ($env:temp+"\file.txt")
$CurrentUserSid = (import-csv ($env:temp+"\file.txt"))[0].sid

# If the current user is System skip EUAL check
if($CurrentUserSid -ne "S-1-5-18")
{
    #Call EULA Check
    CheckSysinternalsEULA
}

Function BalloonTip
{
param( 
[string]$BalloonTipIcon,
[string]$BalloonTipTitle,
[string]$global:BalloonHashTipText)


    # Create the object and customize the message
    $global:objHashNotifyIcon = New-Object System.Windows.Forms.NotifyIcon
    $global:objHashNotifyIcon.Icon = [System.Drawing.SystemIcons]::Information
    $global:objHashNotifyIcon.BalloonTipIcon =  [System.Windows.Forms.ToolTipIcon]::$BalloonTipIcon
    $global:objHashNotifyIcon.BalloonTipTitle = $BalloonTipTitle
    $global:objHashNotifyIcon.BalloonTipText = $global:BalloonHashTipText

    # This will show or hide the icon in the system tray
    $global:objHashNotifyIcon.Visible = $true

    # This is the show the notification
    $global:objHashNotifyIcon.ShowBalloonTip(5000)
    $global:objHashNotifyIcon.Dispose()
}

function RunNotificationIcon
{
        param( 
        [string]$NotifyIcon,
        [string]$BalloonTipIcon,
        [string]$global:NotifyIconText,
        [string]$global:BalloonTipTitle,
        [string]$global:BalloonTipText,
        [string]$global:MsgBoxText,
        [string]$global:ReportName,
        [string]$global:ReportPath,
        [boolean]$global:bolNewSigned,
        [string]$global:csvNewFiles,
        [string]$global:Tag,
        $global:objSummary,
        [string]$global:strExeSigCheck,
        [boolean]$global:bolNonMS,
        [boolean]$global:bolNewHash,
        [boolean]$global:bolForced,
        [string]$global:strLastBootCSV
        )

#$newRunspaceNotification =[runspacefactory]::CreateRunspace()
#$newRunspaceNotification.ApartmentState = "STA"
#$newRunspaceNotification.ThreadOptions = "ReuseThread"          
#$newRunspaceNotification.Open()
#$newRunspaceNotification.SessionStateProxy.SetVariable("NotifyIcon",$NotifyIcon)    
#$newRunspaceNotification.SessionStateProxy.SetVariable("BalloonTipIcon",$BalloonTipIcon)
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:NotifyIconText",$global:NotifyIconText)
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:BalloonTipTitle",$global:BalloonTipTitle) 
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:BalloonTipText",$global:BalloonTipText) 
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:MsgBoxText",$global:MsgBoxText) 
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:ReportName",$global:ReportName)  
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:ReportPath",$global:ReportPath)  
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:bolNewSigned",$global:bolNewSigned)  
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:csvNewFiles",$global:csvNewFiles)  
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:Tag",$global:Tag)  
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:objSummary",$global:objSummary)  
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:strExeSigCheck",$global:strExeSigCheck)  
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:bolNonMS",$global:bolNonMS) 
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:bolNewHash",$global:bolNewHash) 
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:bolForced",$global:bolForced) 
#$newRunspaceNotification.SessionStateProxy.SetVariable("global:strLastBootCSV",$global:strLastBootCSV) 
#$psCmdBalloonTip = [PowerShell]::Create().AddScript({   



function SummaryBox
{
    param
    (
        [Parameter(  
             Mandatory = $false 
          )]  $objSummary 
    )
[xml]$SummaryXAML =@"
<Window x:Class="Verify.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" Title="Verify Autoruns Summary" WindowStartupLocation = "CenterScreen"
        Width = "500" Height = "350" ShowInTaskbar = "False" ResizeMode="NoResize" WindowStyle="ToolWindow"  Background="{DynamicResource {x:Static SystemColors.ControlBrushKey}}">
    <Grid>
        <StackPanel Orientation="Vertical" HorizontalAlignment="Center">
            <Label x:Name="lblSummary" Content="Summary" Width="200" Margin="05,0,00,00" HorizontalAlignment="Left" />
            <Grid HorizontalAlignment="Center">
                <DataGrid Name="dg_Log" Height="220" Margin="2,2,2,2" Width="450" ScrollViewer.HorizontalScrollBarVisibility="Hidden"  HorizontalAlignment="Center" >
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Item" Binding="{Binding Item}" Width="300"  IsReadOnly="True" FontWeight="Bold"/>
                        <DataGridTextColumn Header="Value" Binding="{Binding Value}" Width="150" IsReadOnly="True" />
                    </DataGrid.Columns>
                </DataGrid>
            </Grid>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="00,10,00,00">
                <Button x:Name="btnClose" Content="Close" Margin="10,00,00,00" Width="50" Height="20"/>
            </StackPanel>
        </StackPanel>

    </Grid>
</Window>
"@

$SummaryXAML.Window.RemoveAttribute("x:Class") 

$reader=(New-Object System.Xml.XmlNodeReader $SummaryXAML)
$VerifyAutoSummaryGui=[Windows.Markup.XamlReader]::Load( $reader )
$btnClose = $VerifyAutoSummaryGui.FindName("btnClose")
$dg_Log = $VerifyAutoSummaryGui.FindName("dg_Log")

$objImage = New-Object psObject | `
Add-Member NoteProperty "Item" "Last Boot" -PassThru |`
Add-Member NoteProperty "Value" $objSummary."Last Boot" -PassThru 
$dg_Log.AddChild($objImage)

$objImage = New-Object psObject | `
Add-Member NoteProperty "Item" "Previous Boot" -PassThru |`
Add-Member NoteProperty "Value" $objSummary."Previous Boot" -PassThru 
$dg_Log.AddChild($objImage)

$objImage = New-Object psObject | `
Add-Member NoteProperty "Item" "Current Autorun entries" -PassThru |`
Add-Member NoteProperty "Value" $objSummary."Current Autorun entries" -PassThru 
$dg_Log.AddChild($objImage)

$objImage = New-Object psObject | `
Add-Member NoteProperty "Item" "Previous Boot Autorun entries" -PassThru |`
Add-Member NoteProperty "Value" $objSummary."Previous Boot Autorun entries" -PassThru 
$dg_Log.AddChild($objImage)

$objImage = New-Object psObject | `
Add-Member NoteProperty "Item" "Number of new entries (Microsoft)" -PassThru |`
Add-Member NoteProperty "Value" $objSummary."Number of new entries (Microsoft)" -PassThru 
$dg_Log.AddChild($objImage)

$objImage = New-Object psObject | `
Add-Member NoteProperty "Item" "Number of new unsigned entries (Microsoft)" -PassThru |`
Add-Member NoteProperty "Value" $objSummary."Number of new unsigned entries (Microsoft)" -PassThru 
$dg_Log.AddChild($objImage)

$objImage = New-Object psObject | `
Add-Member NoteProperty "Item" "Number of new entries (Non-Microsoft)" -PassThru |`
Add-Member NoteProperty "Value" $objSummary."Number of new entries (Non-Microsoft)" -PassThru 
$dg_Log.AddChild($objImage)

$objImage = New-Object psObject | `
Add-Member NoteProperty "Item" "Number of new unsigned entries (Non-Microsoft)" -PassThru |`
Add-Member NoteProperty "Value" $objSummary."Number of new unsigned entries (Non-Microsoft)" -PassThru 
$dg_Log.AddChild($objImage)

$objImage = New-Object psObject | `
Add-Member NoteProperty "Item" "Entries with new hash" -PassThru |`
Add-Member NoteProperty "Value" $objSummary."Entries with new hash" -PassThru 
$dg_Log.AddChild($objImage)

$objImage = New-Object psObject | `
Add-Member NoteProperty "Item" "Number of deleted entries" -PassThru |`
Add-Member NoteProperty "Value" $objSummary."Number of deleted entries" -PassThru 
$dg_Log.AddChild($objImage)

$btnClose.add_Click(
{
$VerifyAutoSummaryGui.Close()
})

[void]$VerifyAutoSummaryGui.ShowDialog()
}


function MainWindow
{
    param
    (
        [Parameter(  
             Mandatory = $false 
          )][String[]]  $strMessage ,

       [Parameter(  
             Mandatory = $false
         )][String[]]$csvAutoRuns,
       [Parameter(  
             Mandatory = $false
         )][boolean[]]$bolSigned,
       [Parameter(  
             Mandatory = $false
         )][boolean[]]$bolNonMS,
       [Parameter(  
             Mandatory = $false
         )][boolean[]]$bolNewHash,
       [Parameter(  
             Mandatory = $false
         )][string[]]$strExeSigCheck,
       [Parameter(  
             Mandatory = $false
         )][boolean[]]$bolForced,
       [Parameter(  
             Mandatory = $false
         )][string[]]$strLastBootCSV
         

         
    )
[xml]$MainWindowsXAML =@"
<Window x:Class="Verify.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" Title="Verify Autoruns Alert" WindowStartupLocation = "CenterScreen"
        Width = "700" Height = "550" ShowInTaskbar = "False" ResizeMode="NoResize" WindowStyle="ToolWindow"  Background="{DynamicResource {x:Static SystemColors.ControlBrushKey}}">
    <Grid>

        <StackPanel Orientation="Vertical" HorizontalAlignment="Left">
            <Image x:Name="ImgBanner" Width="700"  Height="80" Stretch="UniformToFill"  />
            <Label x:Name="lblSecNotificationText" Content="Verify Autoruns has detected new files.Click 'Log' to view the full report. To check the new files against Virus Total click 'Check Virus Total'." Width="550" Margin="05,05,00,00" HorizontalAlignment="Left"/>
            <Label x:Name="lblSecNotificationFile" Content="file1" Width="600" Margin="05,0,00,00" HorizontalAlignment="Left" />
            <Grid>
                <DataGrid Name="dg_Log" Margin="2,2,2,2" Width="655" ScrollViewer.HorizontalScrollBarVisibility="Auto" Height="250"  >
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Type" Binding="{Binding Type}" Width="110"  IsReadOnly="True"/>                        
                        <DataGridTextColumn Header="File" Binding="{Binding File}" Width="120"  IsReadOnly="True"/>
                        <DataGridTextColumn Header="Date" Binding="{Binding Date}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn Header="Signer" Binding="{Binding Signer}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn Header="Company" Binding="{Binding Company}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn Header="Version" Binding="{Binding Version}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn  Header="Description" Binding="{Binding Description}" Width="120" IsReadOnly="True" />
                    </DataGrid.Columns>
                </DataGrid>
            </Grid>
               
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                    <Button x:Name="btnSummary" Content="Summmary" Margin="10,00,00,00" Width="70" Height="20"/>
                    <Button x:Name="btnLog" Content="Log" Margin="10,00,00,00" Width="50" Height="20"/>
                    <Button x:Name="btnVTCheck" Content="Check New Files With Virus Total" Margin="10,00,00,00" Width="185" Height="20"/>
                    <Button x:Name="btnVTTotalCheck" Content="Check All System Autoruns With Virus Total" Margin="10,00,00,00" Width="240" Height="20"/>
                    <Button x:Name="btnClose" Content="Close" Margin="10,00,00,00" Width="50" Height="20"/>
                </StackPanel>
        </StackPanel>

    </Grid>
</Window>
"@
$MainWindowsXAML.Window.RemoveAttribute("x:Class") 

$reader=(New-Object System.Xml.XmlNodeReader $MainWindowsXAML)
$MainWindowsGui=[Windows.Markup.XamlReader]::Load( $reader )
$btnLog = $MainWindowsGui.FindName("btnLog")
$btnClose = $MainWindowsGui.FindName("btnClose")
$btnVTCheck = $MainWindowsGui.FindName("btnVTCheck")
$btnVTTotalCheck = $MainWindowsGui.FindName("btnVTTotalCheck")
$btnSummary = $MainWindowsGui.FindName("btnSummary")
$ImgBanner = $MainWindowsGui.FindName("ImgBanner")
$lblSecNotificationText = $MainWindowsGui.FindName("lblSecNotificationText")
$lblSecNotificationFile = $MainWindowsGui.FindName("lblSecNotificationFile")
$dg_Log = $MainWindowsGui.FindName("dg_Log")

$lblSecNotificationText.Content = "$strMessage. `nClick 'Log' to view the full report. `nTo check the new files against Virus Total click 'Check Virus Total'."

$lblSecNotificationFile.Content = "Log file: $global:ReportPath"



$btnSummary.add_Click(
{
SummaryBox $global:objSummary 
})

$btnVTTotalCheck.add_Click(
{
$MsgBox = [System.Windows.Forms.MessageBox]::Show("This action will try to connect to internet!`nConnection to Virus Total will reached.`n`nThis might take a while if many entries will be checked.`n`nDo you want to proceed?`n`nTo create an offline file to run on an internet connected system, click No",”Verify Autoruns”,3,"Warning")
Switch ($MsgBox)
{
"YES"
{
$VTCheckInputCSV = $env:temp + "\VTInput.csv"
if(Test-Path($VTCheckInputCSV))
{
Remove-Item $VTCheckInputCSV -Force 
}
#Build input file for SigCheck
$arrVTCheckUniques = New-Object System.Collections.ArrayList
$arrVTCheck = New-Object System.Collections.ArrayList
$arrImportFilesToCheck = import-csv $strLastBootCSV
#If the file got a hash it exist on the disk otherwise sihcheck can't check it
$arrFilesToCheck = $arrImportFilesToCheck | where "SHA-256" -gt "" | select -Unique "Image Path"
Foreach($UniqObj in $arrFilesToCheck)
{

    [void]$arrVTCheckUniques.add($($arrImportFilesToCheck | where "Image Path" -eq $UniqObj.'Image Path' | select -First 1))

}


Foreach ($image in $arrVTCheckUniques)
{
    # Create object to store the new format that will be input to sigchek
    $objCheckEntry = New-Object psObject | `
    Add-Member NoteProperty "Path" $image."Image Path" -PassThru 
    #Check if the Image is signed or not
    $strSigner = $image.Signer
    if($strSigner.Length -gt 11)
    {
        #Convert the strings in new columns that sigcheck use
        if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Signed"  
        }
        else
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
        }
    }
    else
    {
        Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
    }
    Add-Member NoteProperty -InputObject $objCheckEntry "Date" ""  
    if($strSigner.Length -gt 11)
    {
        #Convert the strings in new columns that sigcheck use
        if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Verified) ","")  
        }
        else
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Not verified) ","")  
        }
    }
    else
    {
        Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" ""  
    }
    Add-Member NoteProperty -InputObject $objCheckEntry "Company" $image.Company 
    Add-Member NoteProperty -InputObject $objCheckEntry "Description" $image.Description  
    Add-Member NoteProperty -InputObject $objCheckEntry "Product" $image.Description 
    Add-Member NoteProperty -InputObject $objCheckEntry "Product Version" $image.Version 
    Add-Member NoteProperty -InputObject $objCheckEntry "File Version" $image.Version 
    Add-Member NoteProperty -InputObject $objCheckEntry "Machine Type" ""  
    Add-Member NoteProperty -InputObject $objCheckEntry "MD5" $image."MD5"  
    Add-Member NoteProperty -InputObject $objCheckEntry "SHA1" $image."SHA-1"  
    Add-Member NoteProperty -InputObject $objCheckEntry "PESHA1" $image."PESHA-1"  
    Add-Member NoteProperty -InputObject $objCheckEntry "PESHA256" $image."PESHA-256"  
    Add-Member NoteProperty -InputObject $objCheckEntry "SHA256" $image."SHA-256"  
    Add-Member NoteProperty -InputObject $objCheckEntry "IMP" $image."IMP"  
    [void]$arrVTCheck.Add($objCheckEntry)
}

# Create a CSV file that SigCheck can use
$arrVTCheck | Export-Csv -Path $VTCheckInputCSV -NoTypeInformation -Force
$file = (Get-Content $VTCheckInputCSV )
$file[0] = $file[0].Replace("$([char]34)","")
$file | Set-Content $VTCheckInputCSV -Force

#Define an out file from SigCheck
$strSigCheckWithVTResult = $env:temp + "\1VTCheck.csv"
if(Test-Path($strSigCheckWithVTResult))
{
Remove-Item $strSigCheckWithVTResult -Force 
}

$CMD =  "cmd"

$arg1 =  "/c"

$arg2 =  $strExeSigCheck

$arg3 =  "/accepteula"

$arg4 =  "-o"

$arg5 =  "-v"

$arg6 =  $VTCheckInputCSV

$arg7 =  ">"

$arg8 = $strSigCheckWithVTResult

#Execute Sigcheck and save to CSV file
& $CMD $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8

[xml]$VTXAML =@"
<Window x:Class="Verify.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" Title="Verify Autoruns - Virus Total Check" WindowStartupLocation = "CenterScreen"
        Width = "850" Height = "380" ShowInTaskbar = "False" ResizeMode="NoResize" WindowStyle="ToolWindow"  Background="{DynamicResource {x:Static SystemColors.ControlBrushKey}}">
    <Grid>
        <StackPanel Orientation="Vertical" HorizontalAlignment="Center">
            <Label x:Name="lblSummary" Content="Virust Total Check Result" Width="200" Margin="05,0,00,00" HorizontalAlignment="Left" />
            <Grid>
                <DataGrid Name="dg_Log" Margin="2,2,2,2" Width="800" ScrollViewer.HorizontalScrollBarVisibility="Auto" Height="260"  >
                    <DataGrid.Columns>
                        <DataGridTextColumn x:Name="colFile" Header="File" Binding="{Binding Path}" Width="120"  IsReadOnly="True"/>
                        <DataGridTextColumn x:Name="colSigner" Header="Signer" Binding="{Binding Publisher}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn x:Name="colCompany" Header="Company" Binding="{Binding Company}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn x:Name="colVersion" Header="Version" Binding="{Binding 'File Version'}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn x:Name="colVTDetection" Header="VT Detection" Binding="{Binding 'VT Detection'}" Width="120" IsReadOnly="True" SortDirection="Descending" />
                        <DataGridTextColumn x:Name="colVTLink" Header="VT Link" Binding="{Binding 'VT Link'}" Width="120" IsReadOnly="True" />
                    </DataGrid.Columns>
                </DataGrid>
            </Grid>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="00,10,00,00">
                <Button x:Name="btnClose" Content="Close" Margin="10,00,00,00" Width="50" Height="20"/>
            </StackPanel>
        </StackPanel>

    </Grid>
</Window>

"@

$VTXAML.Window.RemoveAttribute("x:Class") 

$reader=(New-Object System.Xml.XmlNodeReader $VTXAML)
$VerifyVTGui=[Windows.Markup.XamlReader]::Load( $reader )
$btnClose = $VerifyVTGui.FindName("btnClose")
$dg_Log = $VerifyVTGui.FindName("dg_Log")
$colVTDetection = $VerifyVTGui.FindName("colVTDetection")

if(Test-Path($strSigCheckWithVTResult))
{
$sigs = import-csv $strSigCheckWithVTResult

Foreach ($re in $sigs)
{
    
    [void]$dg_Log.AddChild($re)
}
 
}



$btnClose.add_Click(
{
$VerifyVTGui.Close()
})

[void]$VerifyVTGui.ShowDialog()

$VerifyVTGui.Window.Activate()
}
"NO"
{
$VTCheckInputCSV = $LogPath + "\VTInput.csv"
if(Test-Path($VTCheckInputCSV))
{
Remove-Item $VTCheckInputCSV -Force 
}
#Build input file for SigCheck
$arrVTCheckUniques = New-Object System.Collections.ArrayList
$arrVTCheck = New-Object System.Collections.ArrayList
$arrImportFilesToCheck = import-csv $strLastBootCSV
#If the file got a hash it exist on the disk otherwise sihcheck can't check it
$arrFilesToCheck = $arrImportFilesToCheck | where "SHA-256" -gt "" | select -Unique "Image Path"
Foreach($UniqObj in $arrFilesToCheck)
{

    [void]$arrVTCheckUniques.add($($arrImportFilesToCheck | where "Image Path" -eq $UniqObj.'Image Path' | select -First 1))

}


Foreach ($image in $arrVTCheckUniques)
{
    # Create object to store the new format that will be input to sigchek
    $objCheckEntry = New-Object psObject | `
    Add-Member NoteProperty "Path" $image."Image Path" -PassThru 
    #Check if the Image is signed or not
    $strSigner = $image.Signer
    if($strSigner.Length -gt 11)
    {
        #Convert the strings in new columns that sigcheck use
        if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Signed"  
        }
        else
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
        }
    }
    else
    {
        Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
    }
    Add-Member NoteProperty -InputObject $objCheckEntry "Date" ""  
    if($strSigner.Length -gt 11)
    {
        #Convert the strings in new columns that sigcheck use
        if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Verified) ","")  
        }
        else
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Not verified) ","")  
        }
    }
    else
    {
        Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" ""  
    }
    Add-Member NoteProperty -InputObject $objCheckEntry "Company" $image.Company 
    Add-Member NoteProperty -InputObject $objCheckEntry "Description" $image.Description  
    Add-Member NoteProperty -InputObject $objCheckEntry "Product" $image.Description 
    Add-Member NoteProperty -InputObject $objCheckEntry "Product Version" $image.Version 
    Add-Member NoteProperty -InputObject $objCheckEntry "File Version" $image.Version 
    Add-Member NoteProperty -InputObject $objCheckEntry "Machine Type" ""  
    Add-Member NoteProperty -InputObject $objCheckEntry "MD5" $image."MD5"  
    Add-Member NoteProperty -InputObject $objCheckEntry "SHA1" $image."SHA-1"  
    Add-Member NoteProperty -InputObject $objCheckEntry "PESHA1" $image."PESHA-1"  
    Add-Member NoteProperty -InputObject $objCheckEntry "PESHA256" $image."PESHA-256"  
    Add-Member NoteProperty -InputObject $objCheckEntry "SHA256" $image."SHA-256"  
    Add-Member NoteProperty -InputObject $objCheckEntry "IMP" $image."IMP"  
    [void]$arrVTCheck.Add($objCheckEntry)
}

# Create a CSV file that SigCheck can use
$arrVTCheck | Export-Csv -Path $VTCheckInputCSV -NoTypeInformation -Force
$file = (Get-Content $VTCheckInputCSV )
$file[0] = $file[0].Replace("$([char]34)","")
$file | Set-Content $VTCheckInputCSV -Force
$MsgBox = [System.Windows.Forms.MessageBox]::Show("File saved: $VTCheckInputCSV`n`nRun the following command on a internet connected system:`n`nSigcheck.exe -o -v VTInput.csv",”Verify Autoruns”,0,"Info")
}
Default
{}
}

})

$btnVTCheck.add_Click(
{

$MsgBox = [System.Windows.Forms.MessageBox]::Show("This action will try to connect to internet!`nConnection to Virus Total will reached.`n`nThis might take a while if many entries will be checked.`n`nDo you want to proceed?`n`nTo create an offline file to run on an internet connected system, click No",”Verify Autoruns”,3,"Warning")
Switch ($MsgBox)
{
"YES"
{
$VTCheckInputCSV = $env:temp + "\VTInput.csv"
if(Test-Path($VTCheckInputCSV))
{
Remove-Item $VTCheckInputCSV -Force 
}
#Test if SigCheck.exe exist
if(Test-Path $strExeSigCheck)
{
# Verify that it is at least version 2.50 and above of autorunsc.exe
if((gci $strExeSigCheck).VersionInfo.FileVersion -ge "2.50")
{
#¤Build input file for SigCheck
$arrVTCheck = New-Object System.Collections.ArrayList
$arrFilesToCheck = Import-Csv $csvAutoRuns
#If the file got a hash it exist on the disk otherwise sihcheck can't check it
$arrFilesToCheck = $arrFilesToCheck | where "SHA-256" -gt ""
Foreach ($image in $arrFilesToCheck)
{
    # Create object to store the new format that will be input to sigchek
    $objCheckEntry = New-Object psObject | `
    Add-Member NoteProperty "Path" $image."Image Path" -PassThru 
    #Check if the Image is signed or not
    $strSigner = $image.Signer
    if($strSigner.Length -gt 11)
    {
        #Convert the strings in new columns that sigcheck use
        if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Signed"  
        }
        else
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
        }
    }
    else
    {
        Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
    }
    Add-Member NoteProperty -InputObject $objCheckEntry "Date" ""  
    if($strSigner.Length -gt 11)
    {
        #Convert the strings in new columns that sigcheck use
        if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Verified) ","")  
        }
        else
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Not verified) ","")  
        }
    }
    else
    {
        Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" ""  
    }
    Add-Member NoteProperty -InputObject $objCheckEntry "Company" $image.Company 
    Add-Member NoteProperty -InputObject $objCheckEntry "Description" $image.Description  
    Add-Member NoteProperty -InputObject $objCheckEntry "Product" $image.Description 
    Add-Member NoteProperty -InputObject $objCheckEntry "Product Version" $image.Version 
    Add-Member NoteProperty -InputObject $objCheckEntry "File Version" $image.Version 
    Add-Member NoteProperty -InputObject $objCheckEntry "Machine Type" ""  
    Add-Member NoteProperty -InputObject $objCheckEntry "MD5" $image."MD5"  
    Add-Member NoteProperty -InputObject $objCheckEntry "SHA1" $image."SHA-1"  
    Add-Member NoteProperty -InputObject $objCheckEntry "PESHA1" $image."PESHA-1"  
    Add-Member NoteProperty -InputObject $objCheckEntry "PESHA256" $image."PESHA-256"  
    Add-Member NoteProperty -InputObject $objCheckEntry "SHA256" $image."SHA-256"  
    Add-Member NoteProperty -InputObject $objCheckEntry "IMP" $image."IMP"  
    [void]$arrVTCheck.Add($objCheckEntry)
}

# Create a CSV file that SigCheck can use
$arrVTCheck | Export-Csv -Path $VTCheckInputCSV -NoTypeInformation -Force
$file = (Get-Content $VTCheckInputCSV )
$file[0] = $file[0].Replace("$([char]34)","")
$file | Set-Content $VTCheckInputCSV -Force

#Define an out file from SigCheck
$strSigCheckWithVTResult = $env:temp + "\1VTCheck.csv"
if(Test-Path($strSigCheckWithVTResult))
{
Remove-Item $strSigCheckWithVTResult -Force 
}

$CMD =  "cmd"

$arg1 =  "/c"

$arg2 =  $strExeSigCheck

$arg3 =  "/accepteula"

$arg4 =  "-o"

$arg5 =  "-v"

$arg6 =  $VTCheckInputCSV

$arg7 =  ">"

$arg8 = $strSigCheckWithVTResult

#Execute Sigcheck and save to CSV file
& $CMD $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8

[xml]$VTXAML =@"
<Window x:Class="Verify.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" Title="Verify Autoruns - Virus Total Check" WindowStartupLocation = "CenterScreen"
        Width = "850" Height = "380" ShowInTaskbar = "False" ResizeMode="NoResize" WindowStyle="ToolWindow"  Background="{DynamicResource {x:Static SystemColors.ControlBrushKey}}">
    <Grid>
        <StackPanel Orientation="Vertical" HorizontalAlignment="Center">
            <Label x:Name="lblSummary" Content="Virust Total Check Result" Width="200" Margin="05,0,00,00" HorizontalAlignment="Left" />
            <Grid>
                <DataGrid Name="dg_Log" Margin="2,2,2,2" Width="800" ScrollViewer.HorizontalScrollBarVisibility="Auto" Height="260"  >
                    <DataGrid.Columns>
                        <DataGridTextColumn x:Name="colFile" Header="File" Binding="{Binding Path}" Width="120"  IsReadOnly="True"/>
                        <DataGridTextColumn x:Name="colSigner" Header="Signer" Binding="{Binding Publisher}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn x:Name="colCompany" Header="Company" Binding="{Binding Company}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn x:Name="colVersion" Header="Version" Binding="{Binding 'File Version'}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn x:Name="colVTDetection" Header="VT Detection" Binding="{Binding 'VT Detection'}" Width="120" IsReadOnly="True" SortDirection="Descending" />
                        <DataGridTextColumn x:Name="colVTLink" Header="VT Link" Binding="{Binding 'VT Link'}" Width="120" IsReadOnly="True" />
                    </DataGrid.Columns>
                </DataGrid>
            </Grid>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="00,10,00,00">
                <Button x:Name="btnClose" Content="Close" Margin="10,00,00,00" Width="50" Height="20"/>
            </StackPanel>
        </StackPanel>

    </Grid>
</Window>

"@

$VTXAML.Window.RemoveAttribute("x:Class") 

$reader=(New-Object System.Xml.XmlNodeReader $VTXAML)
$VerifyVTGui=[Windows.Markup.XamlReader]::Load( $reader )
$btnClose = $VerifyVTGui.FindName("btnClose")
$dg_Log = $VerifyVTGui.FindName("dg_Log")
$colVTDetection = $VerifyVTGui.FindName("colVTDetection")


$sigs = import-csv $strSigCheckWithVTResult

Foreach ($re in $sigs)
{
    
    [void]$dg_Log.AddChild($re)
}



$btnClose.add_Click(
{
$VerifyVTGui.Close()
})

[void]$VerifyVTGui.ShowDialog()
}
else
{
$MsgBox = [System.Windows.Forms.MessageBox]::Show("Wrong version! Requires 2.50:$strExeSigCheck",”Verify Autoruns”,0,"Error")
}
}
else
{
$MsgBox = [System.Windows.Forms.MessageBox]::Show("Could not find:$strExeSigCheck",”Verify Autoruns”,0,"Error")
}
}
"NO"
{
$VTCheckInputCSV = $LogPath + "\VTInput.csv"
if(Test-Path($VTCheckInputCSV))
{
Remove-Item $VTCheckInputCSV -Force 
}
#¤Build input file for SigCheck
$arrVTCheck = New-Object System.Collections.ArrayList
$arrFilesToCheck = Import-Csv $csvAutoRuns
#If the file got a hash it exist on the disk otherwise sihcheck can't check it
$arrFilesToCheck = $arrFilesToCheck | where "SHA-256" -gt ""
Foreach ($image in $arrFilesToCheck)
{
    # Create object to store the new format that will be input to sigchek
    $objCheckEntry = New-Object psObject | `
    Add-Member NoteProperty "Path" $image."Image Path" -PassThru 
    #Check if the Image is signed or not
    $strSigner = $image.Signer
    if($strSigner.Length -gt 11)
    {
        #Convert the strings in new columns that sigcheck use
        if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Signed"  
        }
        else
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
        }
    }
    else
    {
        Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
    }
    Add-Member NoteProperty -InputObject $objCheckEntry "Date" ""  
    if($strSigner.Length -gt 11)
    {
        #Convert the strings in new columns that sigcheck use
        if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Verified) ","")  
        }
        else
        {
            Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Not verified) ","")  
        }
    }
    else
    {
        Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" ""  
    }
    Add-Member NoteProperty -InputObject $objCheckEntry "Company" $image.Company 
    Add-Member NoteProperty -InputObject $objCheckEntry "Description" $image.Description  
    Add-Member NoteProperty -InputObject $objCheckEntry "Product" $image.Description 
    Add-Member NoteProperty -InputObject $objCheckEntry "Product Version" $image.Version 
    Add-Member NoteProperty -InputObject $objCheckEntry "File Version" $image.Version 
    Add-Member NoteProperty -InputObject $objCheckEntry "Machine Type" ""  
    Add-Member NoteProperty -InputObject $objCheckEntry "MD5" $image."MD5"  
    Add-Member NoteProperty -InputObject $objCheckEntry "SHA1" $image."SHA-1"  
    Add-Member NoteProperty -InputObject $objCheckEntry "PESHA1" $image."PESHA-1"  
    Add-Member NoteProperty -InputObject $objCheckEntry "PESHA256" $image."PESHA-256"  
    Add-Member NoteProperty -InputObject $objCheckEntry "SHA256" $image."SHA-256"  
    Add-Member NoteProperty -InputObject $objCheckEntry "IMP" $image."IMP"  
    [void]$arrVTCheck.Add($objCheckEntry)
}

# Create a CSV file that SigCheck can use
$arrVTCheck | Export-Csv -Path $VTCheckInputCSV -NoTypeInformation -Force
$file = (Get-Content $VTCheckInputCSV )
$file[0] = $file[0].Replace("$([char]34)","")
$file | Set-Content $VTCheckInputCSV -Force
$MsgBox = [System.Windows.Forms.MessageBox]::Show("File saved: $VTCheckInputCSV`n`nRun the following command on a internet connected system:`n`nSigcheck.exe -o -v VTInput.csv",”Verify Autoruns”,0,"Info")
}
Default
{}
}

})

$btnClose.add_Click(
{
$MainWindowsGui.Close()

})

$btnLog.add_Click({
Invoke-Item $global:ReportPath
})

#NonMS.png
$NonMSPic = "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"

#UnsignedNonMS.png
$UnsignedNonMsPic = "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"

#UnsignedMS.png
$UnsignedMsPic = "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"

#MS.png
$MSPic = "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"

#NewUnsignedHash.png
$NewUnsignedHashPic = "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"

#NewHash.png
$NewHashPic = "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"

#Default.png
$DefaultPic = "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"

# Create a streaming image by streaming the base64 string to a bitmap streamsource
$bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$bitmap.BeginInit()
if($bolForced)
{
    $bitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($DefaultPic)
}
else
{
    if($bolSigned)
    {
        If($bolNonMS)
        {
            $bitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($NonMSPic)
        }
        else
        {
            if($bolNewHash)
            {
                $bitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($NewHashPic)
            }
            else
            {
                $bitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($MSPic)
            }
        }
    }
    else
    {
        If($bolNonMS)
        {
            $bitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($UnsignedNonMsPic)
        }
        else
        {
            if($bolNewHash)
            {
                $bitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($NewUnsignedHashPic)
            }
            else
            {
                $bitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($UnsignedMsPic)
            }
        }
    }
}
$bitmap.EndInit()
 
# Freeze() prevents memory leaks.
$bitmap.Freeze()
 
# Set source here. Take note in the XAML as to where the variable name was taken.
$ImgBanner.source = $bitmap

if(Test-Path($csvAutoRuns))
{
$arrNewFilesCsv = Import-Csv $csvAutoRuns
$arrHashes = $arrNewFilesCsv  | where "Image Path" -gt ""  
                    
#Comparing current autorunsc with previuos analyze
Foreach ($image in $arrHashes)
{
   
        $objImage = New-Object psObject | `
        Add-Member NoteProperty "Type" $image.Type -PassThru |`
        Add-Member NoteProperty "File" $image."Image Path" -PassThru |`
        Add-Member NoteProperty "Date" $image.Time -PassThru |`
        Add-Member NoteProperty "Signer" $image.Signer -PassThru |`
        Add-Member NoteProperty "Company" $image.Company -PassThru |`
        Add-Member NoteProperty "Version" $image.Version -PassThru |`
        Add-Member NoteProperty "Description" $image.Description -PassThru 
        $dg_Log.AddChild($objImage)
}
}
   
[void]$MainWindowsGui.ShowDialog()
}

# Load Assemblies
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# Create new Objects
$objForm = New-Object System.Windows.Forms.Form
$global:objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 
$global:objContextMenu = New-Object System.Windows.Forms.ContextMenu
$ExitMenuItem = New-Object System.Windows.Forms.MenuItem
$AddReportMenuItem = New-Object System.Windows.Forms.MenuItem
$AddPerfmonMenuItem = New-Object System.Windows.Forms.MenuItem
$AddSummaryMenuItem = New-Object System.Windows.Forms.MenuItem
$global:menupos = New-Object System.Drawing.Point

$global:objContextMenu.MenuItems.Clear()

# Report Menu Item
$AddReportMenuItem.Index = 0
$AddReportMenuItem.Text = "Open Report $global:ReportName"

$AddReportMenuItem.add_Click({
MainWindow $global:MsgBoxText $csvNewFiles $bolNewSigned $bolNonMS $bolNewHash $global:strExeSigCheck $global:bolForced $global:strLastBootCSV; $global:objNotifyIcon.Dispose();$objForm.Close()
})


# Report Summary
$AddSummaryMenuItem.Index = 1
$AddSummaryMenuItem.Text = "Open Summary"
$AddSummaryMenuItem.add_Click({
SummaryBox $global:objSummary 
})

# Perfmon Menu Item
$AddPerfmonMenuItem.Index = 2
$AddPerfmonMenuItem.Text = "Open Reliability Monitor"
$AddPerfmonMenuItem.add_Click({
perfmon /rel; $global:objNotifyIcon.Dispose();$objForm.Close()
})

# Create an Exit Menu Item
$ExitMenuItem.Index = 3
$ExitMenuItem.Text = "Exit"
$ExitMenuItem.add_Click({ 
$global:objNotifyIcon.Dispose();[void]$objForm.Close()
}) 

# Add the Exit and Add Content Menu Items to the Context Menu
$global:objContextMenu.MenuItems.Add($AddReportMenuItem) | Out-Null
$global:objContextMenu.MenuItems.Add($AddSummaryMenuItem) | Out-Null
$global:objContextMenu.MenuItems.Add($AddPerfmonMenuItem) | Out-Null
$global:objContextMenu.MenuItems.Add($ExitMenuItem) | Out-Null
        
# Assign an Icon to the Notify Icon object
$global:objNotifyIcon.Visible = $true
$global:objNotifyIcon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::$BalloonTipIcon
$global:objNotifyIcon.BalloonTipTitle = $BalloonTipTitle
$global:objNotifyIcon.BalloonTipText = $global:BalloonTipText
$global:objNotifyIcon.Icon = [System.Drawing.SystemIcons]::$NotifyIcon
$global:objNotifyIcon.Text = $global:NotifyIconText
$global:objNotifyIcon.Tag = $global:Tag


$global:objNotifyIcon.add_Click({

})
    
# Assign the Context Menu
$global:objNotifyIcon.ContextMenu = $global:objContextMenu
        
# Control Visibilaty and state of things

$global:objNotifyIcon.ShowBalloonTip(5000) 
$objForm.Visible = $false
$objForm.WindowState = "minimized"
$objForm.ShowInTaskbar = $false
$objForm.add_Closing({ $objForm.ShowInTaskBar = $False }) 
# # Show the Form - Keep it open 
# # This Line must be Last
[void]$objForm.ShowDialog()
#})

#$psCmdBalloonTip.Runspace = $newRunspaceNotification
#$RunNotificationIconCommand = $psCmdBalloonTip.BeginInvoke()
}     
   
        [void] [System.Reflection.Assembly]::LoadWithPartialName(“System.Windows.Forms”)
        if(!(Test-Path $LogPath))
        {
            New-Item -Path $LogPath -ItemType Directory
            #Promt to screen if boolean bolPrompt is true
            if($Prompt)
            {
                Write-Host "Directory missing: Creating $LogPath" -ForegroundColor yellow
            }
            #Write to report
            "Directory missing: Creating $LogPath" | out-file $LogFile -Append ascii
        }
        $strLastBootCSV = "$LogPath\AutorunsC_$LastBoottime.csv"
        if($Analyze)
        {
            #Test if Autorunsc.exe exist
            if(Test-Path $strAutorunscEXE)
            {
                # Verify that it is at least version 13.51 and above of autorunsc.exe
                if((gci $strAutorunscEXE).VersionInfo.FileVersion -ge "13.51")
                {
                    #Promt to screen if boolean bolPrompt is true
                    if($Prompt)
                    {
                        Write-Host "Start analyzing autorunsc..." 
                    }
                    #Write to report
                    "Start analyzing autorunsc..."  | out-file $LogFile -Append ascii

                    $CMD =  "cmd"
                    $arg1 =  "/c"

                    $arg2 =  $strAutorunscEXE

                    $arg2b =  "/accepteula"

                    $arg3 =  "-a"

                    $arg3B =  "*"

                    $arg4 =  "-c"

                    $arg5 =  "-h"

                    $arg6 =  "-m"

                    $arg7 =  "-s"

                    $arg8 =  ">$strLastBootCSV"

                    #Execute Autorunsc and save to CSV file
                    & $CMD $arg1 $arg2 $arg2b $arg3 $arg3B $arg4 $arg5 $arg6 $arg7 $arg8
                }
                else
                {
                    #Promt to screen if boolean bolPrompt is true
                    if($Prompt)
                    {
                        Write-Host "Autorunsc version to old! Version 13.51 and above required" -ForegroundColor RED
                    }
                    #Write to report
                    "Autorunsc version to old! Version 13.51 and above required" | out-file $LogFile -Append ascii
                        
                }# End if Autorunsc.exe version is correct
            } 
            else
            {
                #Promt to screen if boolean bolPrompt is true
                if($Prompt)
                {
                    Write-Host "Autorunsc is missing: File not found $strAutorunscEXE" -ForegroundColor RED
                }
                #Write to report
                "Autorunsc is missing: File not found $strAutorunscEXE" | out-file $LogFile -Append ascii
                        
            }# End if Autorunsc.exe exist
        } # End if Analyze
        if(Test-Path $strLastBootCSV)
        {
            #Import last report
            $arrHashesCSV = import-csv $strLastBootCSV

            #Extract all entries with an hash (it got an image)
            $arrHashes = $arrHashesCSV |  where "SHA-256" -gt "" |  select -Property "Image Path",SHA-256,Time,Entry,"Entry Location",Signer

            #Check if there exist an previous boot info in System Eventlog
            if($strPrevBootTimeEvent)
            {
                #Get previous boot date and time
                $PrevBootTime = get-date($strPrevBootTimeEvent.TimeGenerated) -Format yyyyMMdd-HHmm
                #Define the path the previous autorunsc analyze
                $strPrevBootTimeCSVPath = "$LogPath\AutorunsC_$PrevBootTime.csv"
                #Check if it exist a previous autorunsc analyze
                if(Test-Path $strPrevBootTimeCSVPath)
                {
                    #Import the previous analyze file
                    $strPrevBootTimeCSV = $strPrevBootTimeCSVPath
                }
                else
                {
                    #Prompt to screen
                   if($Prompt)
                    {
                        Write-Host "Could not find $strPrevBootTimeCSVPath" -ForegroundColor yellow
                        Write-Host "Try to find file with time span of $intTimeSpan seconds"
                    }
                    "Could not find $strPrevBootTimeCSVPath" | out-file $LogFile -Append ascii
                    "Try to find file with time span of $intTimeSpan seconds" | out-file $LogFile -Append ascii
                    $PrevBotDateTime = ($strPrevBootTimeEvent.TimeGenerated)
                    $TimeSpanFromEventWritten = $PrevBotDateTime.AddSeconds($intTimeSpan)
                    $PrevBootTimeTimeSpan = get-date($TimeSpanFromEventWritten) -Format yyyyMMdd-HHmm
                    if($PrevBootTimeTimeSpan -ne $PrevBootTime)
                    {
                        $strPrevBootTimeCSVPath = "$LogPath\AutorunsC_$PrevBootTimeTimeSpan.csv"
                        #Check if it exist a previous autorunsc analyze
                        if(Test-Path $strPrevBootTimeCSVPath)
                        {
                            #Import the previous analyze file
                            #Prompt to screen
                            if($Prompt)
                            {
                                Write-host "Found boot file within the time span of $intTimeSpan seconds"
                            }
                            "Found boot file within the time span of $intTimeSpan seconds" | out-file $LogFile -Append ascii
                            $strPrevBootTimeCSV = $strPrevBootTimeCSVPath
  
                        }  
                        else
                        {
                            #Prompt to screen
                            if($Prompt)
                            {
                                Write-host "Could not find file within time span of $intTimeSpan seconds!" -ForegroundColor yellow
                                Write-host "Taking second oldest file in directory"                             
                            }
                            "Could not find file within time span of $intTimeSpan seconds!" | out-file $LogFile -Append ascii
                            "Taking second oldest file in directory" | out-file $LogFile -Append ascii                            
                            
                            $objPreBootfiles = ls $LogPath -Filter AutorunsC_*.csv | sort {$_.BaseName -replace 'AutorunsC_', ''} -Descending | select -Index 1
                            
                            if($objPreBootfiles -ne $null)
                            {
                                $strPrevBootTimeCSV = $objPreBootfiles.FullName
                            }
                            else
                            {
                                #Prompt to screen
                                if($Prompt)
                                {
                                    Write-host "No previuos files found!" -ForegroundColor Red                             
                                }
                                Write-host "No previuos files found!"| out-file $LogFile -Append ascii
                            }
                        }                                      
                    }
                    else
                    {
                        #Prompt to screen
                        if($Prompt)
                        {
                            Write-Host "The time span of $intTimeSpan seconds, did not cover any other file" -ForegroundColor yellow
                            Write-host "Taking second newst file in directory"                             
                        }
                        "The time span of $intTimeSpan seconds, did not cover any other file" | out-file $LogFile -Append ascii
                        "Taking second newst file in directory" | out-file $LogFile -Append ascii
                        $objPreBootfiles = ls $LogPath -Filter AutorunsC_*.csv | sort {$_.BaseName -replace 'AutorunsC_', ''} -Descending | select -Index 1
                        if($objPreBootfiles.Exists)
                        {
                            $strPrevBootTimeCSV = $objPreBootfiles.FullName
                        }
                        else
                        {
                            $strPrevBootTimeCSV = $false
                            #Prompt to screen
                            if($Prompt)
                            {
                                Write-host "No previuos files found!" -ForegroundColor Red                            
                            }
                            "No previuos files found!" | out-file $LogFile -Append ascii
                        }
                    }  
   
                }
                if($strPrevBootTimeCSV)
                {
                    #Import the previous analyze file
                    $arrPrevBootHashesCSV = import-csv $strPrevBootTimeCSV 
                    #Extract all entries with an hash
                    $arrPrevBootHashes = $arrPrevBootHashesCSV  | where "SHA-256" -gt ""  | select -Property "Image Path",SHA-256,Time,Entry,"Entry Location",Signer
                    #Count Previous number of Images
                    $intPrevBootImages = $arrPrevBootHashes.Count
                    #Boolean acting as a trigger in new entries with hahses been added
                    $arrNewBinaries = New-Object System.Collections.ArrayList
                    $arrNewBinariesUnsigned = New-Object System.Collections.ArrayList
                    $arrNewHashes = New-Object System.Collections.ArrayList
                    $arrNewBinariesNonMS = New-Object System.Collections.ArrayList
                    $arrNewBinariesNonMSUnsigned = New-Object System.Collections.ArrayList
                    $bolNewBinaries = $false
                    $bolNewBinariesUnsigned = $false
                    $bolNewBinariesNonMS = $false
                    $bolNewBinariesNonMSUnsigned = $false
                    $bolNewMSSigned = $false
                    $bolNewUnSignedHash = $false
                    #Compare the number of Hashes
 
                    #Promt to screen if boolean bolPrompt is true
                    if($Prompt)
                    {
                        Write-Host "******************************************************" -ForegroundColor Yellow
                        Write-Host "Verifying New Images" -ForegroundColor Yellow
                        Write-Host "******************************************************" -ForegroundColor Yellow
                    }
                    #Write to report
                    "******************************************************" | out-file $LogFile -Append ascii
                    "Verifying New Images" | out-file $LogFile -Append ascii
                    "******************************************************" | out-file $LogFile -Append ascii
                    #Int for keeping track of number of new entries
                    $intNumNewEntry = 0
                    $intNumNewEntryUnsigned = 0
                    #Int for keeping track of number of new entries
                    $intNumNewEntryNonMS = 0
                    $intNumNewEntryNonMSUnsigned = 0 
                    #Comparing current autorunsc with previuos analyze
                    Foreach ($image in $arrHashes)
                    {
                        #Boolean inidcating which new entrie exists
                        $bolExist = $false
                        #Boolean inidcating if new entrie are Microsoft or not
                        $bolMSNonEntry = $false
                        #Gett all entreis from previuos analyze
                        Foreach ($previmage in $arrPrevBootHashes)
                        {
                            #Compare image path,entry and entry location
                            if (($previmage."image path" -eq $image."image path") -and ($previmage.Entry -eq $image.Entry)  -and ($previmage."Entry Location" -eq $image."Entry Location"))
                            {
                                #Boolean indicating it's not new
                                $bolExist = $true
                            }
                        }
                        #If the image path is new
                        if($bolExist -eq $false)
                        {
                            #Check if the Image is signed or not
                            $strSigner = $image.Signer
                            if($strSigner.Length -gt 11)
                            {
                                #If the image is signed add to arrNewBinariesNonMS or arrNewBinariesNonMS
                                if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
                                {
                                    #Boolean indicating a new entry exist
                                    $bolNewBinaries = $true
                                    #Return entry with matching entry,Image path and Entry Location for new entry
                                    $NewEntry = $arrHashesCSV | where {($_.'Image Path' -eq $image."image path") -and ($_.Entry -eq $image.Entry) -and ($_.'Entry Location' -eq $image."Entry Location")} | Select-Object -First 1
                                    #Build a custom object to represent information about the new entry
                                    if($NewEntry.Company -ne "Microsoft Corporation")
                                    {
                                        $bolMSNonEntry = $true
                                        $bolNewBinariesNonMS = $true
                                        $strNewEntryType = "Non-MS"
                                    }
                                    else
                                    {
                                        $bolNewMSSigned = $true
                                        $strNewEntryType = "MS"
                                    }
                                    $objNewEntry = New-Object psObject | `
                                    Add-Member NoteProperty "Boot Date" $LastBoottime -PassThru |`
                                    Add-Member NoteProperty "Type" $strNewEntryType -PassThru |`
                                    Add-Member NoteProperty "Time" $NewEntry.Time -PassThru |`
                                    Add-Member NoteProperty "Entry Location" $NewEntry."Entry Location" -PassThru |`
                                    Add-Member NoteProperty "Entry" $NewEntry.Entry -PassThru |`
                                    Add-Member NoteProperty "Category" $NewEntry.Category -PassThru |`
                                    Add-Member NoteProperty "Profile" $NewEntry.Profile -PassThru |`
                                    Add-Member NoteProperty "Description" $NewEntry.Description -PassThru |`
                                    Add-Member NoteProperty "Company" $NewEntry.Company -PassThru |`
                                    Add-Member NoteProperty "Image Path" $NewEntry."Image Path" -PassThru |`
                                    Add-Member NoteProperty "Signer" $NewEntry."Signer" -PassThru |`
                                    Add-Member NoteProperty "Version" $NewEntry.Version -PassThru |`
                                    Add-Member NoteProperty "Launch String" $NewEntry."Launch String" -PassThru |`
                                    Add-Member NoteProperty "MD5" $NewEntry."MD5" -PassThru |`
                                    Add-Member NoteProperty "SHA-1" $NewEntry."SHA-1" -PassThru |`
                                    Add-Member NoteProperty "PESHA-1" $NewEntry."PESHA-1" -PassThru |`
                                    Add-Member NoteProperty "PESHA-256" $NewEntry."PESHA-256" -PassThru |`
                                    Add-Member NoteProperty "SHA-256" $NewEntry."SHA-256" -PassThru |`
                                    Add-Member NoteProperty "IMP" $NewEntry."IMP" -PassThru 

                                    #Prompt to screen
                                    if($Prompt)
                                    {
                                        Write-Host "WARNING! New image:"$image."image path" -ForegroundColor Yellow
                                        #Prompt the entry
                                        $objNewEntry
                                    }
                                    #Write to report
                                    "WARNING! New image:$($image."image path")" | out-file $LogFile -Append ascii
                                    #Prompt the entry to report
                                    $objNewEntry | out-file $LogFile -Append ascii
                                    #If the image path is non Microsoft
                                    if($bolMSNonEntry)
                                    {
                                       [void]$arrNewBinariesNonMS.Add($objNewEntry)
                                       $intNumNewEntryNonMS++
                                    }
                                    else
                                    {
                                       [void]$arrNewBinaries.Add($objNewEntry)
                                       $intNumNewEntry++
                                    }
                                    
                                }
                                #if not signed 
                                else
                                {
                                    
                                    #Boolean indicating a new entry exist
                                    $bolNewBinaries = $true
                                    #Return entry with matching entry,Image path and Entry Location for new entry
                                    $NewEntry = $arrHashesCSV | where {($_.'Image Path' -eq $image."image path") -and ($_.Entry -eq $image.Entry) -and ($_.'Entry Location' -eq $image."Entry Location")} | Select-Object -First 1
                                    #Build a custom object to represent information about the new entry
                                    if($NewEntry.Company -ne "Microsoft Corporation")
                                    {
                                        $bolMSNonEntry = $true
                                        $bolNewBinariesNonMSUnsigned = $true
                                        $strNewEntryType = "Unsigned Non-MS"
                                    }
                                    else
                                    {
                                        $bolNewBinariesUnsigned = $true
                                        $strNewEntryType = "Unsigned MS"
                                    }
                                    $objNewEntry = New-Object psObject | `
                                    Add-Member NoteProperty "Boot Date" $LastBoottime -PassThru |`
                                    Add-Member NoteProperty "Type" $strNewEntryType -PassThru |`
                                    Add-Member NoteProperty "Time" $NewEntry.Time -PassThru |`
                                    Add-Member NoteProperty "Entry Location" $NewEntry."Entry Location" -PassThru |`
                                    Add-Member NoteProperty "Entry" $NewEntry.Entry -PassThru |`
                                    Add-Member NoteProperty "Category" $NewEntry.Category -PassThru |`
                                    Add-Member NoteProperty "Profile" $NewEntry.Profile -PassThru |`
                                    Add-Member NoteProperty "Description" $NewEntry.Description -PassThru |`
                                    Add-Member NoteProperty "Company" $NewEntry.Company -PassThru |`
                                    Add-Member NoteProperty "Image Path" $NewEntry."Image Path" -PassThru |`
                                    Add-Member NoteProperty "Signer" $NewEntry."Signer" -PassThru |`
                                    Add-Member NoteProperty "Version" $NewEntry.Version -PassThru |`
                                    Add-Member NoteProperty "Launch String" $NewEntry."Launch String" -PassThru |`
                                    Add-Member NoteProperty "MD5" $NewEntry."MD5" -PassThru |`
                                    Add-Member NoteProperty "SHA-1" $NewEntry."SHA-1" -PassThru |`
                                    Add-Member NoteProperty "PESHA-1" $NewEntry."PESHA-1" -PassThru |`
                                    Add-Member NoteProperty "PESHA-256" $NewEntry."PESHA-256" -PassThru |`
                                    Add-Member NoteProperty "SHA-256" $NewEntry."SHA-256" -PassThru |`
                                    Add-Member NoteProperty "IMP" $NewEntry."IMP" -PassThru 

                                    #Prompt to screen
                                    if($Prompt)
                                    {
                                        Write-Host "WARNING! New Unsigned image:"$image."image path" -ForegroundColor Red
                                        #Prompt the entry
                                        $objNewEntry
                                    }
                                    #Write to report
                                    "WARNING! New Unsigned image:$($image."image path")" | out-file $LogFile -Append ascii
                                    #Prompt the entry to report
                                    $objNewEntry | out-file $LogFile -Append ascii
                                    #If the image path is non Microsoft
                                    if($bolMSNonEntry)
                                    {
                                       [void]$arrNewBinariesNonMSUnsigned.Add($objNewEntry)
                                       $intNumNewEntryNonMSUnsigned++
                                    }
                                    else
                                    {
                                       [void]$arrNewBinariesUnsigned.Add($objNewEntry)
                                       $intNumNewEntryUnsigned++
                                    }
                                    
                                }
                            }
                            #If Signer string is shorter than 11 Chars it can't be signed
                            else
                            {
                                #Boolean indicating a new entry exist
                                $bolNewBinaries = $true
                                #Return entry with matching entry,Image path and Entry Location for new entry
                                $NewEntry = $arrHashesCSV | where {($_.'Image Path' -eq $image."image path") -and ($_.Entry -eq $image.Entry) -and ($_.'Entry Location' -eq $image."Entry Location")} | Select-Object -First 1
                                #Build a custom object to represent information about the new entry
                                if($NewEntry.Company -ne "Microsoft Corporation")
                                {
                                    $bolMSNonEntry = $true
                                    $bolNewBinariesNonMSUnsigned = $true
                                    $strNewEntryType = "Unsigned Non-MS"
                                }
                                else
                                {
                                    $bolNewBinariesUnsigned = $true
                                    $strNewEntryType = "Unsigned MS"
                                }
                                $objNewEntry = New-Object psObject | `
                                Add-Member NoteProperty "Boot Date" $LastBoottime -PassThru |`
                                Add-Member NoteProperty "Type" $strNewEntryType -PassThru |`
                                Add-Member NoteProperty "Time" $NewEntry.Time -PassThru |`
                                Add-Member NoteProperty "Entry Location" $NewEntry."Entry Location" -PassThru |`
                                Add-Member NoteProperty "Entry" $NewEntry.Entry -PassThru |`
                                Add-Member NoteProperty "Category" $NewEntry.Category -PassThru |`
                                Add-Member NoteProperty "Profile" $NewEntry.Profile -PassThru |`
                                Add-Member NoteProperty "Description" $NewEntry.Description -PassThru |`
                                Add-Member NoteProperty "Company" $NewEntry.Company -PassThru |`
                                Add-Member NoteProperty "Image Path" $NewEntry."Image Path" -PassThru |`
                                Add-Member NoteProperty "Signer" $NewEntry."Signer" -PassThru |`
                                Add-Member NoteProperty "Version" $NewEntry.Version -PassThru |`
                                Add-Member NoteProperty "Launch String" $NewEntry."Launch String" -PassThru |`
                                Add-Member NoteProperty "MD5" $NewEntry."MD5" -PassThru |`
                                Add-Member NoteProperty "SHA-1" $NewEntry."SHA-1" -PassThru |`
                                Add-Member NoteProperty "PESHA-1" $NewEntry."PESHA-1" -PassThru |`
                                Add-Member NoteProperty "PESHA-256" $NewEntry."PESHA-256" -PassThru |`
                                Add-Member NoteProperty "SHA-256" $NewEntry."SHA-256" -PassThru |`
                                Add-Member NoteProperty "IMP" $NewEntry."IMP" -PassThru 

                                #Prompt to screen
                                if($Prompt)
                                {
                                    Write-Host "WARNING! New Unsigned image:"$image."image path" -ForegroundColor Red
                                    #Prompt the entry
                                    $objNewEntry
                                }
                                #Write to report
                                "WARNING! New Unsigned image:$($image."image path")" | out-file $LogFile -Append ascii
                                #Prompt the entry to report
                                $objNewEntry | out-file $LogFile -Append ascii
                                #If the image path is non Microsoft
                                if($bolMSNonEntry)
                                {
                                    [void]$arrNewBinariesNonMSUnsigned.Add($objNewEntry)
                                    $intNumNewEntryNonMSUnsigned++
                                }
                                else
                                {
                                    [void]$arrNewBinariesUnsigned.Add($objNewEntry)
                                    $intNumNewEntryUnsigned++
                                }
                                
                            }


                        }
                    }

                    #Prompt to screen
                    if($Prompt)
                    {
                        Write-Host "******************************************************" -ForegroundColor Yellow
                    }
                    #Write to report
                    "******************************************************" | out-file $LogFile -Append ascii
                    
                    #Prompt to screen
                    if($Prompt)
                    {
                        Write-Host "Verifying hahses" -ForegroundColor Yellow
                        Write-Host "******************************************************" -ForegroundColor Yellow    
                    }
                    #Prompt the entry to repor
                    "Verifying hahses" | out-file $LogFile -Append ascii
                    "******************************************************" | out-file $LogFile -Append ascii
                    #Create new table for verifying hashes
                    $arrHashes = $arrHashesCSV | where SHA-256 -gt 0 |  select -Property "Image Path",SHA-256,Time,Entry,"Entry Location"
                    $arrPrevBootHashes = $arrPrevBootHashesCSV  | where SHA-256 -gt 0  | select -Property "Image Path",SHA-256,Time,Entry,"Entry Location"
                    #Boolean for inidicating if hashes is different from previuos boot, default FALSE
                    $bolHashDiff = $false
                    #Int for keeping track of number of new hahses
                    $intNumHashDiff = 0 
                    #Enumerating all previuos images with hashes 
                    Foreach ($previmage in $arrPrevBootHashes)
                    {
                        #Enumerating all current images with hashes 
                        Foreach ($image in $arrHashes)
                        {
                            #If the image have the same path, Entry Location and hashes as in previuos analyze
                            if (($image."image path" -eq $previmage."image path") -and ($image."Entry Location" -eq $previmage."Entry Location")-and  ($image."SHA-256" -ne $previmage."SHA-256"))
                            {

                                #Check if the Image is signed or not
                                $strSigner = $image.Signer
                                if($strSigner.Length -gt 11)
                                {
                                    #If the image is signed add to arrNewBinariesNonMS or arrNewBinariesNonMS
                                    if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
                                    {
                                        #Boolean indicating it does not match
                                        $bolHashDiff = $true
                                        #Get full entry with different hash
                                        $newHashImage = $arrHashesCSV | where {($_.'SHA-256' -eq $image."SHA-256") -and ($_.'Image Path' -eq $image."image path") -and ($_.Entry -eq $image.Entry) -and ($_.'Entry Location' -eq $image."Entry Location")} | Select-Object -First 1
                                        $strNewEntryType = "New Hash"
                                        #Build a custom object to represent information about the entry with different hash
                                        $objDiffHashEntry = New-Object psObject | `
                                        Add-Member NoteProperty "Boot Date" $LastBoottime -PassThru |`                                        
                                        Add-Member NoteProperty "Type" $strNewEntryType -PassThru |`
                                        Add-Member NoteProperty "Time" $newHashImage.Time -PassThru |`
                                        Add-Member NoteProperty "Time (OLD)" $previmage.Time -PassThru |`
                                        Add-Member NoteProperty "Entry Location" $newHashImage."Entry Location" -PassThru |`
                                        Add-Member NoteProperty "Entry" $newHashImage.Entry -PassThru |`
                                        Add-Member NoteProperty "Category" $newHashImage.Category -PassThru |`
                                        Add-Member NoteProperty "Profile" $newHashImage.Profile -PassThru |`
                                        Add-Member NoteProperty "Description" $newHashImage.Description -PassThru |`
                                        Add-Member NoteProperty "Company" $newHashImage.Company -PassThru |`
                                        Add-Member NoteProperty "Image Path" $newHashImage."Image Path" -PassThru |`
                                        Add-Member NoteProperty "Signer" $newHashImage."Signer" -PassThru |`
                                        Add-Member NoteProperty "Version" $newHashImage.Version -PassThru |`
                                        Add-Member NoteProperty "Launch String" $newHashImage."Launch String" -PassThru |`
                                        Add-Member NoteProperty "MD5" $newHashImage."MD5" -PassThru |`
                                        Add-Member NoteProperty "SHA-1" $newHashImage."SHA-1" -PassThru |`
                                        Add-Member NoteProperty "PESHA-1" $newHashImage."PESHA-1" -PassThru |`
                                        Add-Member NoteProperty "PESHA-256" $newHashImage."PESHA-256" -PassThru |`
                                        Add-Member NoteProperty "SHA-256" $newHashImage."SHA-256" -PassThru |`
                                        Add-Member NoteProperty "SHA-256 (OLD)" $previmage."SHA-256" -PassThru |`
                                        Add-Member NoteProperty "IMP" $newHashImage."IMP" -PassThru 
                                        [void]$arrNewHashes.Add($objDiffHashEntry)
                                        #Prompt to screen
                                        if($Prompt)
                                        {
                                            Write-Host "WARNING! New SHA-256 Hash:"$image."image path" -ForegroundColor Yellow
                                            #Write entry with different hash to screen
                                            $objDiffHashEntry
                                        }
                                        #Write warning to report
                                        "WARNING! New SHA-256 Hash:$($image."image path")" | out-file $LogFile -Append ascii
                                        #Write entry with different hash to report
                                        $objDiffHashEntry | out-file $LogFile -Append ascii
                                        #Plus one for each non-matching hash
                                        $intNumHashDiff++
                                    }
                                    else
                                    {
                                        #Boolean indicating it does not match
                                        $bolHashDiff = $true
                                        $bolNewUnSignedHash = $true
                                        #Get full entry with different hash
                                        $newHashImage = $arrHashesCSV | where {($_.'SHA-256' -eq $image."SHA-256") -and ($_.'Image Path' -eq $image."image path") -and ($_.Entry -eq $image.Entry) -and ($_.'Entry Location' -eq $image."Entry Location")} | Select-Object -First 1
                                        $strNewEntryType = "New Unsigned Hash"
                                        #Build a custom object to represent information about the entry with different hash
                                        $objDiffHashEntry = New-Object psObject | 
                                        Add-Member NoteProperty "Boot Date" $LastBoottime -PassThru |`                                        `
                                        Add-Member NoteProperty "Type" $strNewEntryType -PassThru |`
                                        Add-Member NoteProperty "Time" $newHashImage.Time -PassThru |`
                                        Add-Member NoteProperty "Time (OLD)" $previmage.Time -PassThru |`
                                        Add-Member NoteProperty "Entry Location" $newHashImage."Entry Location" -PassThru |`
                                        Add-Member NoteProperty "Entry" $newHashImage.Entry -PassThru |`
                                        Add-Member NoteProperty "Category" $newHashImage.Category -PassThru |`
                                        Add-Member NoteProperty "Profile" $newHashImage.Profile -PassThru |`
                                        Add-Member NoteProperty "Description" $newHashImage.Description -PassThru |`
                                        Add-Member NoteProperty "Company" $newHashImage.Company -PassThru |`
                                        Add-Member NoteProperty "Image Path" $newHashImage."Image Path" -PassThru |`
                                        Add-Member NoteProperty "Signer" $newHashImage."Signer" -PassThru |`
                                        Add-Member NoteProperty "Version" $newHashImage.Version -PassThru |`
                                        Add-Member NoteProperty "Launch String" $newHashImage."Launch String" -PassThru |`
                                        Add-Member NoteProperty "MD5" $newHashImage."MD5" -PassThru |`
                                        Add-Member NoteProperty "SHA-1" $newHashImage."SHA-1" -PassThru |`
                                        Add-Member NoteProperty "PESHA-1" $newHashImage."PESHA-1" -PassThru |`
                                        Add-Member NoteProperty "PESHA-256" $newHashImage."PESHA-256" -PassThru |`
                                        Add-Member NoteProperty "SHA-256" $newHashImage."SHA-256" -PassThru |`
                                        Add-Member NoteProperty "SHA-256 (OLD)" $previmage."SHA-256" -PassThru |`
                                        Add-Member NoteProperty "IMP" $newHashImage."IMP" -PassThru 
                                        [void]$arrNewHashes.Add($objDiffHashEntry)
                                        #Prompt to screen
                                        if($Prompt)
                                        {
                                            Write-Host "WARNING! New SHA-256 Hash:"$image."image path" -ForegroundColor Yellow
                                            #Write entry with different hash to screen
                                            $objDiffHashEntry
                                        }
                                        #Write warning to report
                                        "WARNING! New SHA-256 Hash:$($image."image path")" | out-file $LogFile -Append ascii
                                        #Write entry with different hash to report
                                        $objDiffHashEntry | out-file $LogFile -Append ascii
                                        #Plus one for each non-matching hash
                                        $intNumHashDiff++
                                    }
                                }
                                else
                                {
                                    #Boolean indicating it does not match
                                    $bolHashDiff = $true
                                    $bolNewUnSignedHash = $true
                                    #Get full entry with different hash
                                    $newHashImage = $arrHashesCSV | where {($_.'SHA-256' -eq $image."SHA-256") -and ($_.'Image Path' -eq $image."image path") -and ($_.Entry -eq $image.Entry) -and ($_.'Entry Location' -eq $image."Entry Location")} | Select-Object -First 1
                                    $strNewEntryType = "New Unsigned Hash"
                                    #Build a custom object to represent information about the entry with different hash
                                    $objDiffHashEntry = New-Object psObject | `
                                    Add-Member NoteProperty "Boot Date" $LastBoottime -PassThru |`
                                    Add-Member NoteProperty "Type" $strNewEntryType -PassThru |`
                                    Add-Member NoteProperty "Time" $newHashImage.Time -PassThru |`
                                    Add-Member NoteProperty "Time (OLD)" $previmage.Time -PassThru |`
                                    Add-Member NoteProperty "Entry Location" $newHashImage."Entry Location" -PassThru |`
                                    Add-Member NoteProperty "Entry" $newHashImage.Entry -PassThru |`
                                    Add-Member NoteProperty "Category" $newHashImage.Category -PassThru |`
                                    Add-Member NoteProperty "Profile" $newHashImage.Profile -PassThru |`
                                    Add-Member NoteProperty "Description" $newHashImage.Description -PassThru |`
                                    Add-Member NoteProperty "Company" $newHashImage.Company -PassThru |`
                                    Add-Member NoteProperty "Image Path" $newHashImage."Image Path" -PassThru |`
                                    Add-Member NoteProperty "Signer" $newHashImage."Signer" -PassThru |`
                                    Add-Member NoteProperty "Version" $newHashImage.Version -PassThru |`
                                    Add-Member NoteProperty "Launch String" $newHashImage."Launch String" -PassThru |`
                                    Add-Member NoteProperty "MD5" $newHashImage."MD5" -PassThru |`
                                    Add-Member NoteProperty "SHA-1" $newHashImage."SHA-1" -PassThru |`
                                    Add-Member NoteProperty "PESHA-1" $newHashImage."PESHA-1" -PassThru |`
                                    Add-Member NoteProperty "PESHA-256" $newHashImage."PESHA-256" -PassThru |`
                                    Add-Member NoteProperty "SHA-256" $newHashImage."SHA-256" -PassThru |`
                                    Add-Member NoteProperty "SHA-256 (OLD)" $previmage."SHA-256" -PassThru |`
                                    Add-Member NoteProperty "IMP" $newHashImage."IMP" -PassThru 
                                    [void]$arrNewHashes.Add($objDiffHashEntry)
                                    #Prompt to screen
                                    if($Prompt)
                                    {
                                        Write-Host "WARNING! New SHA-256 Hash:"$image."image path" -ForegroundColor Yellow
                                        #Write entry with different hash to screen
                                        $objDiffHashEntry
                                    }
                                    #Write warning to report
                                    "WARNING! New SHA-256 Hash:$($image."image path")" | out-file $LogFile -Append ascii
                                    #Write entry with different hash to report
                                    $objDiffHashEntry | out-file $LogFile -Append ascii
                                    #Plus one for each non-matching hash
                                    $intNumHashDiff++
                                }
                            }
                        }
                    }
                    #Prompt to screen
                    if($Prompt)
                    {        
                        Write-Host "******************************************************" -ForegroundColor Yellow
                    }
                    "******************************************************" | out-file $LogFile -Append ascii
                    #Calculate number of deleted Entries
                    $inNumDeltedEntries = $($intNumNewEntry - ($arrHashes.Count-$intPrevBootImages))
                    if($inNumDeltedEntries -le 0){$inNumDeltedEntries = 0}
                    #New object for formating information in report where a compare has been performed
                    $objReportPrevInfo = New-Object psObject | `
                    Add-Member NoteProperty "Previous Boot" $(get-date($strPrevBootTimeEvent.TimeGenerated) -Format "yyyy-MM-dd HH:mm") -PassThru |`
                    Add-Member NoteProperty "Number of new unsigned entries (Microsoft)" "$intNumNewEntryUnsigned" -PassThru |`
                    Add-Member NoteProperty "Number of new entries (Microsoft)" "$intNumNewEntry" -PassThru |`
                    Add-Member NoteProperty "Number of deleted entries" "$inNumDeltedEntries" -PassThru |`
                    Add-Member NoteProperty "Entries with new hash" "$intNumHashDiff" -PassThru |`
                    Add-Member NoteProperty "Number of new entries (Non-Microsoft)" "$intNumNewEntryNonMS" -PassThru |`
                    Add-Member NoteProperty "Number of new unsigned entries (Non-Microsoft)" "$intNumNewEntryNonMSUnsigned" -PassThru |`
                    Add-Member NoteProperty "Previous Boot Autorun entries" "$($intPrevBootImages)" -PassThru 
                   }
                else
                {
                    #Promt to screen if boolean bolPrompt is true
                    if($Prompt)
                    {
                        Write-Host "Could not perform a compare!" -ForegroundColor yellow                        
                        Write-Host "Did not find any previous autoruns file!" -ForegroundColor yellow
                    }
                    #Write to report
                    "Could not perform a compare!" | out-file $LogFile -Append ascii
                    "Did not find any previous autoruns file!" | out-file $LogFile -Append ascii
                }
                #Build a new resulting information object
                if($objReportInfo -eq $null)
                {
                    $objReportInfo = New-Object psObject
                }
                Add-Member NoteProperty -InputObject $objReportInfo "Last Boot" $(get-date($strBootTime.LastBootUptime) -Format "yyyy-MM-dd HH:mm") 
                if($objReportPrevInfo."Previous Boot")
                {
                    Add-Member NoteProperty -InputObject $objReportInfo "Previous Boot" $objReportPrevInfo."Previous Boot"
                }
                Add-Member NoteProperty -InputObject $objReportInfo "Current Autorun entries" $($arrHashes.Count)
                if($objReportPrevInfo."Previous Boot Autorun entries")
                {
                    Add-Member NoteProperty -InputObject $objReportInfo "Previous Boot Autorun entries" $objReportPrevInfo."Previous Boot Autorun entries"
                }
                if($objReportPrevInfo."Number of new entries (Microsoft)")
                {
                    Add-Member NoteProperty -InputObject $objReportInfo "Number of new entries (Microsoft)" $objReportPrevInfo."Number of new entries (Microsoft)"
                }
                if($objReportPrevInfo."Number of new entries (Non-Microsoft)")
                {
                    Add-Member NoteProperty -InputObject $objReportInfo "Number of new entries (Non-Microsoft)" $objReportPrevInfo."Number of new entries (Non-Microsoft)"
                }
                if($objReportPrevInfo."Entries with new hash")
                {
                    Add-Member NoteProperty -InputObject $objReportInfo "Entries with new hash" $objReportPrevInfo."Entries with new hash"
                }
                if($objReportPrevInfo."Number of deleted entries")
                {
                    Add-Member NoteProperty -InputObject $objReportInfo "Number of deleted entries" $objReportPrevInfo."Number of deleted entries"
                }
                if($objReportPrevInfo."Number of new unsigned entries (Microsoft)")
                {
                    Add-Member NoteProperty -InputObject $objReportInfo "Number of new unsigned entries (Microsoft)" $objReportPrevInfo."Number of new unsigned entries (Microsoft)"
                }
                if($objReportPrevInfo."Number of new unsigned entries (Non-Microsoft)")
                {
                    Add-Member NoteProperty -InputObject $objReportInfo "Number of new unsigned entries (Non-Microsoft)" $objReportPrevInfo."Number of new unsigned entries (Non-Microsoft)"
                }
                #Write to log and prompt to screen
                if($bolNewBinaries)
                {
                    if($bolNewBinariesNonMSUnsigned)
                    {
                        #Prompt to screen
                        if($Prompt)
                        {        
                            Write-Host "******************************************************" -ForegroundColor Yellow
                        }
                        "******************************************************" | out-file $LogFile -Append ascii
                        $strMessage = "New Unsigned Non-MS binaries added to Autoruns!`nNumber of new unsigned Non-MS autoruns: $intNumNewEntryNonMSUnsigned"
                        #Prompt to screen
                        if($Prompt)
                        {                         
                            Write-Host "New Unsigned Non-Microsoft binaries added to Autoruns!" -ForegroundColor Red
                        }
                            "New Unsigned Non-Microsoft binaries added to Autoruns!" | out-file $LogFile -Append ascii
                    }
                    #Else if Signed Binaries
                    else
                    {
                        if($bolNewBinariesNonMS)
                        {
                            #Prompt to screen
                            if($Prompt)
                            {        
                                Write-Host "******************************************************" -ForegroundColor Yellow
                            }
                            "******************************************************" | out-file $LogFile -Append ascii
                            $strMessage = "New Non-MS binaries added to Autoruns!`nNumber of new Non-MS autoruns: $intNumNewEntryNonMS"
                            #Prompt to screen
                            if($Prompt)
                            {                         
                                Write-Host "New Non-Microsoft binaries added to Autoruns!" -ForegroundColor Red
                            }
                                "New Non-Microsoft binaries added to Autoruns!" | out-file $LogFile -Append ascii
                        }
                        else
                        {
                            if($bolNewBinariesUnsigned)
                            {
                                #Prompt to screen
                                if($Prompt)
                                {        
                                    Write-Host "******************************************************" -ForegroundColor Yellow
                                }
                                "******************************************************" | out-file $LogFile -Append ascii
                                $strMessage = "New Unsigned MS binaries added to Autoruns!`nNumber of new Unsigned MS autoruns: $intNumNewEntryUnsigned"
                                #Prompt to screen
                                if($Prompt)
                                {                         
                                    Write-Host "New Unsigned MS binaries added to Autoruns!" -ForegroundColor Red
                                }
                                    "New Unsigned MS binaries added to Autoruns!" | out-file $LogFile -Append ascii
                            }
                            else
                            {
                                #Prompt to screen
                                if($Prompt)
                                {        
                                    Write-Host "******************************************************" -ForegroundColor Yellow
                                }
                                "******************************************************" | out-file $LogFile -Append ascii
                                $strMessage = "New MS binaries added to Autoruns!`nNumber of new MS autoruns: $intNumNewEntry"
                                #Prompt to screen
                                if($Prompt)
                                {                         
                                    Write-Host "New MS binaries added to Autoruns!" -ForegroundColor Red
                                }
                                    "New MS binaries added to Autoruns!" | out-file $LogFile -Append ascii
                            }
                        }
                    }
                }
                else
                {
                    if($bolHashDiff)
                    {
                        if($bolNewUnSignedHash)
                        {
                            #Prompt to screen
                            if($Prompt)
                            {           
                                Write-Host "******************************************************" -ForegroundColor Yellow
                            }
                            "******************************************************" | out-file $LogFile -Append ascii
                            $strMessage = "Unsigned Binaries have new hashes!`nNumber of images with changed hash: $intNumHashDiff"
                            #Prompt to screen
                            if($Prompt)
                            {            
                                Write-Host "Unsigned Binaries have new hashes!" -ForegroundColor Red
                            }
                        }
                        else
                        {
                            #Prompt to screen
                            if($Prompt)
                            {           
                                Write-Host "******************************************************" -ForegroundColor Yellow
                            }
                            "******************************************************" | out-file $LogFile -Append ascii
                            $strMessage = "Binaries have new hashes!`nNumber of images with changed hash: $intNumHashDiff"
                            #Prompt to screen
                            if($Prompt)
                            {            
                                Write-Host "Binaries have new hashes!" -ForegroundColor Red
                            }
                            "Binaries have new hashes!" | out-file $LogFile -Append ascii
                        }
                    }
                    else
                    {
                            #Prompt to screen
                            if($Prompt)
                            {           
                                Write-Host "******************************************************" -ForegroundColor Yellow
                            }
                            "******************************************************" | out-file $LogFile -Append ascii
                            $strMessage = "No changes found."
                            #Prompt to screen
                            if($Prompt)
                            {            
                                Write-Host "No changes found." -ForegroundColor Red
                            }
                            "No changes found." | out-file $LogFile -Append ascii

                    }
                }
                #Prompt to screen
                if($Prompt)
                {

                    
                    if($intNumNewEntry -gt 0)
                    {
                        Write-Host "******************* New Entries (Microsoft) ************************" -ForegroundColor Yellow
                        $arrNewBinaries | sort-object -Property Company | ft -Property Entry,"Image Path",Signer,"Launch String",Company -AutoSize
                    }
                    if($intNumNewEntryUnsigned -gt 0)
                    {
                        Write-Host "******************* New Entries Unsigned (Microsoft) ************************" -ForegroundColor Yellow
                        $arrNewBinariesUnsigned | sort-object -Property Company | ft -Property Entry,"Image Path",Signer,"Launch String",Company -AutoSize
                    }
                    if($intNumNewEntryNonMS -gt 0)
                    {
                        Write-Host "************* New Entries (Non-Microsoft) ************" -ForegroundColor Yellow
                        $arrNewBinariesNonMS | sort-object -Property Company | ft -Property Entry,"Image Path",Signer,"Launch String",Company -AutoSize
                    }
                    if($intNumNewEntryNonMSUnsigned -gt 0)
                    {
                        Write-Host "************* New Entries Unsigned (Non-Microsoft) ************" -ForegroundColor Yellow
                        $arrNewBinariesNonMSUnsigned | sort-object -Property Company | ft -Property Entry,"Image Path",Signer,"Launch String",Company -AutoSize
                    }
                    if($intNumHashDiff -gt 0)
                    {
                        Write-Host "*************** Image with new hash ******************" -ForegroundColor Yellow
                        $arrNewHashes | sort-object -Property Company | ft -Property Entry,"Image Path",Signer,"Launch String",Company -AutoSize
                    }
                    Write-Host "******************************************************" -ForegroundColor Yellow
                    $objReportInfo | fl 

                }
                #Write results to report
                if($intNumNewEntry -gt 0)
                {
                    "******************* New Entries (Microsoft) ************************" | out-file $LogFile -Append ascii
                    $arrNewBinaries | sort-object -Property Company | ft -Property Entry,"Image Path",Signer,"Launch String",Company -Force | out-file $LogFile -Append ascii
                }
                if($intNumNewEntryUnsigned -gt 0)
                {
                    "******************* New Entries Unsigned (Microsoft) ************************" | out-file $LogFile -Append ascii
                    $arrNewBinariesUnsigned | sort-object -Property Company | ft -Property Entry,"Image Path",Signer,"Launch String",Company -Force | out-file $LogFile -Append ascii
                }
                if($intNumNewEntryNonMS -gt 0)
                {
                    "************* New Entries (Non-Microsoft) ************"  | out-file $LogFile -Append ascii
                    $arrNewBinariesNonMS | sort-object -Property Company | ft -Property Entry,"Image Path",Signer,"Launch String",Company -Force | out-file $LogFile -Append ascii
                }
                if($intNumNewEntryNonMSUnsigned -gt 0)
                {
                    "************* New Entries Unsigned (Non-Microsoft) ************" | out-file $LogFile -Append ascii
                    $arrNewBinariesNonMSUnsigned | sort-object -Property Company | ft -Property Entry,"Image Path",Signer,"Launch String",Company -Force | out-file $LogFile -Append ascii
                }
                if($intNumHashDiff -gt 0)
                {
                    "*************** Image with new hash ******************" | out-file $LogFile -Append ascii
                    $arrNewHashes | sort-object -Property Company | ft -Property Entry,"Image Path",Signer,"Launch String",Company -Force | out-file $LogFile -Append ascii
                }
                "******************************************************" | out-file $LogFile -Append ascii
                $objReportInfo | fl | out-file $LogFile -Append ascii
                if($bolNewBinaries -or $bolHashDiff)
                {
                    if($Analyze)
                    {
                        #Remove any lines for the same boot to remove any duplicates
                        $CSVNewAutorunsFile = Import-Csv $TotalAutorunsFile
                        $CSVNewAutorunsFile  | ? { $_."Boot Date" -notcontains $LastBoottime }  | Export-Csv $TotalAutorunsFile -NoTypeInformation
                    }
                }
                #Add all new files in to a new CSV
                if($bolNewBinaries)
                {
                    if($bolNewBinariesNonMSUnsigned)
                    {
                        $arrNewBinariesNonMSUnsigned | Export-Csv -Path $NewAutorunsFile -NoTypeInformation -Append
                        if($Analyze)
                        {
                            $arrNewBinariesNonMSUnsigned | Export-Csv -Path $TotalAutorunsFile -NoTypeInformation -Append
                        }
                    }
                    if($bolNewBinariesNonMS)
                    {           
                        $arrNewBinariesNonMS | Export-Csv -Path $NewAutorunsFile -NoTypeInformation -Append
                        if($Analyze)
                        {
                            $arrNewBinariesNonMS | Export-Csv -Path $TotalAutorunsFile -NoTypeInformation -Append
                        }
                    }
                    if($bolNewBinariesUnsigned)
                    {           
                        $arrNewBinariesUnsigned| Export-Csv -Path $NewAutorunsFile -NoTypeInformation -Append
                        if($Analyze)
                        {
                            $arrNewBinariesUnsigned| Export-Csv -Path $TotalAutorunsFile -NoTypeInformation -Append
                        }
                    }
                    if($bolNewMSSigned)
                    {           
                        $arrNewBinaries| Export-Csv -Path $NewAutorunsFile -NoTypeInformation -Append
                        if($Analyze)
                        {
                            $arrNewBinaries| Export-Csv -Path $TotalAutorunsFile -NoTypeInformation -Append
                        }
                    }
                } 
                # Add all files with new hash to file
                if($bolHashDiff)
                {
                    #Write New Hashed files to CSV
                    $arrNewHashes | Export-Csv -Path $NewAutorunsFile -NoTypeInformation -Append
                    if($Analyze)
                    {
                        $arrNewHashes | Export-Csv -Path $TotalAutorunsFile -NoTypeInformation -Append
                    }
                }

                #Creating Notifications for different type of reports
                if($bolNewBinaries)
                {
                    if($bolNewBinariesNonMSUnsigned)
                    {
                        $strMessage = "New Unsigned Non-MS binaries added to Autoruns!`nNumber of new unsigned Non-MS autoruns: $intNumNewEntryNonMSUnsigned"
                        if(!($SystemCheck))
                        {
                            $ReportName = "Window"
                            $bolSigned = $false
                            RunNotificationIcon "Shield" "Error" "Verify Autoruns: $(get-date)" "Verify Autoruns - New Unsigned Files" "Unsigned files added to autoruns!`n$intNumNewEntryNonMSUnsigned Unsigned Non-MS files added." $strMessage $ReportName $LogFile $bolSigned $NewAutorunsFile "Verify Autoruns - New Image File" $objReportInfo $strSigCheckEXE $bolNewBinariesNonMSUnsigned $bolHashDiff $false $strLastBootCSV
                        }
                    }
                    #Else if Signed Binaries
                    else
                    {
                        if($bolNewBinariesNonMS)
                        {
                            $strMessage = "New Non-MS binaries added to Autoruns!`nNumber of new Non-MS autoruns: $intNumNewEntryNonMS"
                            if(!($SystemCheck))
                            {
                                $ReportName = "Window"
                                $bolSigned = $true
                                RunNotificationIcon "Shield" "Warning" "Verify Autoruns: $(get-date)" "Verify Autoruns - New Image File" "Non MS files added to autoruns!`n$intNumNewEntryNonMS Non-MS files added." $strMessage $ReportName $LogFile $bolSigned $NewAutorunsFile "Verify Autoruns - New Image File" $objReportInfo $strSigCheckEXE $bolNewBinariesNonMS $bolHashDiff $false $strLastBootCSV
                            }
                        }
                        else
                        {
                            if($bolNewBinariesUnsigned)
                            {
                                $strMessage = "New Unsigned MS binaries added to Autoruns!`nNumber of new Unsigned MS autoruns: $intNumNewEntryUnsigned"
                                if(!($SystemCheck))
                                {
                                    $ReportName = "Window"
                                    $bolSigned = $false
                                    RunNotificationIcon "Shield" "Info" "Verify Autoruns: $(get-date)" "Verify Autoruns - New Image File" "Unsigned MS files added to autoruns!`n$intNumNewEntryUnsigned Unsigned MS files added." $strMessage $ReportName $LogFile $bolSigned $NewAutorunsFile "Verify Autoruns - New Image File" $objReportInfo $strSigCheckEXE $bolNewBinariesNonMS $bolHashDiff $false $strLastBootCSV
                                }
                            }
                            else
                            {
                                $strMessage = "New MS binaries added to Autoruns!`nNumber of new MS autoruns: $intNumNewEntry"
                                if(!($SystemCheck))
                                {                                
                                    $ReportName = "Window"
                                    $bolSigned = $true
                                    RunNotificationIcon "Shield" "Info" "Verify Autoruns: $(get-date)" "Verify Autoruns - New Image File" "MS files added to autoruns!`n$intNumNewEntry MS files added." $strMessage $ReportName $LogFile $bolSigned $NewAutorunsFile "Verify Autoruns - New Image File" $objReportInfo $strSigCheckEXE $bolNewBinariesNonMS $bolHashDiff $false $strLastBootCSV
                                }
                            }
                        }
                    }
                }
                else
                {
                    if($bolHashDiff)
                    {
                        if($bolNewUnSignedHash)
                        {
                            $strMessage = "Unsigned Binaries have new hashes!`nNumber of images with changed hash: $intNumHashDiff"
                            if(!($SystemCheck))
                            {                            
                                "Unsigned Binaries have new hashes!" | out-file $LogFile -Append ascii
                                $ReportName = "Report Windows"
                                $bolSigned = $false
                                RunNotificationIcon "Shield" "Warning" "Verify Autoruns: $(get-date)" "Verify Autoruns - Unsigned File Has New Hash" "Unsigned Binaries with new hashes!`n$intNumHashDiff unsigned files with new hashes added." $strMessage $ReportName $LogFile $bolSigned $NewAutorunsFile "Verify Autoruns - Unsigned File Has New Hash" $objReportInfo $strSigCheckEXE $bolNewBinariesNonMS $bolHashDiff $false $strLastBootCSV
                            }
                        }
                        else
                        {
                            $strMessage = "Binaries have new hashes!`nNumber of images with changed hash: $intNumHashDiff"
                            if(!($SystemCheck))
                            {
                                $ReportName = "Report Windows"
                                $bolSigned = $true
                                RunNotificationIcon "Shield" "Info" "Verify Autoruns: $(get-date)" "Verify Autoruns - File Has New Hash" "Binaries with new hashes!`n$intNumHashDiff files with new hashes added." $strMessage $ReportName $LogFile $bolSigned $NewAutorunsFile "Verify Autoruns - File Has New Hash" $objReportInfo $strSigCheckEXE $bolNewBinariesNonMS $bolHashDiff $false $strLastBootCSV
                            }
                        }
                    }
                    else
                    {
                        #if Noticfication is forced run notification icon
                        if($NotificationIcon)
                        {
                            $strMessage = "No changes found."
                            $ReportName = "Report Windows"
                            $bolSigned = $true
                            RunNotificationIcon "Shield" "Info" "Verify Autoruns: $(get-date)" "Verify Autoruns - No changes" "No changes found." $strMessage $ReportName $LogFile $bolSigned $NewAutorunsFile "Verify Autoruns - No changes" $objReportInfo $strSigCheckEXE $false $false $true $strLastBootCSV
                        }
                    }
                }


            }
            else
            {
                #Prompt to screen
                if($Prompt)
                {
                    Write-Host "Could not get previous boot date" -ForegroundColor Red
                }
               "Could not get previous boot date" | out-file $LogFile -Append ascii
            }
            if($SystemCheck)
            {
                if($Offline)
                {
                    $VTCheckInputCSV = $LogPath + "\VTInput.csv"
                    if(Test-Path($VTCheckInputCSV))
                    {
                        Remove-Item $VTCheckInputCSV -Force 
                    }
                    #Build input file for SigCheck
                    $arrVTCheckUniques = New-Object System.Collections.ArrayList
                    $arrVTCheck = New-Object System.Collections.ArrayList
                    $arrImportFilesToCheck = import-csv $strLastBootCSV
                    #If the file got a hash it exist on the disk otherwise sihcheck can't check it
                    $arrFilesToCheck = $arrImportFilesToCheck | where "SHA-256" -gt "" | select -Unique "Image Path"
                    Foreach($UniqObj in $arrFilesToCheck)
                    {

                        [void]$arrVTCheckUniques.add($($arrImportFilesToCheck | where "Image Path" -eq $UniqObj.'Image Path' | select -First 1))

                    }


                    Foreach ($image in $arrVTCheckUniques)
                    {
                        # Create object to store the new format that will be input to sigchek
                        $objCheckEntry = New-Object psObject | `
                        Add-Member NoteProperty "Path" $image."Image Path" -PassThru 
                        #Check if the Image is signed or not
                        $strSigner = $image.Signer
                        if($strSigner.Length -gt 11)
                        {
                            #Convert the strings in new columns that sigcheck use
                            if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
                            {
                                Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Signed"  
                            }
                            else
                            {
                                Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
                            }
                        }
                        else
                        {
                            Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
                        }
                        Add-Member NoteProperty -InputObject $objCheckEntry "Date" ""  
                        if($strSigner.Length -gt 11)
                        {
                            #Convert the strings in new columns that sigcheck use
                            if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
                            {
                                Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Verified) ","")  
                            }
                            else
                            {
                                Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Not verified) ","")  
                            }
                        }
                        else
                        {
                            Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" ""  
                        }
                        Add-Member NoteProperty -InputObject $objCheckEntry "Company" $image.Company 
                        Add-Member NoteProperty -InputObject $objCheckEntry "Description" $image.Description  
                        Add-Member NoteProperty -InputObject $objCheckEntry "Product" $image.Description 
                        Add-Member NoteProperty -InputObject $objCheckEntry "Product Version" $image.Version 
                        Add-Member NoteProperty -InputObject $objCheckEntry "File Version" $image.Version 
                        Add-Member NoteProperty -InputObject $objCheckEntry "Machine Type" ""  
                        Add-Member NoteProperty -InputObject $objCheckEntry "MD5" $image."MD5"  
                        Add-Member NoteProperty -InputObject $objCheckEntry "SHA1" $image."SHA-1"  
                        Add-Member NoteProperty -InputObject $objCheckEntry "PESHA1" $image."PESHA-1"  
                        Add-Member NoteProperty -InputObject $objCheckEntry "PESHA256" $image."PESHA-256"  
                        Add-Member NoteProperty -InputObject $objCheckEntry "SHA256" $image."SHA-256"  
                        Add-Member NoteProperty -InputObject $objCheckEntry "IMP" $image."IMP"  
                        [void]$arrVTCheck.Add($objCheckEntry)
                    }

                    # Create a CSV file that SigCheck can use
                    $arrVTCheck | Export-Csv -Path $VTCheckInputCSV -NoTypeInformation -Force
                    $file = (Get-Content $VTCheckInputCSV )
                    $file[0] = $file[0].Replace("$([char]34)","")
                    $file | Set-Content $VTCheckInputCSV -Force
                    Write-Host "`nOutput saved at: $VTCheckInputCSV" 
                    Write-Host "`nRun the following command on a internet connected system:`n`nSigcheck.exe -o -v VTInput.csv`n"
                }
                else
                {
                
	                Write-Host "***********************************************************" -ForegroundColor Red
	                Write-Host "*********** Connecting to Virus Total (Internet) **********" -ForegroundColor Red
	                Write-Host "***********************************************************" -ForegroundColor Red
	                $a = Read-Host "Do you want to continue? Press Y[Yes] or N[NO]:"
	                If (!($a -eq "Y"))
	                {
		                Exit
	                }
                    if(Test-Path $strSigCheckEXE)
                    {
                        # Verify that it is at least version 2.50 and above of autorunsc.exe
                        if((gci $strSigCheckEXE).VersionInfo.FileVersion -ge "2.50")
                        {
                            $VTCheckInputCSV = $env:temp + "\VTInput.csv"
                            if(Test-Path($VTCheckInputCSV))
                            {
                                Remove-Item $VTCheckInputCSV -Force 
                            }
                            #Build input file for SigCheck
                            $arrVTCheckUniques = New-Object System.Collections.ArrayList
                            $arrVTCheck = New-Object System.Collections.ArrayList
                            $arrImportFilesToCheck = import-csv $strLastBootCSV
                            #If the file got a hash it exist on the disk otherwise sihcheck can't check it
                            $arrFilesToCheck = $arrImportFilesToCheck | where "SHA-256" -gt "" | select -Unique "Image Path"
                            Foreach($UniqObj in $arrFilesToCheck)
                            {

                                [void]$arrVTCheckUniques.add($($arrImportFilesToCheck | where "Image Path" -eq $UniqObj.'Image Path' | select -First 1))

                            }


                            Foreach ($image in $arrVTCheckUniques)
                            {
                                # Create object to store the new format that will be input to sigchek
                                $objCheckEntry = New-Object psObject | `
                                Add-Member NoteProperty "Path" $image."Image Path" -PassThru 
                                #Check if the Image is signed or not
                                $strSigner = $image.Signer
                                if($strSigner.Length -gt 11)
                                {
                                    #Convert the strings in new columns that sigcheck use
                                    if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
                                    {
                                        Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Signed"  
                                    }
                                    else
                                    {
                                        Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
                                    }
                                }
                                else
                                {
                                    Add-Member NoteProperty -InputObject $objCheckEntry "Verified" "Unsigned"  
                                }
                                Add-Member NoteProperty -InputObject $objCheckEntry "Date" ""  
                                if($strSigner.Length -gt 11)
                                {
                                    #Convert the strings in new columns that sigcheck use
                                    if(($strSigner).Remove(11,(($strSigner).Length -11)) -match "(Verified)")
                                    {
                                        Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Verified) ","")  
                                    }
                                    else
                                    {
                                        Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" $strSigner.Replace("(Not verified) ","")  
                                    }
                                }
                                else
                                {
                                    Add-Member NoteProperty -InputObject $objCheckEntry "Publisher" ""  
                                }
                                Add-Member NoteProperty -InputObject $objCheckEntry "Company" $image.Company 
                                Add-Member NoteProperty -InputObject $objCheckEntry "Description" $image.Description  
                                Add-Member NoteProperty -InputObject $objCheckEntry "Product" $image.Description 
                                Add-Member NoteProperty -InputObject $objCheckEntry "Product Version" $image.Version 
                                Add-Member NoteProperty -InputObject $objCheckEntry "File Version" $image.Version 
                                Add-Member NoteProperty -InputObject $objCheckEntry "Machine Type" ""  
                                Add-Member NoteProperty -InputObject $objCheckEntry "MD5" $image."MD5"  
                                Add-Member NoteProperty -InputObject $objCheckEntry "SHA1" $image."SHA-1"  
                                Add-Member NoteProperty -InputObject $objCheckEntry "PESHA1" $image."PESHA-1"  
                                Add-Member NoteProperty -InputObject $objCheckEntry "PESHA256" $image."PESHA-256"  
                                Add-Member NoteProperty -InputObject $objCheckEntry "SHA256" $image."SHA-256"  
                                Add-Member NoteProperty -InputObject $objCheckEntry "IMP" $image."IMP"  
                                [void]$arrVTCheck.Add($objCheckEntry)
                            }

                            # Create a CSV file that SigCheck can use
                            $arrVTCheck | Export-Csv -Path $VTCheckInputCSV -NoTypeInformation -Force
                            $file = (Get-Content $VTCheckInputCSV )
                            $file[0] = $file[0].Replace("$([char]34)","")
                            $file | Set-Content $VTCheckInputCSV -Force

                            #Define an out file from SigCheck
                            $strSigCheckWithVTResult = $env:temp + "\1VTCheck.csv"
                            if(Test-Path($strSigCheckWithVTResult))
                            {
                            Remove-Item $strSigCheckWithVTResult -Force 
                            }

                            $CMD =  "cmd"

                            $arg1 =  "/c"

                            $arg2 =  $strSigCheckEXE

                            $arg3 =  "/accepteula"

                            $arg4 =  "-o"

                            $arg5 =  "-v"

                            $arg6 =  $VTCheckInputCSV

                            $arg7 =  ">"

                            $arg8 = $strSigCheckWithVTResult

                            #Execute Sigcheck and save to CSV file
                            & $CMD $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8

[xml]$VTXAML =@"
<Window x:Class="Verify.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" Title="Verify Autoruns - Virus Total Check" WindowStartupLocation = "CenterScreen"
        Width = "750" Height = "380" ShowInTaskbar = "False" ResizeMode="NoResize" WindowStyle="ToolWindow"  Background="{DynamicResource {x:Static SystemColors.ControlBrushKey}}">
    <Grid>
        <StackPanel Orientation="Vertical" HorizontalAlignment="Center">
            <Label x:Name="lblSummary" Content="Virust Total Check Result" Width="200" Margin="05,0,00,00" HorizontalAlignment="Left" />
            <Grid>
                <DataGrid Name="dg_Log" Margin="2,2,2,2" Width="700" ScrollViewer.HorizontalScrollBarVisibility="Auto" Height="260"  >
                    <DataGrid.Columns>
                        <DataGridTextColumn x:Name="colFile" Header="File" Binding="{Binding Path}" Width="120"  IsReadOnly="True"/>
                        <DataGridTextColumn x:Name="colSigner" Header="Signer" Binding="{Binding Publisher}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn x:Name="colCompany" Header="Company" Binding="{Binding Company}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn x:Name="colVersion" Header="Version" Binding="{Binding 'File Version'}" Width="120" IsReadOnly="True" />
                        <DataGridTextColumn x:Name="colVTDetection" Header="VT Detection" Binding="{Binding 'VT Detection'}" Width="120" IsReadOnly="True" SortDirection="Descending" />
                        <DataGridTextColumn x:Name="colVTLink" Header="VT Link" Binding="{Binding 'VT Link'}" Width="120" IsReadOnly="True" />
                    </DataGrid.Columns>
                </DataGrid>
            </Grid>
            <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="00,10,00,00">
                <Button x:Name="btnClose" Content="Close" Margin="10,00,00,00" Width="50" Height="20"/>
            </StackPanel>
        </StackPanel>

    </Grid>
</Window>

"@

                            $VTXAML.Window.RemoveAttribute("x:Class") 

                            $reader=(New-Object System.Xml.XmlNodeReader $VTXAML)
                            $VerifyVTGui=[Windows.Markup.XamlReader]::Load( $reader )
                            $btnClose = $VerifyVTGui.FindName("btnClose")
                            $dg_Log = $VerifyVTGui.FindName("dg_Log")
                            $colVTDetection = $VerifyVTGui.FindName("colVTDetection")

                            if(Test-Path($strSigCheckWithVTResult))
                            {
                            $sigs = import-csv $strSigCheckWithVTResult

                            Foreach ($re in $sigs)
                            {
    
                                [void]$dg_Log.AddChild($re)
                            }
 
                            }



                            $btnClose.add_Click(
                            {
                            $VerifyVTGui.Close()
                            })

                            [void]$VerifyVTGui.ShowDialog()
                            $VerifyVTGui.Window.Activate()
                        }
                        else
                        {
                            Write-Output "To old version of $strSigCheckEXE."
                        }#End if SigCheck has right version
                    }
                    else
                    {
                        Write-Output "Could not find $strSigCheckEXE."
                    } #End if SigCheck Exist
            
                }# End if Offline
            } # End If SystemCheck
        } # End if Current Report Exist
        else
        {
            Write-Output "Could not import last autoruns file: $strLastBootCSV. Try re-run with -Analyze parameter to create a new file."
            #Promt to screen if boolean bolPrompt is true
            if($Prompt)
            {
                Write-Host "Could not import last autoruns file: $strLastBootCSV. Try re-run with -Analyze parameter to create a new file." -ForegroundColor red
            }
            #Write to report
            "Could not import last autoruns file: $strLastBootCSV. Try re-run with -Analyze parameter to create a new file." | out-file $LogFile -Append ascii
        }

    }
    End
    {
        #Prompt to screen
        if($Prompt)
        {
            Write-Output "Done"
        }
        "Done" | out-file $LogFile -Append ascii
    }
