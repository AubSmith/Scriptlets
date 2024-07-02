<#
 	.SYNOPSIS
        This script outputs a breakdown of the logon process.
		
    .DESCRIPTION
        This script gives an insight to the logon process phases.
        Each phase described have a column for duration in seconds, start and end time
        of the phase, and interim delay which is the time that passed between the
        end of one phase and the start of the one that comes after.
		
	.PARAMETER  <UserName <string[]>
		Specifies the user name on which the script runs. The default is the user who runs the script.
		
	.PARAMETER	<UserDomain <string[]>
		Specifies the domain name of the user on which the script runs. The default is the domain name of the user who runs the script.
		
	.PARAMETER  <CUDesktopLoadTime>
		Specifies the duration of the Shell phase, can be used with ControlUp as passed argument.
		
    .LINK
        For more information refer to:
            http://www.controlup.com

    .EXAMPLE
        C:\PS> Get-LogonDurationAnalysis -UserName Rick
		
		Gets analysis of the logon process for the user 'Rick' in the current domain.
#>

function Get-LogonDurationAnalysis {

param (
    [Parameter(Mandatory=$false)]
    [Alias('User')]
    [String]
    $Username = $env:USERNAME,
    [Parameter(Mandatory=$false)] 
    [Alias('Domain')]
    [String]
    $UserDomain = $env:USERDOMAIN,
    [int]
    $CUDesktopLoadTime
    )
    begin {
    function Get-PhaseEvent {
    
    param (
        [ValidateNotNullOrEmpty()]
        [String]
        $PhaseName,
        [ValidateNotNullOrEmpty()]
        [String]
        $StartProvider,
        [ValidateNotNullOrEmpty()]
        [String]
        $EndProvider,
        [ValidateNotNullOrEmpty()]
        [String]
        $StartXPath,
        [ValidateNotNullOrEmpty()]
        [String]
        $EndXPath,
        [int]
        $CUAddition
        )

        try {
            $StartEvent = Get-WinEvent -MaxEvents 1 -ProviderName $StartProvider -FilterXPath $StartXPath -ErrorAction Stop
            if ($StartProvider -eq 'Microsoft-Windows-Security-Auditing' -and $EndProvider -eq 'Microsoft-Windows-Security-Auditing') {
                $EndEvent = Get-WinEvent -MaxEvents 1 -ProviderName $EndProvider -FilterXPath ("{0}{1}" -f $EndXPath,@"
and *[EventData[Data[@Name='ProcessId'] 
and (Data=`'$($StartEvent.Properties[4].Value)`')]] 
"@) # Responsible to match the process termination event to the exact process
            }
            elseif ($CUAddition) {
                Set-Variable -Name EndEvent -Value ($StartEvent | Select-Object -ExpandProperty TimeCreated).AddSeconds($CUAddition)
            }

            else {
                $EndEvent = Get-WinEvent -MaxEvents 1 -ProviderName $EndProvider -FilterXPath $EndXPath
            }
       }

        catch {
            if ($PhaseName -ne 'Citrix Profile Mgmt') {
                if ($StartProvider -eq 'Microsoft-Windows-Security-Auditing' -or $EndProvider -eq 'Microsoft-Windows-Security-Auditing' ) {
                    "Could not find $PhaseName events (requires audit process tracking)"
                }
                else {
                    "Could not find $PhaseName events"
                }
                Return
            }
        }

        $EventInfo = @{}

        if ($EndEvent) {
            if ((($EndEvent).GetType()).Name -eq 'DateTime') {
                $Duration = New-TimeSpan -Start $StartEvent.TimeCreated -End $EndEvent
                $EventInfo.EndTime = $EndEvent
            }
            else {
                $Duration = New-TimeSpan -Start $StartEvent.TimeCreated -End $EndEvent.TimeCreated
                $EventInfo.EndTime = $EndEvent.TimeCreated 
            }
        }
        $Script:EventProperties = $StartEvent.Properties
        $EventInfo.PhaseName = $PhaseName
        $EventInfo.StartTime = $StartEvent.TimeCreated
        $EventInfo.Duration = $Duration.TotalSeconds

        $PSObject = New-Object -TypeName PSObject -Property $EventInfo

        if ($EventInfo.Duration) {
            $Script:Output += $PSObject
        }
    }

        $Script:Output = @()

        try {
        $LogonEvent = Get-WinEvent -MaxEvents 1 -ProviderName Microsoft-Windows-Security-Auditing -FilterXPath @"
        *[System[(EventID='4624')]] 
        and *[EventData[Data[@Name='TargetUserName'] 
        and (Data=`"$UserName`")]] 
        and *[EventData[Data[@Name='TargetDomainName'] 
        and (Data=`"$UserDomain`")]] 
        and *[EventData[Data[@Name='LogonType'] 
        and (Data=`"2`" or Data=`"10`" or Data=`"11`")]]
        and *[EventData[Data[@Name='ProcessName'] 
        and (Data=`"C:\Windows\System32\winlogon.exe`")]]
"@ -ErrorAction Stop
        }
        catch {
            Throw 'Could not find EventID 4624 (Successfully logged on event) in the Windows Security log.'
        }

        $Logon = New-Object -TypeName PSObject

        Add-Member -InputObject $Logon -MemberType NoteProperty -Name LogonTime -Value $LogonEvent.TimeCreated
        Add-Member -InputObject $Logon -MemberType NoteProperty -Name FormatTime -Value (Get-Date -Date $LogonEvent.TimeCreated -UFormat %r)
        Add-Member -InputObject $Logon -MemberType NoteProperty -Name LogonID -Value ($LogonEvent.Properties[7]).Value
        Add-Member -InputObject $Logon -MemberType NoteProperty -Name WinlogonPID -Value ($LogonEvent.Properties[16]).Value
        Add-Member -InputObject $Logon -MemberType NoteProperty -Name UserSID -Value ($LogonEvent.Properties[4]).Value

        $ISO8601Date = Get-Date -Date $Logon.LogonTime
        $ISO8601Date = $ISO8601Date.ToUniversalTime()
        $ISO8601Date = $ISO8601Date.ToString("s")

        $NPStartXpath = @"
        *[System[(EventID='4688')
        and TimeCreated[@SystemTime > '$ISO8601Date']]]
        and *[EventData[Data[@Name='ProcessId'] 
        and (Data=`'$($Logon.WinlogonPID)`')]] 
        and *[EventData[Data[@Name='NewProcessName'] 
        and (Data='C:\Windows\System32\mpnotify.exe')]] 
"@

        $NPEndXPath = @"
        *[System[(EventID='4689')
        and TimeCreated[@SystemTime > '$ISO8601Date']]]
        and *[EventData[Data[@Name='ProcessName'] 
        and (Data=`"C:\Windows\System32\mpnotify.exe`")]] 
"@

        $ProfStartXpath = @"
        *[System[(EventID='10')
        and TimeCreated[@SystemTime > '$ISO8601Date']]]
        and *[EventData[Data and (Data='$UserName')]]
"@

        $ProfEndXpath = @"
        *[System[(EventID='1')
        and  TimeCreated[@SystemTime>='$ISO8601Date']]]
        and *[System[Security[@UserID='$($Logon.UserSID)']]]
"@

        $UserProfStartXPath = @"
        *[System[(EventID='1')
        and  TimeCreated[@SystemTime>='$ISO8601Date']]]
        and *[System[Security[@UserID='$($Logon.UserSID)']]]
"@

        $UserProfEndXPath = @"
        *[System[(EventID='2')
        and  TimeCreated[@SystemTime>='$ISO8601Date']]]
        and *[System[Security[@UserID='$($Logon.UserSID)']]]
"@

        $GPStartXPath = @"
        *[System[(EventID='4001')
        and  TimeCreated[@SystemTime>='$ISO8601Date']]]
        and *[EventData[Data[@Name='PrincipalSamName'] 
        and (Data=`"$UserDomain\$UserName`")]] 
"@

        $GPEndXPath = @"
        *[System[(EventID='8001')
        and TimeCreated[@SystemTime > '$ISO8601Date']]]
        and *[EventData[Data[@Name='PrincipalSamName'] 
        and (Data=`"$UserDomain\$UserName`")]] 
"@

        $GPScriptStartXPath = @"
        *[System[(EventID='4018')
        and  TimeCreated[@SystemTime>='$ISO8601Date']]]
        and *[EventData[Data[@Name='PrincipalSamName'] 
        and (Data=`"$UserDomain\$UserName`")]] 
        and *[EventData[Data[@Name='ScriptType'] 
        and (Data='1')]]
"@

        $GPScriptEndXPath = @"
        *[System[(EventID='5018')
        and  TimeCreated[@SystemTime>='$ISO8601Date']]]
        and *[EventData[Data[@Name='PrincipalSamName'] 
        and (Data=`"$UserDomain\$UserName`")]] 
        and *[EventData[Data[@Name='ScriptType'] 
        and (Data='1')]]
"@

        $UserinitXPath = @"
        *[System[(EventID='4688')
        and TimeCreated[@SystemTime > '$ISO8601Date']]]
        and *[EventData[Data[@Name='ProcessId'] 
        and (Data=`'$($Logon.WinlogonPID)`')]] 
        and *[EventData[Data[@Name='NewProcessName'] 
        and (Data='C:\Windows\System32\userinit.exe')]] 
"@

        $ShellXPath = @"
        *[System[(EventID='4688')
        and TimeCreated[@SystemTime > '$ISO8601Date']]] 
        and *[EventData[Data[@Name='SubjectLogonId'] 
        and (Data=`'$($Logon.LogonID)`')]] 
        and *[EventData[Data[@Name='NewProcessName'] 
        and (Data=`"C:\Program Files (x86)\Citrix\system32\icast.exe`" or Data=`"C:\Windows\explorer.exe`")]]
"@

        $ExplorerXPath = @"
        *[System[(EventID='4688')
        and TimeCreated[@SystemTime > '$ISO8601Date']]] 
        and *[EventData[Data[@Name='SubjectLogonId'] 
        and (Data=`'$($Logon.LogonID)`')]] 
        and *[EventData[Data[@Name='NewProcessName'] 
        and (Data=`"C:\Windows\explorer.exe`")]]
"@
    }

    process {
        Get-PhaseEvent -PhaseName 'Network Providers' -StartProvider 'Microsoft-Windows-Security-Auditing' -EndProvider 'Microsoft-Windows-Security-Auditing' `
        -StartXPath $NPStartXpath -EndXPath $NPEndXPath

        if (Get-WinEvent -ListProvider 'Citrix Profile management' -ErrorAction SilentlyContinue) {

            Get-PhaseEvent -PhaseName 'Citrix Profile Mgmt' -StartProvider 'Citrix Profile management' -EndProvider 'Microsoft-Windows-User Profiles Service' `
            -StartXPath $ProfStartXpath -EndXPath $ProfEndXpath
        }

        Get-PhaseEvent -PhaseName 'User Profile' -StartProvider 'Microsoft-Windows-User Profiles Service' -EndProvider 'Microsoft-Windows-User Profiles Service' `
        -StartXPath $UserProfStartXPath -EndXPath $UserProfEndXPath

        Get-PhaseEvent -PhaseName 'Group Policy' -StartProvider 'Microsoft-Windows-GroupPolicy' -EndProvider 'Microsoft-Windows-GroupPolicy' `
        -StartXPath $GPStartXPath -EndXPath $GPEndXPath

        Get-PhaseEvent -PhaseName 'GP Scripts' -StartProvider 'Microsoft-Windows-GroupPolicy' -EndProvider 'Microsoft-Windows-GroupPolicy' `
        -StartXPath $GPScriptStartXPath -EndXPath $GPScriptEndXPath

        if ($Script:EventProperties[3].Value -eq $true) {
            if ($Script:Output[-1].PhaseName -eq 'GP Scripts') {
                $Script:Output[-1].PhaseName = 'GP Scripts (sync)'
            }
        }

        else {
            if ($Script:Output[-1].PhaseName -eq 'GP Scripts') {
                $Script:Output[-1].PhaseName = 'GP Scripts (async)'
            }
        }

        Get-PhaseEvent -PhaseName 'Pre-Shell (Userinit)' -StartProvider 'Microsoft-Windows-Security-Auditing' -EndProvider 'Microsoft-Windows-Security-Auditing' `
        -StartXPath $UserinitXPath -EndXPath $ShellXPath

        if ($CUDesktopLoadTime) {
        Get-PhaseEvent -PhaseName 'Shell' -StartProvider 'Microsoft-Windows-Security-Auditing' -StartXPath $ExplorerXPath -CUAddition $CUDesktopLoadTime
        }

        if ($Script:Output[-1].PhaseName -eq 'Shell' -or $Script:Output[-1].PhaseName -eq 'Pre-Shell (Userinit)') {
        $TotalDur = "{0:N1}" -f (New-TimeSpan -Start $Logon.LogonTime -End $Script:Output[-1].EndTime | Select-Object -ExpandProperty TotalSeconds) `
        + " seconds"
        }

        else
        {
        $TotalDur = 'N/A'
        }

        $Script:Output = $Script:Output | Sort-Object StartTime

        for($i=1;$i -le $Script:Output.length-1;$i++) {

            $Deltas = New-TimeSpan -Start $Script:Output[$i-1].EndTime -End $Script:Output[$i].StartTime
            $Script:Output[$i] | Add-Member -MemberType NoteProperty -Name TimeDelta -Value $Deltas -Force
        }

        $Deltas = New-TimeSpan -Start $Logon.LogonTime -End $Script:Output[0].StartTime
        $Script:Output[0] | Add-Member -MemberType NoteProperty -Name TimeDelta -Value $Deltas -Force
    }

    end {
        Write-Host "User name:`t $UserName `
Logon Time:`t $($Logon.FormatTime) `
Logon Duration:`t $TotalDur"

        $Format = @{Expression={$_.PhaseName};Label="Logon Phase"}, `
        @{Expression={'{0:N1}' -f $_.Duration};Label="Duration (s)"}, `
        @{Expression={'{0:hh:mm:ss.f}' -f $_.StartTime};Label="Start Time"}, `
        @{Expression={'{0:hh:mm:ss.f}' -f $_.EndTime};Label="End Time"}, `
        @{Expression={'{0:N1}' -f ($_.TimeDelta | Select-Object -ExpandProperty TotalSeconds)};Label="Interim Delay"}
        $Script:Output | Format-Table $Format -AutoSize

        Write-Host "Only synchronous scripts affect logon duration"
    }
}