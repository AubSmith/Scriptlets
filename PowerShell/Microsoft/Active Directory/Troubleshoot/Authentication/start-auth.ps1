<#
   ***Directory Services Authentication Scripts***

   Requires: PowerShell V4(Supported from Windows 8.1/Windows Server 2012 R2)

   Last Updated: 06/04/2022

   Version: 4.6
#>

[cmdletbinding()]
param(
[switch]$accepteula,
[switch]$v,
[switch]$nonet,
[string]$containerId,
[switch]$version)



[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')

function ShowEULAPopup($mode)
{
    $EULA = New-Object -TypeName System.Windows.Forms.Form
    $richTextBox1 = New-Object System.Windows.Forms.RichTextBox
    $btnAcknowledge = New-Object System.Windows.Forms.Button
    $btnCancel = New-Object System.Windows.Forms.Button

    $EULA.SuspendLayout()
    $EULA.Name = "EULA"
    $EULA.Text = "Microsoft Diagnostic Tools End User License Agreement"

    $richTextBox1.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
    $richTextBox1.Location = New-Object System.Drawing.Point(12,12)
    $richTextBox1.Name = "richTextBox1"
    $richTextBox1.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Vertical
    $richTextBox1.Size = New-Object System.Drawing.Size(776, 397)
    $richTextBox1.TabIndex = 0
    $richTextBox1.ReadOnly=$True
    $richTextBox1.Add_LinkClicked({Start-Process -FilePath $_.LinkText})
    $richTextBox1.Rtf = @"
{\rtf1\ansi\ansicpg1252\deff0\nouicompat{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Calibri;}{\f2\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue255;}
{\*\generator Riched20 10.0.19041}{\*\mmathPr\mdispDef1\mwrapIndent1440 }\viewkind4\uc1 
\pard\widctlpar\f0\fs19\lang1033 MICROSOFT SOFTWARE LICENSE TERMS\par
Microsoft Diagnostic Scripts and Utilities\par
\par
{\pict{\*\picprop}\wmetafile8\picw26\pich26\picwgoal32000\pichgoal15 
0100090000035000000000002700000000000400000003010800050000000b0200000000050000
000c0202000200030000001e000400000007010400040000000701040027000000410b2000cc00
010001000000000001000100000000002800000001000000010000000100010000000000000000
000000000000000000000000000000000000000000ffffff00000000ff040000002701ffff0300
00000000
}These license terms are an agreement between you and Microsoft Corporation (or one of its affiliates). IF YOU COMPLY WITH THESE LICENSE TERMS, YOU HAVE THE RIGHTS BELOW. BY USING THE SOFTWARE, YOU ACCEPT THESE TERMS.\par
{\pict{\*\picprop}\wmetafile8\picw26\pich26\picwgoal32000\pichgoal15 
0100090000035000000000002700000000000400000003010800050000000b0200000000050000
000c0202000200030000001e000400000007010400040000000701040027000000410b2000cc00
010001000000000001000100000000002800000001000000010000000100010000000000000000
000000000000000000000000000000000000000000ffffff00000000ff040000002701ffff0300
00000000
}\par
\pard 
{\pntext\f0 1.\tab}{\*\pn\pnlvlbody\pnf0\pnindent0\pnstart1\pndec{\pntxta.}}
\fi-360\li360 INSTALLATION AND USE RIGHTS. Subject to the terms and restrictions set forth in this license, Microsoft Corporation (\ldblquote Microsoft\rdblquote ) grants you (\ldblquote Customer\rdblquote  or \ldblquote you\rdblquote ) a non-exclusive, non-assignable, fully paid-up license to use and reproduce the script or utility provided under this license (the "Software"), solely for Customer\rquote s internal business purposes, to help Microsoft troubleshoot issues with one or more Microsoft products, provided that such license to the Software does not include any rights to other Microsoft technologies (such as products or services). \ldblquote Use\rdblquote  means to copy, install, execute, access, display, run or otherwise interact with the Software. \par
\pard\widctlpar\par
\pard\widctlpar\li360 You may not sublicense the Software or any use of it through distribution, network access, or otherwise. Microsoft reserves all other rights not expressly granted herein, whether by implication, estoppel or otherwise. You may not reverse engineer, decompile or disassemble the Software, or otherwise attempt to derive the source code for the Software, except and to the extent required by third party licensing terms governing use of certain open source components that may be included in the Software, or remove, minimize, block, or modify any notices of Microsoft or its suppliers in the Software. Neither you nor your representatives may use the Software provided hereunder: (i) in a way prohibited by law, regulation, governmental order or decree; (ii) to violate the rights of others; (iii) to try to gain unauthorized access to or disrupt any service, device, data, account or network; (iv) to distribute spam or malware; (v) in a way that could harm Microsoft\rquote s IT systems or impair anyone else\rquote s use of them; (vi) in any application or situation where use of the Software could lead to the death or serious bodily injury of any person, or to physical or environmental damage; or (vii) to assist, encourage or enable anyone to do any of the above.\par
\par
\pard\widctlpar\fi-360\li360 2.\tab DATA. Customer owns all rights to data that it may elect to share with Microsoft through using the Software. You can learn more about data collection and use in the help documentation and the privacy statement at {{\field{\*\fldinst{HYPERLINK https://aka.ms/privacy }}{\fldrslt{https://aka.ms/privacy\ul0\cf0}}}}\f0\fs19 . Your use of the Software operates as your consent to these practices.\par
\pard\widctlpar\par
\pard\widctlpar\fi-360\li360 3.\tab FEEDBACK. If you give feedback about the Software to Microsoft, you grant to Microsoft, without charge, the right to use, share and commercialize your feedback in any way and for any purpose.\~ You will not provide any feedback that is subject to a license that would require Microsoft to license its software or documentation to third parties due to Microsoft including your feedback in such software or documentation. \par
\pard\widctlpar\par
\pard\widctlpar\fi-360\li360 4.\tab EXPORT RESTRICTIONS. Customer must comply with all domestic and international export laws and regulations that apply to the Software, which include restrictions on destinations, end users, and end use. For further information on export restrictions, visit {{\field{\*\fldinst{HYPERLINK https://aka.ms/exporting }}{\fldrslt{https://aka.ms/exporting\ul0\cf0}}}}\f0\fs19 .\par
\pard\widctlpar\par
\pard\widctlpar\fi-360\li360\qj 5.\tab REPRESENTATIONS AND WARRANTIES. Customer will comply with all applicable laws under this agreement, including in the delivery and use of all data. Customer or a designee agreeing to these terms on behalf of an entity represents and warrants that it (i) has the full power and authority to enter into and perform its obligations under this agreement, (ii) has full power and authority to bind its affiliates or organization to the terms of this agreement, and (iii) will secure the permission of the other party prior to providing any source code in a manner that would subject the other party\rquote s intellectual property to any other license terms or require the other party to distribute source code to any of its technologies.\par
\pard\widctlpar\par
\pard\widctlpar\fi-360\li360\qj 6.\tab DISCLAIMER OF WARRANTY. THE SOFTWARE IS PROVIDED \ldblquote AS IS,\rdblquote  WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL MICROSOFT OR ITS LICENSORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THE SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\par
\pard\widctlpar\qj\par
\pard\widctlpar\fi-360\li360\qj 7.\tab LIMITATION ON AND EXCLUSION OF DAMAGES. IF YOU HAVE ANY BASIS FOR RECOVERING DAMAGES DESPITE THE PRECEDING DISCLAIMER OF WARRANTY, YOU CAN RECOVER FROM MICROSOFT AND ITS SUPPLIERS ONLY DIRECT DAMAGES UP TO U.S. $5.00. YOU CANNOT RECOVER ANY OTHER DAMAGES, INCLUDING CONSEQUENTIAL, LOST PROFITS, SPECIAL, INDIRECT, OR INCIDENTAL DAMAGES. This limitation applies to (i) anything related to the Software, services, content (including code) on third party Internet sites, or third party applications; and (ii) claims for breach of contract, warranty, guarantee, or condition; strict liability, negligence, or other tort; or any other claim; in each case to the extent permitted by applicable law. It also applies even if Microsoft knew or should have known about the possibility of the damages. The above limitation or exclusion may not apply to you because your state, province, or country may not allow the exclusion or limitation of incidental, consequential, or other damages.\par
\pard\widctlpar\par
\pard\widctlpar\fi-360\li360 8.\tab BINDING ARBITRATION AND CLASS ACTION WAIVER. This section applies if you live in (or, if a business, your principal place of business is in) the United States.  If you and Microsoft have a dispute, you and Microsoft agree to try for 60 days to resolve it informally. If you and Microsoft can\rquote t, you and Microsoft agree to binding individual arbitration before the American Arbitration Association under the Federal Arbitration Act (\ldblquote FAA\rdblquote ), and not to sue in court in front of a judge or jury. Instead, a neutral arbitrator will decide. Class action lawsuits, class-wide arbitrations, private attorney-general actions, and any other proceeding where someone acts in a representative capacity are not allowed; nor is combining individual proceedings without the consent of all parties. The complete Arbitration Agreement contains more terms and is at {{\field{\*\fldinst{HYPERLINK https://aka.ms/arb-agreement-4 }}{\fldrslt{https://aka.ms/arb-agreement-4\ul0\cf0}}}}\f0\fs19 . You and Microsoft agree to these terms. \par
\pard\widctlpar\par
\pard\widctlpar\fi-360\li360 9.\tab LAW AND VENUE. If U.S. federal jurisdiction exists, you and Microsoft consent to exclusive jurisdiction and venue in the federal court in King County, Washington for all disputes heard in court (excluding arbitration). If not, you and Microsoft consent to exclusive jurisdiction and venue in the Superior Court of King County, Washington for all disputes heard in court (excluding arbitration).\par
\pard\widctlpar\par
\pard\widctlpar\fi-360\li360 10.\tab ENTIRE AGREEMENT. This agreement, and any other terms Microsoft may provide for supplements, updates, or third-party applications, is the entire agreement for the software.\par
\pard\sa200\sl276\slmult1\f1\fs22\lang9\par
\pard\f2\fs17\lang2057\par
}
"@
    $richTextBox1.BackColor = [System.Drawing.Color]::White
    $btnAcknowledge.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $btnAcknowledge.Location = New-Object System.Drawing.Point(544, 415)
    $btnAcknowledge.Name = "btnAcknowledge";
    $btnAcknowledge.Size = New-Object System.Drawing.Size(119, 23)
    $btnAcknowledge.TabIndex = 1
    $btnAcknowledge.Text = "Accept"
    $btnAcknowledge.UseVisualStyleBackColor = $True
    $btnAcknowledge.Add_Click({$EULA.DialogResult=[System.Windows.Forms.DialogResult]::Yes})

    $btnCancel.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $btnCancel.Location = New-Object System.Drawing.Point(669, 415)
    $btnCancel.Name = "btnCancel"
    $btnCancel.Size = New-Object System.Drawing.Size(119, 23)
    $btnCancel.TabIndex = 2
    if($mode -ne 0)
    {
	    $btnCancel.Text = "Close"
    }
    else
    {
	    $btnCancel.Text = "Decline"
    }
    $btnCancel.UseVisualStyleBackColor = $True
    $btnCancel.Add_Click({$EULA.DialogResult=[System.Windows.Forms.DialogResult]::No})

    $EULA.AutoScaleDimensions = New-Object System.Drawing.SizeF(6.0, 13.0)
    $EULA.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
    $EULA.ClientSize = New-Object System.Drawing.Size(800, 450)
    $EULA.Controls.Add($btnCancel)
    $EULA.Controls.Add($richTextBox1)
    if($mode -ne 0)
    {
	    $EULA.AcceptButton=$btnCancel
    }
    else
    {
        $EULA.Controls.Add($btnAcknowledge)
	    $EULA.AcceptButton=$btnAcknowledge
        $EULA.CancelButton=$btnCancel
    }
    $EULA.ResumeLayout($false)
    $EULA.Size = New-Object System.Drawing.Size(800, 650)

    Return ($EULA.ShowDialog())
}

function ShowEULAIfNeeded($toolName, $mode)
{
	$eulaRegPath = "HKCU:Software\Microsoft\CESDiagnosticTools"
	$eulaAccepted = "No"
	$eulaValue = $toolName + " EULA Accepted"
	if(Test-Path $eulaRegPath)
	{
		$eulaRegKey = Get-Item $eulaRegPath
		$eulaAccepted = $eulaRegKey.GetValue($eulaValue, "No")
	}
	else
	{
		$eulaRegKey = New-Item $eulaRegPath
	}
	if($mode -eq 2) # silent accept
	{
		$eulaAccepted = "Yes"
       		$ignore = New-ItemProperty -Path $eulaRegPath -Name $eulaValue -Value $eulaAccepted -PropertyType String -Force
	}
	else
	{
		if($eulaAccepted -eq "No")
		{
			$eulaAccepted = ShowEULAPopup($mode)
			if($eulaAccepted -eq [System.Windows.Forms.DialogResult]::Yes)
			{
	        		$eulaAccepted = "Yes"
	        		$ignore = New-ItemProperty -Path $eulaRegPath -Name $eulaValue -Value $eulaAccepted -PropertyType String -Force
			}
		}
	}
	return $eulaAccepted
}

function Invoke-Container {
    
    [Cmdletbinding(DefaultParameterSetName="Default")]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ContainerId,
        [switch]$Nano,
        [Parameter(ParameterSetName="PreTraceDir")]
        [switch]$PreTrace,
        [Parameter(ParameterSetName="AuthDir")]
        [switch]$AuthDir,
        [switch]$UseCmd,
        [switch]$Record,
        [switch]$Silent,
        [Parameter(Mandatory=$true)]
        [string]$Command
    )

    $Workingdir = "C:\AuthScripts"
    if($PreTrace){
        $Workingdir += "\authlogs\PreTraceLogs"
    }

    if($AuthDir){
        $Workingdir += "\authlogs"
    }

    Write-Verbose "Running Container command: $Command"
    if($Record){
        if($Nano){
            docker exec -u Administrator -w $Workingdir $ContainerId cmd /c "$Command" *>> $_CONTAINER_DIR\container-output.txt
        }
        elseif($UseCmd){
            docker exec -w $Workingdir $ContainerId cmd /c "$Command" *>> $_CONTAINER_DIR\container-output.txt
        }
        else {
            docker exec -w $Workingdir $ContainerId powershell -ExecutionPolicy Unrestricted "$Command" *>> $_CONTAINER_DIR\container-output.txt
        }    
    }
    elseif($Silent){
        if($Nano){
            docker exec -u Administrator -w $Workingdir $ContainerId cmd /c "$Command" *>> Out-Null
        }
        elseif($UseCmd) {
            docker exec -w $Workingdir $ContainerId cmd /c "$Command" *>> Out-Null
        }
        else{
            docker exec -w $Workingdir $ContainerId powershell -ExecutionPolicy Unrestricted "$Command" *>> Out-Null
        }
    }
    else {
        $Result = ""
        if($Nano){
            $Result = docker exec -u Administrator -w $Workingdir $ContainerId cmd /c "$Command"
        }
        elseif($UseCmd){
            $Result = docker exec -w $Workingdir $ContainerId cmd /c "$Command"
        }
        else {
            $Result = docker exec -w $Workingdir $ContainerId powershell -ExecutionPolicy Unrestricted "$Command"
        }   
        return $Result
    }
}

function Check-ContainerIsNano {
    param($ContainerId)
    
    # This command is finicky and cannot use a powershell variable for the command
    $ContainerBase = Invoke-Container -ContainerId $containerId -UseCmd -Command "reg query `"hklm\software\microsoft\windows nt\currentversion`" /v EditionID"
    Write-Verbose "Container Base: $ContainerBase"
    # We only check for nano server as it is the most restrictive
    if($ContainerBase -like "*Nano*"){
        return $true
    }
    else {
        return $false
    }
}


function Check-ContainsScripts {
    param(
        $ContainerId,
        [switch]$IsNano
    )

    if($IsNano){
        $Result = Invoke-Container -ContainerId $containerId -Nano -Command "if exist auth.wprp (echo true)"
        
        if($Result -eq "True"){
            
            $Result = Invoke-Container -ContainerId $containerId -Nano -Command "type auth.wprp"
            $Result = $Result[1]
            if(!$Result.Contains($_Authscriptver))
            {
                $InnerScriptVersion = $Result.Split(" ")[1].Split("=")[1].Trim("`"")
                Write-Host "$ContainerId Script Version mismatch" -ForegroundColor Yellow
                Write-Host "Container Host Version: $_Authscriptver" -ForegroundColor Yellow
                Write-Host "Container Version: $InnerScriptVersion" -ForegroundColor Yellow
                return $false
            }
            Out-File -FilePath $_CONTAINER_DIR\script-info.txt -InputObject "SCRIPT VERSION: $_Authscriptver"
            return $true
        }
        else {
            return $false
        }
    }
    else {
        $StartResult = Invoke-Container -ContainerId $containerId -Command "Test-Path start-auth.ps1"
        $StopResult = Invoke-Container -ContainerId $containerId -Command "Test-Path stop-auth.ps1"
        if($StartResult -eq "True" -and $StopResult -eq "True"){
            # Checking script version
			$InnerScriptVersion = Invoke-Container -ContainerId $containerId -Command ".\start-auth.ps1 -accepteula -version"
			if($InnerScriptVersion -ne $_Authscriptver){
				Write-Host "$ContainerId Script Version mismatch" -ForegroundColor Yellow
				Write-Host "Container Host Version: $_Authscriptver" -ForegroundColor Yellow
				Write-Host "Container Version: $InnerScriptVersion" -ForegroundColor Yellow
				return $false
			}
			else {
                Out-File -FilePath $_CONTAINER_DIR\script-info.txt -InputObject "SCRIPT VERSION: $_Authscriptver"
				return $true
			}
        }
        else {
			Write-Host "Container: $ContainerId missing tracing scripts!" -ForegroundColor Yellow
            return $false
        }
    }
}

function Check-GMSA {
	param($ContainerId)
	
	$CredentialString = docker inspect -f "{.HostConfig.SecurityOpt}" $ContainerId
	if($CredentialString -ne "[]"){
	Write-Verbose "GMSA Credential String: $CredentialString"	
		# We need to check if we have Test-ADServiceAccount
		if((Get-Command "Test-ADServiceAccount" -ErrorAction "SilentlyContinue") -ne $null)
			{
				$ServiceAccountName = $(docker inspect -f "{{ .Config.Hostname }}" $ContainerId)
				$Result = "START:`n`nRunning: Test-ADServiceAccount $ServiceAccountName`nResult:"
                
                try {
                    $Result += Test-ADServiceAccount -Identity $ServiceAccountName -Verbose -ErrorAction SilentlyContinue    
                }
				catch {
                    $Result += "Unable to find object with identity $containerId"
                }

                Out-File $_CONTAINER_DIR\gMSATest.txt -InputObject $Result
			}
	}
}

function Generate-WPRP{
    param($ContainerId)
    $Header = @"
<?xml version="1.0" encoding="utf-8"?>
<WindowsPerformanceRecorder Version="$_Authscriptver" Author="Microsoft Corporation" Copyright="Microsoft Corporation" Company="Microsoft Corporation">
  <Profiles>

"@
    $Footer = @"
  </Profiles>
</WindowsPerformanceRecorder>
"@


    $Netmon = "{2ED6006E-4729-4609-B423-3EE7BCD678EF}"

    $ProviderList = (("NGC", $NGC), 
     ("Biometric", $Biometric), 
     ("LSA", $LSA), 
     ("Ntlm_CredSSP", $Ntlm_CredSSP), 
     ("Kerberos", $Kerberos), 
     ("KDC", $KDC),
     ("SSL", $SSL),
     ("WebAuth", $WebAuth),
     ("Smartcard", $Smartcard),
     ("CredprovAuthui", $CredprovAuthui),
     ("SAM", $SAM),
     ("kernel", $Kernel),
     ("Netmon", $Netmon))

    # NOTE(will): Checking if Client SKU
    $ClientSKU = Invoke-Container -ContainerId $ContainerId -Nano -Command "reg query HKLM\SYSTEM\CurrentControlSet\Control\ProductOptions /v ProductType | findstr WinNT"
    if($ClientSKU -ne $null){
        $ProviderList.Add(("CryptNcryptDpapi", $CryptNcryptDpapi))
    }

    foreach($Provider in $ProviderList){
        $ProviderName = $Provider[0]
        $Header += @"
    <EventCollector Id="EventCollector$ProviderName" Name="EventCollector$ProviderName">
      <BufferSize Value="64" />
      <Buffers Value="4" />
    </EventCollector>

"@
    }

    $Header += "`n`n"

    # Starting on provider generation

    foreach($Provider in $ProviderList){
        $ProviderCount = 0
        $ProviderName = $Provider[0]

        foreach($ProviderItem in $Provider[1]){
            $ProviderParams = $ProviderItem.Split("!")
            $ProviderGuid = $ProviderParams[0].Replace("{",'').Replace("}",'')
            $ProviderFlags = $ProviderParams[1]

            $Header += @"
    <EventProvider Id="$ProviderName$ProviderCount" Name="$ProviderGuid"/>

"@
            $ProviderCount++
        }    
    }

    # Generating profiles
    foreach($Provider in $ProviderList) {
        $ProviderName = $Provider[0]
        $Header += @"
  <Profile Id="$ProviderName.Verbose.File" Name="$ProviderName" Description="$ProviderName.1" LoggingMode="File" DetailLevel="Verbose">
    <Collectors>
      <EventCollectorId Value="EventCollector$ProviderName">
        <EventProviders>

"@
        $ProviderCount = 0
        for($i = 0; $i -lt $Provider[1].Count; $i++)
        {
            $Header += "`t`t`t<EventProviderId Value=`"$ProviderName$ProviderCount`" />`n"
            $ProviderCount++
        }

        $Header += @"
        </EventProviders>
      </EventCollectorId>
    </Collectors>
  </Profile>
  <Profile Id="$ProviderName.Light.File" Name="$ProviderName" Description="$ProviderName.1" Base="$ProviderName.Verbose.File" LoggingMode="File" DetailLevel="Light" />
  <Profile Id="$ProviderName.Verbose.Memory" Name="$ProviderName" Description="$ProviderName.1" Base="$ProviderName.Verbose.File" LoggingMode="Memory" DetailLevel="Verbose" />
  <Profile Id="$ProviderName.Light.Memory" Name="$ProviderName" Description="$ProviderName.1" Base="$ProviderName.Verbose.File" LoggingMode="Memory" DetailLevel="Light" />

"@

    # Keep track of the providers that are currently running
    Out-File -FilePath "$_CONTAINER_DIR\RunningProviders.txt" -InputObject "$ProviderName" -Append
    }


    $Header += $Footer

    # Writing to a file
    Out-file -FilePath "auth.wprp" -InputObject $Header -Encoding ascii

}

function Start-NanoTrace {
    param($ContainerId)

    # Event Logs     
    foreach($EventLog in $_EVENTLOG_LIST)
    {
        $EventLogParams = $EventLog.Split("!")
        $EventLogName = $EventLogParams[0]
        $EventLogOptions = $EventLogParams[1]

        $ExportLogName += ".evtx"

        if($EventLogOptions -ne "NONE") {
            Invoke-Container -ContainerId $ContainerId -Nano -Record -Command "wevtutil set-log $EventLogName /enabled:true /rt:false /q:true"

            if($EventLogOptions.Contains("EXPORT")){
                $ExportName = $EventLogName.Replace("Microsoft-Windows-", "").Replace(" ","_").Replace("/","_")
                Invoke-Container -ContainerId $ContainerId -Nano -Record -PreTrace -Command "wevtutil export-log $EventLogName $ExportName /overwrite:true"
            }
            if($EventLogOptions.Contains("CLEAR")){
                Invoke-Container -ContainerId $ContainerId -Nano -Record -Command "wevtutil clear-log $EventLogName"
            }        
            if($EventLogOptions.Contains("SIZE")){
                Invoke-Container -ContainerId $ContainerId -Nano -Record -Command "wevtutil set-log $EventLogName /ms:102400000"
            }
        }
    }

    # Reg Add
    foreach($RegAction in $_REG_ADD)
    {
        $RegParams = $RegAction.Split("!")
        $RegKey = $RegParams[0]
        $RegName = $RegParams[1]
        $RegType = $RegParams[2]
        $RegValue = $RegParams[3]

        Invoke-Container -ContainerId $ContainerId -Nano -Record -Command "reg add $RegKey /v $RegName /t $RegType /d $RegValue /f"
    }

    Get-Content "$_CONTAINER_DIR\RunningProviders.txt" | ForEach-Object {
        Invoke-Container -ContainerId $ContainerId -Nano -Record -Command "wpr -start auth.wprp!$_ -instancename $_"
    }

    
}


# *** DEFINE ETL PROVIDER GROUPINGS ***

# **NGC**
$NGC = @(
'{B66B577F-AE49-5CCF-D2D7-8EB96BFD440C}!0x0'                # Microsoft.Windows.Security.NGC.KspSvc
'{CAC8D861-7B16-5B6B-5FC0-85014776BDAC}!0x0'                # Microsoft.Windows.Security.NGC.CredProv
'{6D7051A0-9C83-5E52-CF8F-0ECAF5D5F6FD}!0x0'                # Microsoft.Windows.Security.NGC.CryptNgc
'{0ABA6892-455B-551D-7DA8-3A8F85225E1A}!0x0'                # Microsoft.Windows.Security.NGC.NgcCtnr
'{9DF6A82D-5174-5EBF-842A-39947C48BF2A}!0x0'                # Microsoft.Windows.Security.NGC.NgcCtnrSvc
'{9B223F67-67A1-5B53-9126-4593FE81DF25}!0x0'                # Microsoft.Windows.Security.NGC.KeyStaging
'{89F392FF-EE7C-56A3-3F61-2D5B31A36935}!0x0'                # Microsoft.Windows.Security.NGC.CSP
'{CDD94AC7-CD2F-5189-E126-2DEB1B2FACBF}!0x0'                # Microsoft.Windows.Security.NGC.LocalAccountMigPlugin
'{1D6540CE-A81B-4E74-AD35-EEF8463F97F5}!0xffff'             # Microsoft-Windows-Security-NGC-PopKeySrv
'{CDC6BEB9-6D78-5138-D232-D951916AB98F}!0x0'                # Microsoft.Windows.Security.NGC.NgcIsoCtnr
'{C0B2937D-E634-56A2-1451-7D678AA3BC53}!0x0'                # Microsoft.Windows.Security.Ngc.Truslet
'{9D4CA978-8A14-545E-C047-A45991F0E92F}!0x0'                # Microsoft.Windows.Security.NGC.Recovery
'{3b9dbf69-e9f0-5389-d054-a94bc30e33f7}!0x0'                # Microsoft.Windows.Security.NGC.Local
'{34646397-1635-5d14-4d2c-2febdcccf5e9}!0x0'                # Microsoft.Windows.Security.NGC.KeyCredMgr
'{c12f629d-37d4-58f7-22a8-94ac45ad8648}!0x0'                # Microsoft.Windows.Security.NGC.Utils
'{3A8D6942-B034-48e2-B314-F69C2B4655A3}!0xffffffff'         # TPM
'{5AA9A3A3-97D1-472B-966B-EFE700467603}!0xffffffff'         # TPM Virtual Smartcard card simulator
'{EAC19293-76ED-48C3-97D3-70D75DA61438}!0xffffffff'         # Cryptographic TPM Endorsement Key Services

'{23B8D46B-67DD-40A3-B636-D43E50552C6D}!0x0'                # Microsoft-Windows-User Device Registration (event)

'{2056054C-97A6-5AE4-B181-38BC6B58007E}!0x0'                # Microsoft.Windows.Security.DeviceLock

'{7955d36a-450b-5e2a-a079-95876bca450a}!0x0'                # Microsoft.Windows.Security.DevCredProv
'{c3feb5bf-1a8d-53f3-aaa8-44496392bf69}!0x0'                # Microsoft.Windows.Security.DevCredSvc
'{78983c7d-917f-58da-e8d4-f393decf4ec0}!0x0'                # Microsoft.Windows.Security.DevCredClient
'{36FF4C84-82A2-4B23-8BA5-A25CBDFF3410}!0x0'                # Microsoft.Windows.Security.DevCredWinRt
'{86D5FE65-0564-4618-B90B-E146049DEBF4}!0x0'                # Microsoft.Windows.Security.DevCredTask

'{D5A5B540-C580-4DEE-8BB4-185E34AA00C5}!0x0'                # MDM SCEP Trace
'{9FBF7B95-0697-4935-ADA2-887BE9DF12BC}!0x0'                # Microsoft-Windows-DM-Enrollment-Provider (event)
'{3DA494E4-0FE2-415C-B895-FB5265C5C83B}!0x0'                # Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider (event)

'{73370BD6-85E5-430B-B60A-FEA1285808A7}!0x0'                # Microsoft-Windows-CertificateServicesClient (event)
'{F0DB7EF8-B6F3-4005-9937-FEB77B9E1B43}!0x0'                # Microsoft-Windows-CertificateServicesClient-AutoEnrollment (event)
'{54164045-7C50-4905-963F-E5BC1EEF0CCA}!0x0'                # Microsoft-Windows-CertificateServicesClient-CertEnroll (event)
'{89A2278B-C662-4AFF-A06C-46AD3F220BCA}!0x0'                # Microsoft-Windows-CertificateServicesClient-CredentialRoaming (event)
'{BC0669E1-A10D-4A78-834E-1CA3C806C93B}!0x0'                # Microsoft-Windows-CertificateServicesClient-Lifecycle-System (event)
'{BEA18B89-126F-4155-9EE4-D36038B02680}!0x0'                # Microsoft-Windows-CertificateServicesClient-Lifecycle-User (event)
'{B2D1F576-2E85-4489-B504-1861C40544B3}!0x0'                # Microsoft-Windows-CertificateServices-Deployment (event)
'{98BF1CD3-583E-4926-95EE-A61BF3F46470}!0x0'                # Microsoft-Windows-CertificationAuthorityClient-CertCli (event)
'{AF9CC194-E9A8-42BD-B0D1-834E9CFAB799}!0x0'                # Microsoft-Windows-CertPolEng (event)

'{d0034f5e-3686-5a74-dc48-5a22dd4f3d5b}!0xFFFFFFFF'         # Microsoft.Windows.Shell.CloudExperienceHost
'{99eb7b56-f3c6-558c-b9f6-09a33abb4c83}!0xFFFFFFFF'         # Microsoft.Windows.Shell.CloudExperienceHost.Common
'{aa02d1a4-72d8-5f50-d425-7402ea09253a}!0x0'                # Microsoft.Windows.Shell.CloudDomainJoin.Client
'{507C53AE-AF42-5938-AEDE-4A9D908640ED}!0x0'                # Microsoft.Windows.Security.Credentials.UserConsentVerifier

'{02ad713f-20d4-414f-89d0-da5a6f3470a9}!0xffffffffffffffff' # Microsoft.Windows.Security.CFL.API
'{acc49822-f0b2-49ff-bff2-1092384822b6}!0xffffffffffffffff' # Microsoft.CAndE.ADFabric.CDJ
'{f245121c-b6d1-5f8a-ea55-498504b7379e}!0xffffffffffffffff' # Microsoft.Windows.DeviceLockSettings
)

# **NGC** **Add additional NGC providers in case it's a client and the '-v' switch is added**
if ($v) 
    {
        if($ProductType -eq "WinNT")
            {
                $NGC = $NGC + @(
                '{6ad52b32-d609-4be9-ae07-ce8dae937e39}!0xffffffffffffffff'     # Microsoft-Windows-RPC
                '{f4aed7c7-a898-4627-b053-44a7caa12fcd}!0xffffffffffffffff'     # Microsoft-Windows-RPC-Events
                '{ac01ece8-0b79-5cdb-9615-1b6a4c5fc871}!0xffffffffffffffff'     # Microsoft.Windows.Application.Service
                )
            }
    }

# **Biometric**
$Biometric = @(
'{34BEC984-F11F-4F1F-BB9B-3BA33C8D0132}!0xffff'
'{225b3fed-0356-59d1-1f82-eed163299fa8}!0x0'
'{9dadd79b-d556-53f2-67c4-129fa62b7512}!0x0'
'{1B5106B1-7622-4740-AD81-D9C6EE74F124}!0x0'
'{1d480c11-3870-4b19-9144-47a53cd973bd}!0x0'
'{e60019f0-b378-42b6-a185-515914d3228c}!0x0'
'{48CAFA6C-73AA-499C-BDD8-C0D36F84813E}!0x0'
'{add0de40-32b0-4b58-9d5e-938b2f5c1d1f}!0x0'
'{e92355c0-41e4-4aed-8d67-df6b2058f090}!0x0'
'{85be49ea-38f1-4547-a604-80060202fb27}!0x0'
'{F4183A75-20D4-479B-967D-367DBF62A058}!0x0'
'{0279b50e-52bd-4ed6-a7fd-b683d9cdf45d}!0x0'
'{39A5AA08-031D-4777-A32D-ED386BF03470}!0x0'
'{22eb0808-0b6c-5cd4-5511-6a77e6e73a93}!0x0'
'{63221D5A-4D00-4BE3-9D38-DE9AAF5D0258}!0x0'
'{9df19cfa-e122-5343-284b-f3945ccd65b2}!0x0'
'{beb1a719-40d1-54e5-c207-232d48ac6dea}!0x0'
'{8A89BB02-E559-57DC-A64B-C12234B7572F}!0x0'
'{a0e3d8ea-c34f-4419-a1db-90435b8b21d0}!0xffffffffffffffff'
)

# **LSA**
$LSA = @(
'{D0B639E0-E650-4D1D-8F39-1580ADE72784}!0xC43EFF'
'{169EC169-5B77-4A3E-9DB6-441799D5CACB}!0xffffff'
'{DAA76F6A-2D11-4399-A646-1D62B7380F15}!0xffffff'
'{366B218A-A5AA-4096-8131-0BDAFCC90E93}!0xfffffff'
'{4D9DFB91-4337-465A-A8B5-05A27D930D48}!0xff'
'{7FDD167C-79E5-4403-8C84-B7C0BB9923A1}!0xFFF'
'{CA030134-54CD-4130-9177-DAE76A3C5791}!0xfffffff'
'{5a5e5c0d-0be0-4f99-b57e-9b368dd2c76e}!0xffffffffffffffff'
'{2D45EC97-EF01-4D4F-B9ED-EE3F4D3C11F3}!0xffffffffffffffff'
'{C00D6865-9D89-47F1-8ACB-7777D43AC2B9}!0xffffffffffffffff'
'{7C9FCA9A-EBF7-43FA-A10A-9E2BD242EDE6}!0xffffffffffffffff'
'{794FE30E-A052-4B53-8E29-C49EF3FC8CBE}!0xffffffffffffffff'
'{ba634d53-0db8-55c4-d406-5c57a9dd0264}!0xffffffffffffffff'
'{45E7DBC5-E130-5CEF-9353-CC5EBF05E6C8}!0xFFFF' # Including the Container CCG provider
'{A4E69072-8572-4669-96B7-8DB1520FC93A}!0xffffffffffffffff'
'{C5D12E1B-84A0-4fe6-9E5F-FEBA123EAE66}!0xffffffffffffffff'
'{E2E66F29-4D71-4646-8E58-20E204C3C25B}!0xffffffffffffffff'
'{6f2c1ee5-1dfd-519b-2d55-702756f5964d}!0xffffffffffffffff'
'{FB093D76-8964-11DF-9EA1-CB38E0D72085}!0xFFFF' #KDS SVC
'{3353A14D-EE30-436E-8FF5-575A4351EA80}!0xFFFF' #KDC PROV CLI
)

# **Ntlm_CredSSP**
$Ntlm_CredSSP = @(
'{5BBB6C18-AA45-49b1-A15F-085F7ED0AA90}!0x5ffDf'
'{AC69AE5B-5B21-405F-8266-4424944A43E9}!0xffffffff'
'{6165F3E2-AE38-45D4-9B23-6B4818758BD9}!0xffffffff'
'{AC43300D-5FCC-4800-8E99-1BD3F85F0320}!0xffffffffffffffff'
'{DAA6CAF5-6678-43f8-A6FE-B40EE096E06E}!0xffffffffffffffff'
)

# **Kerberos**
$Kerberos = @(
'{6B510852-3583-4e2d-AFFE-A67F9F223438}!0x7ffffff'
'{60A7AB7A-BC57-43E9-B78A-A1D516577AE3}!0xffffff'
'{FACB33C4-4513-4C38-AD1E-57C1F6828FC0}!0xffffffff'
'{97A38277-13C0-4394-A0B2-2A70B465D64F}!0xff'
'{8a4fc74e-b158-4fc1-a266-f7670c6aa75d}!0xffffffffffffffff'
'{98E6CFCB-EE0A-41E0-A57B-622D4E1B30B1}!0xffffffffffffffff'
) 

# **KDC**
$KDC = @(
'{1BBA8B19-7F31-43c0-9643-6E911F79A06B}!0xfffff'
'{f2c3d846-1d17-5388-62fa-3839e9c67c80}!0xffffffffffffffff'
'{6C51FAD2-BA7C-49b8-BF53-E60085C13D92}!0xffffffffffffffff'
)

# **SAM**
$SAM = @(
'{8E598056-8993-11D2-819E-0000F875A064}!0xffffffffffffffff'
'{0D4FDC09-8C27-494A-BDA0-505E4FD8ADAE}!0xffffffffffffffff'
'{BD8FEA17-5549-4B49-AA03-1981D16396A9}!0xffffffffffffffff'
'{F2969C49-B484-4485-B3B0-B908DA73CEBB}!0xffffffffffffffff'
'{548854B9-DA55-403E-B2C7-C3FE8EA02C3C}!0xffffffffffffffff'
)

# **SSL**
$SSL = @(
'{37D2C3CD-C5D4-4587-8531-4696C44244C8}!0x4000ffff'
)

# **Crypto/Dpapi**
$CryptNcryptDpapi = @(
'{EA3F84FC-03BB-540e-B6AA-9664F81A31FB}!0xFFFFFFFF'
'{A74EFE00-14BE-4ef9-9DA9-1484D5473302}!0xFFFFFFFF'
'{A74EFE00-14BE-4ef9-9DA9-1484D5473301}!0xFFFFFFFF'
'{A74EFE00-14BE-4ef9-9DA9-1484D5473303}!0xFFFFFFFF'
'{A74EFE00-14BE-4ef9-9DA9-1484D5473305}!0xFFFFFFFF'
'{786396CD-2FF3-53D3-D1CA-43E41D9FB73B}!0x0'
'{a74efe00-14be-4ef9-9da9-1484d5473304}!0xffffffffffffffff'
'{9d2a53b2-1411-5c1c-d88c-f2bf057645bb}!0xffffffffffffffff'
)

# **WebAuth**
$WebAuth = @(

'{B1108F75-3252-4b66-9239-80FD47E06494}!0x2FF'                  #IDCommon
'{82c7d3df-434d-44fc-a7cc-453a8075144e}!0x2FF'                  #IdStoreLib
'{D93FE84A-795E-4608-80EC-CE29A96C8658}!0x7FFFFFFF'             #idlisten

'{EC3CA551-21E9-47D0-9742-1195429831BB}!0xFFFFFFFF'             #cloudap
'{bb8dd8e5-3650-5ca7-4fea-46f75f152414}!0xffffffffffffffff'     #Microsoft.Windows.Security.CloudAp
'{7fad10b2-2f44-5bb2-1fd5-65d92f9c7290}!0xffffffffffffffff'     #Microsoft.Windows.Security.CloudAp.Critical

'{077b8c4a-e425-578d-f1ac-6fdf1220ff68}!0xFFFFFFFF'             #Microsoft.Windows.Security.TokenBroker
'{7acf487e-104b-533e-f68a-a7e9b0431edb}!0xFFFFFFFF'             #Microsoft.Windows.Security.TokenBroker.BrowserSSO
'{5836994d-a677-53e7-1389-588ad1420cc5}!0xFFFFFFFF'             #Microsoft.Windows.MicrosoftAccount.TBProvider

'{3F8B9EF5-BBD2-4C81-B6C9-DA3CDB72D3C5}!0x7'                    #wlidsvc
'{C10B942D-AE1B-4786-BC66-052E5B4BE40E}!0x3FF'                  #livessp
'{05f02597-fe85-4e67-8542-69567ab8fd4f}!0xFFFFFFFF'             #Microsoft-Windows-LiveId, MSAClientTraceLoggingProvider

'{74D91EC4-4680-40D2-A213-45E2D2B95F50}!0xFFFFFFFF'             #Microsoft.AAD.CloudAp.Provider
'{4DE9BC9C-B27A-43C9-8994-0915F1A5E24F}!0xFFFFFFFF'             #Microsoft-Windows-AAD
'{bfed9100-35d7-45d4-bfea-6c1d341d4c6b}!0xFFFFFFFF'             #AADPlugin
'{556045FD-58C5-4A97-9881-B121F68B79C5}!0xFFFFFFFF'             #AadCloudAPPlugin
'{F7C77B8D-3E3D-4AA5-A7C5-1DB8B20BD7F0}!0xFFFFFFFF'             #AadWamExtension
'{9EBB3B15-B094-41B1-A3B8-0F141B06BADD}!0xFFF'                  #AadAuthHelper
'{6ae51639-98eb-4c04-9b88-9b313abe700f}!0xFFFFFFFF'             #AadWamPlugin
'{7B79E9B1-DB01-465C-AC8E-97BA9714BDA2}!0xFFFFFFFF'             #AadTB
'{86510A0A-FDF4-44FC-B42F-50DD7D77D10D}!0xFFFFFFFF'             #AadBrokerPluginApp
'{5A9ED43F-5126-4596-9034-1DCFEF15CD11}!0xFFFFFFFF'             #AadCloudAPPluginBVTs

'{08B15CE7-C9FF-5E64-0D16-66589573C50F}!0xFFFFFF7F'             #Microsoft.Windows.Security.Fido

'{5AF52B0D-E633-4ead-828A-4B85B8DAAC2B}!0xFFFF'                 #negoexts
'{2A6FAF47-5449-4805-89A3-A504F3E221A6}!0xFFFF'                 #pku2u

'{EF98103D-8D3A-4BEF-9DF2-2156563E64FA}!0xFFFF'                 #webauth
'{2A3C6602-411E-4DC6-B138-EA19D64F5BBA}!0xFFFF'                 #webplatform

'{FB6A424F-B5D6-4329-B9B5-A975B3A93EAD}!0x000003FF'             #wdigest

'{2745a526-23f5-4ef1-b1eb-db8932d43330}!0xffffffffffffffff'     #Microsoft.Windows.Security.TrustedSignal
'{c632d944-dddb-599f-a131-baf37bf22ef0}!0xffffffffffffffff'     #Microsoft.Windows.Security.NaturalAuth.Service

'{63b6c2d2-0440-44de-a674-aa51a251b123}!0xFFFFFFFF'             #Microsoft.Windows.BrokerInfrastructure
'{4180c4f7-e238-5519-338f-ec214f0b49aa}!0xFFFFFFFF'             #Microsoft.Windows.ResourceManager
'{EB65A492-86C0-406A-BACE-9912D595BD69}!0xFFFFFFFF'             #Microsoft-Windows-AppModel-Exec
'{d49918cf-9489-4bf1-9d7b-014d864cf71f}!0xFFFFFFFF'             #Microsoft-Windows-ProcessStateManager
'{072665fb-8953-5a85-931d-d06aeab3d109}!0xffffffffffffffff'     #Microsoft.Windows.ProcessLifetimeManager
'{EF00584A-2655-462C-BC24-E7DE630E7FBF}!0xffffffffffffffff'     #Microsoft.Windows.AppLifeCycle
'{d48533a7-98e4-566d-4956-12474e32a680}!0xffffffffffffffff'     #RuntimeBrokerActivations
'{0b618b2b-0310-431e-be64-09f4b3e3e6da}!0xffffffffffffffff'     #Microsoft.Windows.Security.NaturalAuth.wpp
)


# **WebAuth** **Add additional WebAuth providers in case it's a client and the -v switch is added**
if ($v) 
    {
        if($ProductType -eq "WinNT")
            {
                $WebAuth = $WebAuth + @(
                '{20f61733-57f1-4127-9f48-4ab7a9308ae2}!0xffffffffffffffff'
                '{b3a7698a-0c45-44da-b73d-e181c9b5c8e6}!0xffffffffffffffff'
                '{4e749B6A-667D-4C72-80EF-373EE3246B08}!0xffffffffffffffff'
                )
            }
    }

# **Smartcard**
$Smartcard = @(
'{30EAE751-411F-414C-988B-A8BFA8913F49}!0xffffffffffffffff'
'{13038E47-FFEC-425D-BC69-5707708075FE}!0xffffffffffffffff'
'{3FCE7C5F-FB3B-4BCE-A9D8-55CC0CE1CF01}!0xffffffffffffffff'
'{FB36CAF4-582B-4604-8841-9263574C4F2C}!0xffffffffffffffff'
'{133A980D-035D-4E2D-B250-94577AD8FCED}!0xffffffffffffffff'
'{EED7F3C9-62BA-400E-A001-658869DF9A91}!0xffffffffffffffff'
'{27BDA07D-2CC7-4F82-BC7A-A2F448AB430F}!0xffffffffffffffff'
'{15DE6EAF-EE08-4DE7-9A1C-BC7534AB8465}!0xffffffffffffffff'
'{31332297-E093-4B25-A489-BC9194116265}!0xffffffffffffffff'
'{4fcbf664-a33a-4652-b436-9d558983d955}!0xffffffffffffffff'
'{DBA0E0E0-505A-4AB6-AA3F-22F6F743B480}!0xffffffffffffffff'
'{125f2cf1-2768-4d33-976e-527137d080f8}!0xffffffffffffffff'
'{beffb691-61cc-4879-9cd9-ede744f6d618}!0xffffffffffffffff'
'{545c1f45-614a-4c72-93a0-9535ac05c554}!0xffffffffffffffff'
'{AEDD909F-41C6-401A-9E41-DFC33006AF5D}!0xffffffffffffffff'
'{09AC07B9-6AC9-43BC-A50F-58419A797C69}!0xffffffffffffffff'
'{AAEAC398-3028-487C-9586-44EACAD03637}!0xffffffffffffffff'
'{9F650C63-9409-453C-A652-83D7185A2E83}!0xffffffffffffffff'
'{F5DBD783-410E-441C-BD12-7AFB63C22DA2}!0xffffffffffffffff'
'{a3c09ba3-2f62-4be5-a50f-8278a646ac9d}!0xffffffffffffffff'
'{15f92702-230e-4d49-9267-8e25ae03047c}!0xffffffffffffffff'
)


#  **SHELL/CREDPROVIDER FRAMEWORK AUTHUI/Winlogon**
$CredprovAuthui = @(
'{5e85651d-3ff2-4733-b0a2-e83dfa96d757}!0xffffffffffffffff'
'{D9F478BB-0F85-4E9B-AE0C-9343F302F9AD}!0xffffffffffffffff'
'{462a094c-fc89-4378-b250-de552c6872fd}!0xffffffffffffffff'
'{8db3086d-116f-5bed-cfd5-9afda80d28ea}!0xffffffffffffffff'
'{a55d5a23-1a5b-580a-2be5-d7188f43fae1}!0xFFFF'
'{4b8b1947-ae4d-54e2-826a-1aee78ef05b2}!0xFFFF'
'{176CD9C5-C90C-5471-38BA-0EEB4F7E0BD0}!0xffffffffffffffff'
'{3EC987DD-90E6-5877-CCB7-F27CDF6A976B}!0xffffffffffffffff'
'{41AD72C3-469E-5FCF-CACF-E3D278856C08}!0xffffffffffffffff'
'{4F7C073A-65BF-5045-7651-CC53BB272DB5}!0xffffffffffffffff'
'{A6C5C84D-C025-5997-0D82-E608D1ABBBEE}!0xffffffffffffffff'
'{C0AC3923-5CB1-5E37-EF8F-CE84D60F1C74}!0xffffffffffffffff'
'{DF350158-0F8F-555D-7E4F-F1151ED14299}!0xffffffffffffffff'
'{FB3CD94D-95EF-5A73-B35C-6C78451095EF}!0xffffffffffffffff'
'{d451642c-63a6-11d7-9720-00b0d03e0347}!0xffffffffffffffff'
'{b39b8cea-eaaa-5a74-5794-4948e222c663}!0xffffffffffffffff'
'{dbe9b383-7cf3-4331-91cc-a3cb16a3b538}!0xffffffffffffffff'
'{c2ba06e2-f7ce-44aa-9e7e-62652cdefe97}!0xffffffffffffffff'
'{5B4F9E61-4334-409F-B8F8-73C94A2DBA41}!0xffffffffffffffff'
'{a789efeb-fc8a-4c55-8301-c2d443b933c0}!0xffffffffffffffff'
'{301779e2-227d-4faf-ad44-664501302d03}!0xffffffffffffffff'
'{557D257B-180E-4AAE-8F06-86C4E46E9D00}!0xffffffffffffffff'
'{D33E545F-59C3-423F-9051-6DC4983393A8}!0xffffffffffffffff'
'{19D78D7D-476C-47B6-A484-285D1290A1F3}!0xffffffffffffffff'
'{EB7428F5-AB1F-4322-A4CC-1F1A9B2C5E98}!0xffffffffffffffff'
'{D9391D66-EE23-4568-B3FE-876580B31530}!0xffffffffffffffff'
'{D138F9A7-0013-46A6-ADCC-A3CE6C46525F}!0xffffffffffffffff'
'{2955E23C-4E0B-45CA-A181-6EE442CA1FC0}!0xffffffffffffffff'
'{012616AB-FF6D-4503-A6F0-EFFD0523ACE6}!0xffffffffffffffff'
'{5A24FCDB-1CF3-477B-B422-EF4909D51223}!0xffffffffffffffff'
'{63D2BB1D-E39A-41B8-9A3D-52DD06677588}!0xffffffffffffffff'
'{4B812E8E-9DFC-56FC-2DD2-68B683917260}!0xffffffffffffffff'
'{169CC90F-317A-4CFB-AF1C-25DB0B0BBE35}!0xffffffffffffffff'
'{041afd1b-de76-48e9-8b5c-fade631b0dd5}!0xffffffffffffffff'
'{39568446-adc1-48ec-8008-86c11637fc74}!0xffffffffffffffff'
'{d1731de9-f885-4e1f-948b-76d52702ede9}!0xffffffffffffffff'
'{d5272302-4e7c-45be-961c-62e1280a13db}!0xffffffffffffffff'
'{55f422c8-0aa0-529d-95f5-8e69b6a29c98}!0xffffffffffffffff'
)

# **Kernel**
$kernel = @(
'{9E814AAD-3204-11D2-9A82-006008A86939}!0x0000000000000005'
)

# Event Log Providers

$_EVENTLOG_LIST = @(
# LOGNAME!FLAG1|FLAG2|FLAG3
"Application!NONE"
"System!NONE"
"Microsoft-Windows-CAPI2/Operational!CLEAR|SIZE|EXPORT"
"Microsoft-Windows-Kerberos/Operational!CLEAR"
"Microsoft-Windows-Kerberos-key-Distribution-Center/Operational!DEFAULT"
"Microsoft-Windows-Kerberos-KdcProxy/Operational!DEFAULT"
"Microsoft-Windows-WebAuth/Operational!DEFAULT"
"Microsoft-Windows-WebAuthN/Operational!EXPORT"
"Microsoft-Windows-CertPoleEng/Operational!CLEAR"
"Microsoft-Windows-IdCtrls/Operational!EXPORT"
"Microsoft-Windows-User Control Panel/Operational!EXPORT"
"Microsoft-Windows-Authentication/AuthenticationPolicyFailures-DomainController!DEFAULT"
"Microsoft-Windows-Authentication/ProtectedUser-Client!DEFAULT"
"Microsoft-Windows-Authentication/ProtectedUserFailures-DomainController!DEFAULT"
"Microsoft-Windows-Authentication/ProtectedUserSuccesses-DomainController!DEFAULT"
"Microsoft-Windows-Biometrics/Operational!EXPORT"
"Microsoft-Windows-LiveId/Operational!EXPORT"
"Microsoft-Windows-AAD/Analytic!DEFAULT"
"Microsoft-Windows-AAD/Operational!EXPORT"
"Microsoft-Windows-User Device Registration/Debug!DEFAULT"
"Microsoft-Windows-User Device Registration/Admin!EXPORT"
"Microsoft-Windows-HelloForBusiness/Operational!EXPORT"
"Microsoft-Windows-Shell-Core/Operational!DEFAULT"
"Microsoft-Windows-WMI-Activity/Operational!DEFAULT"
"Microsoft-Windows-GroupPolicy/Operational!DEFAULT"
"Microsoft-Windows-Crypto-DPAPI/Operational!EXPORT"
"Microsoft-Windows-Containers-CCG/Admin!NONE"
)

# Registry Lists

$_REG_ADD = @(
# KEY!NAME!TYPE!VALUE
"HKLM\SYSTEM\CurrentControlSet\Control\Lsa\NegoExtender\Parameters!InfoLevel!REG_DWORD!0xFFFF"
"HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Pku2u\Parameters!InfoLevel!REG_DWORD!0xFFFF"
"HKLM\SYSTEM\CurrentControlSet\Control\LSA!SPMInfoLevel!REG_DWORD!0xC43EFF"
"HKLM\SYSTEM\CurrentControlSet\Control\LSA!LogToFile!REG_DWORD!1"
"HKLM\SYSTEM\CurrentControlSet\Control\LSA!NegEventMask!REG_DWORD!0xF"
"HKLM\SYSTEM\CurrentControlSet\Control\LSA!LspDbgInfoLevel!REG_DWORD!0x41C24800"
"HKLM\SYSTEM\CurrentControlSet\Control\LSA!LspDbgTraceOptions!REG_DWORD!0x1"
)



[float]$_Authscriptver = "4.6"
$_BASE_LOG_DIR = ".\authlogs"
$_LOG_DIR = $_BASE_LOG_DIR
$_CH_LOG_DIR = "$_BASE_LOG_DIR\container-host"
$_BASE_C_DIR = "$_BASE_LOG_DIR`-container"
$_C_LOG_DIR = "$_BASE_LOG_DIR\container"
$_ScriptStartedMsg = "`n
===== Microsoft CSS Authentication Scripts started tracing =====`n
The tracing has now started.
Once you have created the issue or reproduced the scenario, please run stop-auth.ps1 from this same directory to stop the tracing.`n"

if($version)
{
	Write-Host $_Authscriptver
	return
}

if ($accepteula)
    {
         ShowEULAIfNeeded "DS Authentication Scripts:" 2
         "EULA Accepted"
    }
else
    {
        $eulaAccepted = ShowEULAIfNeeded "DS Authentication Scripts:" 0
        if($eulaAccepted -ne "Yes")
            {
                "EULA Declined"
                exit
            }
         "EULA Accepted"
    }


# *** Set some system specifc variables ***
$wmiOSObject = Get-WmiObject -class Win32_OperatingSystem
$osVersionString = $wmiOSObject.Version
$osBuildNumString = $wmiOSObject.BuildNumber


# *** Disclaimer ***
Write-Host "`n
***************** Microsoft CSS Authentication Scripts ****************`n
This Data collection is for Authentication, smart card and Credential provider scenarios`n
Data is collected into a subdirectory of the directory from where this script is launched, called ""Authlogs"".`n
*************************** IMPORTANT NOTICE **************************`n
The authentication script is designed to collect information that will help Microsoft Customer Support Services (CSS) troubleshoot an issue you may be experiencing with Windows.
The collected data may contain Personally Identifiable Information (PII) and/or sensitive data, such as (but not limited to) IP addresses; PC names; and user names.`n

You can send this folder and its contents to Microsoft CSS using a secure file transfer tool - Please discuss this with your support professional and also any concerns you may have.`n"

Write-Host "`nPlease wait whilst the tracing starts.....`n"

# *** Check for PowerShell version ***
$PsVersion=($PSVersionTable).PSVersion.ToString()

if($psversiontable.psversion.Major -lt "4"){
Write-Host
"============= Microsoft CSS Authentication Scripts =============`n
The script requires PowerShell version 4.0 or above to run.`n
Version detected is $PsVersion`n
Stopping script`n"
exit
}

# *** Check for elevation ***
Write-Host "`nChecking token for Elevation - please wait..."

If((whoami /groups) -match "S-1-16-12288"){
Write-Host "`nToken elevated"}
Else{
Write-Host
"============= Microsoft CSS Authentication Scripts =============`n
The script must be run from an elevated Powershell console.
The script has detected that it is not being run from an elevated PowerShell console.`n
Please run the script from an elevated PowerShell console.`n"
exit
}


if($containerId -ne ""){
    Write-Verbose "Collecting Container Auth Scripts"
    # Confirm that docker is in our path
    $DockerExists = (Get-Command "docker.exe" -ErrorAction SilentlyContinue) -ne $null
    if($DockerExists){
        Write-Verbose "Docker.exe found"
        $RunningContainers = $(docker ps -q)
        if($containerId -in $RunningContainers){
            Write-Verbose "$containerId found"

            $_CONTAINER_DIR = "$_BASE_C_DIR`-$containerId"        
            if((Test-Path $_CONTAINER_DIR\started.txt))
            {
                Write-Host "
===== Microsoft CSS Authentication Scripts started tracing =====

We have detected that tracing has already been started.
Please run stop-auth.ps1 to stop the tracing.`n"
                exit
            }   
            New-Item $_CONTAINER_DIR -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
            Remove-Item $_CONTAINER_DIR\* -Recurse -ErrorAction SilentlyContinue | Out-Null
            
            # Confirm the running container base image
            if(Check-ContainerIsNano -ContainerId $containerId){

                Write-Verbose "Container Image is NanoServer"
                Out-File -FilePath $_CONTAINER_DIR\container-base.txt -InputObject "Nano"

                # We need to use the wprp for the auth data collection
                if(!(Test-Path "$_CONTAINER_DIR\auth.wprp") -and !(Test-Path "$_CONTAINER_DIR\RunningProviders.txt"))
                {
                    Generate-WPRP -ContainerId $containerId
                }

                # Checking if the container has the tracing scripts
                if(Check-ContainsScripts -ContainerId $containerId -IsNano){
                    Write-Host "Starting container tracing - please wait..."
                    Start-NanoTrace -ContainerId $containerId
                }
                else {
                    Write-Host "Container: $containerId missing tracing script!" -ForegroundColor Yellow
                    Write-Host "Please copy the auth.wprp into the C:\authscripts directory in the container then run start-auth.ps1 -containerId $containerId again
Example:
`tdocker stop $containerId
`tdocker cp auth.wprp $containerId`:\AuthScripts
`tdocker start $containerId
`t.\start-auth.ps1 -containerId $containerId" -ForegroundColor Yellow
                    return
                }
                
            }
            else {
                Write-Verbose "Container Image is Standard"
                Out-File -FilePath $_CONTAINER_DIR\container-base.txt -InputObject "Standard"

                if(Check-ContainsScripts -ContainerId $containerId){
                    Write-Host "Starting container tracing - please wait..."
                    Invoke-Container -ContainerId $ContainerId -Record -Command ".\start-auth.ps1 -accepteula"
                }
                else {
                    Write-Host "Please copy start-auth.ps1 and stop-auth.ps1 into the C:\authscripts directory in the container and run start-auth.ps1 -containerId $containerId again
Example:
`tdocker stop $containerId
`tdocker cp start-auth.ps1 $containerId`:\AuthScripts
`tdocker cp stop-auth.ps1 $containerId`:\AuthScripts
`tdocker start $containerId
`t.\start-auth.ps1 -containerId $containerId" -ForegroundColor Yellow
                    return
                }
            }
        }   
        else {
            Write-Host "Failed to find $containerId"
            return
        } 
    }
    else {
        Write-Host "Unable to find docker.exe in system path."
        return
    }

    Check-GMSA -ContainerId $containerId
 
    # Start Container Logging
    if((Get-HotFix | Where-Object { $_.HotFixID -gt "KB5000854" -and $_.Description -eq "Update"} | Measure-object).Count -ne 0){
        pktmon start --capture -f $_CONTAINER_DIR\Pktmon.etl -s 4096 2>&1 | Out-Null
    }
    else {
        netsh trace start capture=yes persistent=yes report=disabled maxsize=4096 scenario=NetConnection traceFile=$_CONTAINER_DIR\netmon.etl | Out-Null
    }

    Add-Content -Path $_CONTAINER_DIR\script-info.txt -Value ("Data collection started on: " + (Get-Date -Format "yyyy/MM/dd HH:mm:ss"))
    Add-Content -Path $_CONTAINER_DIR\started.txt -Value "Started"

Write-Host "`n
===== Microsoft CSS Authentication Scripts started tracing =====`n
The tracing has now started.
Once you have created the issue or reproduced the scenario, please run .\stop-auth.ps1 -containerId $containerId from this same directory to stop the tracing.`n
Once the tracing and data collection has completed, the script will save the data in a subdirectory from where this script is launched called `"$_CONTAINER_DIR`".
The `"$_CONTAINER_DIR`" directory and subdirectories will contain data collected by the Microsoft CSS Authentication scripts.
This folder and its contents are not automatically sent to Microsoft.
You can send this folder and its contents to Microsoft CSS using a secure file transfer tool - Please discuss this with your support professional and also any concerns you may have."
    return
}

# *** Check if script is running ***
If((Test-Path $_BASE_LOG_DIR\started.txt) -eq "True")
{
Write-Host "
===== Microsoft CSS Authentication Scripts started tracing =====

We have detected that tracing has already been started.
Please run stop-auth.ps1 to stop the tracing.`n"
exit
}

$_PRETRACE_LOG_DIR = $_LOG_DIR + "\PreTraceLogs"

If((Test-Path $_PRETRACE_LOG_DIR) -eq "True"){Remove-Item -Path $_PRETRACE_LOG_DIR -Force -Recurse}
If((Test-Path $_LOG_DIR) -eq "True"){Remove-Item -Path $_LOG_DIR -Force -Recurse}

New-Item -name $_LOG_DIR -ItemType Directory | Out-Null
New-Item -name $_PRETRACE_LOG_DIR -ItemType Directory | Out-Null

$ProductType=(Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\ProductOptions).ProductType
Add-Content -Path $_LOG_DIR\script-info.txt -Value "Microsoft CSS Authentication Script version $_Authscriptver"

Add-Content -Path $_LOG_DIR\started.txt -Value "Started"



# *** QUERY RUNNING PROVIDERS ***
Add-Content -Path $_PRETRACE_LOG_DIR\running-etl-sessions.txt -value (logman query * -ets)

# Enable Eventvwr logging
wevtutil.exe set-log "Microsoft-Windows-CAPI2/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null
wevtutil.exe export-log "Microsoft-Windows-CAPI2/Operational" $_PRETRACE_LOG_DIR\Capi2_Oper.evtx /overwrite:true 2>&1 | Out-Null
wevtutil.exe clear-log "Microsoft-Windows-CAPI2/Operational" 2>&1 | Out-Null
wevtutil.exe sl "Microsoft-Windows-CAPI2/Operational" /ms:102400000 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-Kerberos/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null
wevtutil.exe clear-log "Microsoft-Windows-Kerberos/Operational" 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-Kerberos-Key-Distribution-Center/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-Kerberos-KdcProxy/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-WebAuth/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-WebAuthN/Operational" /enabled:false 2>&1 | Out-Null
wevtutil.exe export-log "Microsoft-Windows-WebAuthN/Operational" $_PRETRACE_LOG_DIR\WebAuthn_Oper.evtx /overwrite:true 2>&1 | Out-Null
wevtutil.exe set-log "Microsoft-Windows-WebAuthN/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-CertPoleEng/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null
wevtutil.exe clear-log "Microsoft-Windows-CertPoleEng/Operational" 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-IdCtrls/Operational" /enabled:false | Out-Null
wevtutil.exe export-log "Microsoft-Windows-IdCtrls/Operational" $_PRETRACE_LOG_DIR\Idctrls_Oper.evtx /overwrite:true 2>&1 | Out-Null
wevtutil.exe set-log "Microsoft-Windows-IdCtrls/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-User Control Panel/Operational" /enabled:false 2>&1 | Out-Null
wevtutil.exe export-log "Microsoft-Windows-User Control Panel/Operational" $_PRETRACE_LOG_DIR\UserControlPanel_Oper.evtx /overwrite:true 2>&1 | Out-Null
wevtutil.exe set-log "Microsoft-Windows-User Control Panel/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-Authentication/AuthenticationPolicyFailures-DomainController" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-Authentication/ProtectedUser-Client" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-Authentication/ProtectedUserFailures-DomainController" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-Authentication/ProtectedUserSuccesses-DomainController" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-Biometrics/Operational" /enabled:false 2>&1 | Out-Null
wevtutil.exe export-log "Microsoft-Windows-Biometrics/Operational" $_PRETRACE_LOG_DIR\WinBio_oper.evtx /overwrite:true 2>&1 | Out-Null
wevtutil.exe set-log "Microsoft-Windows-Biometrics/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-LiveId/Operational" /enabled:false 2>&1 | Out-Null
wevtutil.exe export-log "Microsoft-Windows-LiveId/Operational" $_PRETRACE_LOG_DIR\LiveId_Oper.evtx /overwrite:true 2>&1 | Out-Null
wevtutil.exe set-log "Microsoft-Windows-LiveId/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-AAD/Analytic" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-AAD/Operational" /enabled:false 2>&1 | Out-Null
wevtutil.exe export-log "Microsoft-Windows-AAD/Operational" $_PRETRACE_LOG_DIR\Aad_oper.evtx /ow:true 2>&1 | Out-Null
wevtutil.exe set-log "Microsoft-Windows-AAD/Operational"  /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-User Device Registration/Admin" /enabled:false 2>&1 | Out-Null
wevtutil.exe export-log "Microsoft-Windows-User Device Registration/Admin" $_PRETRACE_LOG_DIR\UsrDeviceReg_Adm.evtx /overwrite:true 2>&1 | Out-Null
wevtutil.exe set-log "Microsoft-Windows-User Device Registration/Admin" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-User Device Registration/Debug" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-HelloForBusiness/Operational" /enabled:false 2>&1 | Out-Null
wevtutil.exe export-log "Microsoft-Windows-HelloForBusiness/Operational" $_PRETRACE_LOG_DIR\Hfb_Oper.evtx /overwrite:true 2>&1 | Out-Null
wevtutil.exe set-log "Microsoft-Windows-HelloForBusiness/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-Shell-Core/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null

wevtutil.exe set-log "Microsoft-Windows-WMI-Activity/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null
    
wevtutil.exe set-log "Microsoft-Windows-Crypto-DPAPI/Operational" /enabled:false 2>&1 | Out-Null
wevtutil.exe export-log "Microsoft-Windows-Crypto-DPAPI/Operational" $_PRETRACE_LOG_DIR\DPAPI_Oper.evtx /overwrite:true 2>&1 | Out-Null
wevtutil.exe set-log "Microsoft-Windows-Crypto-DPAPI/Operational" /enabled:true /rt:false /q:true 2>&1 | Out-Null


# *** ENABLE LOGGING VIA REGISTRY ***

# NEGOEXT
reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa\NegoExtender\Parameters /v InfoLevel /t REG_DWORD /d 0xFFFF /f 2>&1 | Out-Null

# PKU2U
reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Pku2u\Parameters /v InfoLevel /t REG_DWORD /d 0xFFFF /f 2>&1 | Out-Null

# LSA
reg add HKLM\SYSTEM\CurrentControlSet\Control\LSA /v SPMInfoLevel /t REG_DWORD /d 0xC43EFF /f 2>&1 | Out-Null
reg add HKLM\SYSTEM\CurrentControlSet\Control\LSA /v LogToFile /t REG_DWORD /d 1 /f 2>&1 | Out-Null
reg add HKLM\SYSTEM\CurrentControlSet\Control\LSA /v NegEventMask /t REG_DWORD /d 0xF /f 2>&1 | Out-Null

# LSP Logging
reg add HKLM\SYSTEM\CurrentControlSet\Control\LSA /v LspDbgInfoLevel /t REG_DWORD /d 0x41C20800 /f 2>&1 | Out-Null
reg add HKLM\SYSTEM\CurrentControlSet\Control\LSA /v LspDbgTraceOptions /t REG_DWORD /d 0x1 /f 2>&1 | Out-Null

# Kerberos Logging to SYSTEM event log in case this is a client
if($ProductType -eq "WinNT")
    {
        reg add HKLM\SYSTEM\CurrentControlSet\Control\LSA\Kerberos\Parameters /v LogLevel /t REG_DWORD /d 1 /f 2>&1 | Out-Null
    }

# *** START ETL PROVIDER GROUPS ***

# Start Logman NGC
$NGCSingleTraceName = "NGC"
logman start $NGCSingleTraceName -o $_LOG_DIR\NGC.etl -ets

ForEach($NGCProvider in $NGC)
    {
        # Update Logman NGC
        $NGCParams = $NGCProvider.Split('!')
        $NGCSingleTraceGUID = $NGCParams[0]
        $NGCSingleTraceFlags = $NGCParams[1]
        
        logman update trace $NGCSingleTraceName -p `"$NGCSingleTraceGUID`" $NGCSingleTraceFlags 0xff -ft 1:00 -rt -ets | Out-Null
    }

# Start Logman Biometric
$BiometricSingleTraceName = "Biometric"
logman create trace $BiometricSingleTraceName -o $_LOG_DIR\Biometric.etl -ets

ForEach($BiometricProvider in $Biometric)
    {
        # Update Logman Biometric
        $BiometricParams = $BiometricProvider.Split('!')
        $BiometricSingleTraceGUID = $BiometricParams[0]
        $BiometricSingleTraceFlags = $BiometricParams[1]
        
        logman update trace $BiometricSingleTraceName -p `"$BiometricSingleTraceGUID`" $BiometricSingleTraceFlags 0xff -ft 1:00 -rt -ets | Out-Null
    }

# Start Logman LSA
$LSASingleTraceName = "LSA"
logman create trace $LSASingleTraceName -o $_LOG_DIR\LSA.etl -ets

ForEach($LSAProvider in $LSA)
    {
        # Update Logman LSA
        $LSAParams = $LSAProvider.Split('!')
        $LSASingleTraceGUID = $LSAParams[0]
        $LSASingleTraceFlags = $LSAParams[1]
        
        logman update trace $LSASingleTraceName -p `"$LSASingleTraceGUID`" $LSASingleTraceFlags 0xff -ets | Out-Null
    }

# Start Logman Ntlm_CredSSP  
$Ntlm_CredSSPSingleTraceName = "Ntlm_CredSSP"
logman create trace $Ntlm_CredSSPSingleTraceName -o $_LOG_DIR\Ntlm_CredSSP.etl -ets

ForEach($Ntlm_CredSSPProvider in $Ntlm_CredSSP)
    {
        # Update Logman Ntlm_CredSSP
        $Ntlm_CredSSPParams = $Ntlm_CredSSPProvider.Split('!')
        $Ntlm_CredSSPSingleTraceGUID = $Ntlm_CredSSPParams[0]
        $Ntlm_CredSSPSingleTraceFlags = $Ntlm_CredSSPParams[1]
        
        logman update trace $Ntlm_CredSSPSingleTraceName -p `"$Ntlm_CredSSPSingleTraceGUID`" $Ntlm_CredSSPSingleTraceFlags 0xff -ets | Out-Null
    }

# Start Logman Kerberos
$KerberosSingleTraceName = "Kerberos"
logman start $KerberosSingleTraceName -o $_LOG_DIR\Kerberos.etl -ets

ForEach($KerberosProvider in $Kerberos)
    {
        # Update Logman Kerberos
        $KerberosParams = $KerberosProvider.Split('!')
        $KerberosSingleTraceGUID = $KerberosParams[0]
        $KerberosSingleTraceFlags = $KerberosParams[1]
        
        logman update trace $KerberosSingleTraceName -p `"$KerberosSingleTraceGUID`" $KerberosSingleTraceFlags 0xff -ets | Out-Null
    }

# Start Logman KDC
if($ProductType -eq "LanmanNT")
{
$KDCSingleTraceName = "KDC"
logman start $KDCSingleTraceName -o $_LOG_DIR\KDC.etl -ets

ForEach($KDCProvider in $KDC)
    {
        # Update Logman KDC
        $KDCParams = $KDCProvider.Split('!')
        $KDCSingleTraceGUID = $KDCParams[0]
        $KDCSingleTraceFlags = $KDCParams[1]
        
        logman update trace $KDCSingleTraceName -p `"$KDCSingleTraceGUID`" $KDCSingleTraceFlags 0xff -ets | Out-Null
    }
}

# Start Logman SSL     
$SSLSingleTraceName = "SSL"
logman start $SSLSingleTraceName -o $_LOG_DIR\SSL.etl -ets

ForEach($SSLProvider in $SSL)
    {
        # Update Logman SSL
        $SSLParams = $SSLProvider.Split('!')
        $SSLSingleTraceGUID = $SSLParams[0]
        $SSLSingleTraceFlags = $SSLParams[1]
        
        logman update trace $SSLSingleTraceName -p `"$SSLSingleTraceGUID`" $SSLSingleTraceFlags 0xff -ets | Out-Null
    }
    
# Start Logman WebAuth
$WebAuthSingleTraceName = "WebAuth"
logman start $WebAuthSingleTraceName -o $_LOG_DIR\WebAuth.etl -ets

ForEach($WebAuthProvider in $WebAuth)
    {
        # Update Logman WebAuth
        $WebAuthParams = $WebAuthProvider.Split('!')
        $WebAuthSingleTraceGUID = $WebAuthParams[0]
        $WebAuthSingleTraceFlags = $WebAuthParams[1]
        
        logman update trace $WebAuthSingleTraceName -p `"$WebAuthSingleTraceGUID`" $WebAuthSingleTraceFlags 0xff -ets | Out-Null
    }

# Start Logman Smartcard
$SmartcardSingleTraceName = "Smartcard"
logman start $SmartcardSingleTraceName -o $_LOG_DIR\Smartcard.etl -ets

ForEach($SmartcardProvider in $Smartcard)
    {
        # Update Logman Smartcard
        $SmartcardParams = $SmartcardProvider.Split('!')
        $SmartcardSingleTraceGUID = $SmartcardParams[0]
        $SmartcardSingleTraceFlags = $SmartcardParams[1]
        
        logman update trace $SmartcardSingleTraceName -p `"$SmartcardSingleTraceGUID`" $SmartcardSingleTraceFlags 0xff -ets | Out-Null
    }

# Start Logman CredprovAuthui
$CredprovAuthuiSingleTraceName = "CredprovAuthui"
logman start $CredprovAuthuiSingleTraceName -o $_LOG_DIR\CredprovAuthui.etl -ets

ForEach($CredprovAuthuiProvider in $CredprovAuthui)
    {
        # Update Logman CredprovAuthui
        $CredprovAuthuiParams = $CredprovAuthuiProvider.Split('!')
        $CredprovAuthuiSingleTraceGUID = $CredprovAuthuiParams[0]
        $CredprovAuthuiSingleTraceFlags = $CredprovAuthuiParams[1]
        
        logman update trace $CredprovAuthuiSingleTraceName -p `"$CredprovAuthuiSingleTraceGUID`" $CredprovAuthuiSingleTraceFlags 0xff -ets | Out-Null
    }

# Nonet check
if ($nonet.IsPresent -ne "False") 
    {
            # Start Net Trace
        switch -regex ($osVersionString)
        {
            # Win7 has different args syntax.
            '^6\.1' { netsh trace start persistent=yes traceFile=$_LOG_DIR\Netmon.etl capture=yes report=no maxsize=1024 | Out-Null }

            default { 
        	            if(($ProductType -eq "WinNT") -and ($v))
       		            {
			                netsh trace start scenario=internetclient persistent=yes traceFile=$_LOG_DIR\Netmon.etl capture=yes report=disabled maxsize=1024 | Out-Null
          	            }
		                else
		                {
			                netsh trace start persistent=yes traceFile=$_LOG_DIR\Netmon.etl capture=yes report=disabled maxsize=1024 | Out-Null
		                }
	                }
        }
    }

# Start Logman CryptNcryptDpapi
if($ProductType -eq "WinNT")
{
$CryptNcryptDpapiSingleTraceName = "CryptNcryptDpapi"
logman start $CryptNcryptDpapiSingleTraceName -o $_LOG_DIR\CryptNcryptDpapi.etl -ets

ForEach($CryptNcryptDpapiProvider in $CryptNcryptDpapi)
    {
        # Update Logman CryptNcryptDpapi
        $CryptNcryptDpapiParams = $CryptNcryptDpapiProvider.Split('!')
        $CryptNcryptDpapiSingleTraceGUID = $CryptNcryptDpapiParams[0]
        $CryptNcryptDpapiSingleTraceFlags = $CryptNcryptDpapiParams[1]
        
        logman update trace $CryptNcryptDpapiSingleTraceName -p `"$CryptNcryptDpapiSingleTraceGUID`" $CryptNcryptDpapiSingleTraceFlags 0xff -ets | Out-Null
    }
}

# Start Logman SAM
$SAMSingleTraceName = "SAM"
logman start $SAMSingleTraceName -o $_LOG_DIR\SAM.etl -ets

ForEach($SAMProvider in $SAM)
    {
        # Update Logman SAM
        $SAMParams = $SAMProvider.Split('!')
        $SAMSingleTraceGUID = $SAMParams[0]
        $SAMSingleTraceFlags = $SAMParams[1]
        
        logman update trace $SAMSingleTraceName -p `"$SAMSingleTraceGUID`" $SAMSingleTraceFlags 0xff -ets | Out-Null
    }



wevtutil.exe set-log "Microsoft-Windows-Containers-CCG/Admin" /enabled:false 2>&1 | Out-Null
wevtutil.exe export-log "Microsoft-Windows-Containers-CCG/Admin" $_PRETRACE_LOG_DIR\Containers-CCG_Admin.evtx /overwrite:true 2>&1 | Out-Null
wevtutil.exe set-log "Microsoft-Windows-Containers-CCG/Admin" /enabled:true /rt:false /q:true 2>&1 | Out-Null

# Start Kernel logger
if($ProductType -eq "WinNT")
    {
        $KernelSingleTraceName = "NT Kernel Logger"
        $KernelParams = $Kernel.Split('!')
        $KernelSingleTraceGUID = $KernelParams[0]
        $KernelSingleTraceFlags = $KernelParams[1]

        logman create trace $KernelSingleTraceName -ow -o $_LOG_DIR\kernel.etl -p `"$KernelSingleTraceGUID`" $KernelSingleTraceFlags 0xff -nb 16 16 -bs 1024 -mode Circular -f bincirc -max 4096 -ets | Out-Null
    }


# **Netlogon logging**
nltest /dbflag:0x2EFFFFFF 2>&1 | Out-Null

# **Enabling Group Policy Logging**
New-Item -Path "$($env:windir)\debug\usermode" -ItemType Directory 2>&1 | Out-Null
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Diagnostics" /f 2>&1 | Out-Null
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Diagnostics" /v GPSvcDebugLevel /t REG_DWORD /d 0x30002 /f 2>&1 | Out-Null


# ** Turn on debug and verbose Cert Enroll  logging **

write-host "Enabling Certificate Enrolment debug logging...`n"
write-host "Verbose Certificate Enrolment debug output may be written to this window"
write-host "It is also written to a log file which will be collected when the stop-auth.ps1 script is run.`n"

Start-Sleep -s 5

certutil -setreg -f Enroll\Debug 0xffffffe3 2>&1 | Out-Null

certutil -setreg ngc\Debug 1 2>&1 | Out-Null
certutil -setreg Enroll\LogLevel 5 2>&1 | Out-Null

Add-Content -Path $_PRETRACE_LOG_DIR\Dsregcmddebug.txt -Value (dsregcmd /status /debug /all 2>&1) | Out-Null
Add-Content -Path $_PRETRACE_LOG_DIR\DsRegCmdStatus.txt -Value (dsregcmd /status 2>&1) | Out-Null

Add-Content -Path $_PRETRACE_LOG_DIR\Tasklist.txt -Value (tasklist /svc 2>&1) | Out-Null
Add-Content -Path $_PRETRACE_LOG_DIR\Services-config.txt -Value (sc.exe query 2>&1) | Out-Null
Add-Content -Path $_PRETRACE_LOG_DIR\Services-started.txt -Value (net start 2>&1) | Out-Null

Add-Content -Path $_PRETRACE_LOG_DIR\netstat.txt -Value (netstat -ano 2>&1) | Out-Null
Add-Content -Path $_PRETRACE_LOG_DIR\Tickets.txt -Value(klist) | Out-Null
Add-Content -Path $_PRETRACE_LOG_DIR\Tickets-localsystem.txt -Value (klist -li 0x3e7) | Out-Null
Add-Content -Path $_PRETRACE_LOG_DIR\Klist-Cloud-Debug.txt -Value (klist Cloud_debug) | Out-Null
Add-Content -Path $_PRETRACE_LOG_DIR\Displaydns.txt -Value (ipconfig /displaydns 2>&1) | Out-Null

# *** QUERY RUNNING PROVIDERS ***
Add-Content -Path $_LOG_DIR\running-etl-sessions.txt -value (logman query * -ets)

ipconfig /flushdns 2>&1 | Out-Null


if($v.IsPresent -eq "True")
    {
        Add-Content -Path $_LOG_DIR\script-info.txt -Value "Arguments passed: v"
    }

if($nonet.IsPresent -eq "True")
    {
        Add-Content -Path $_LOG_DIR\script-info.txt -Value "Arguments passed: nonet"
    }

Add-Content -Path $_LOG_DIR\script-info.txt -Value ("Data collection started on: " + (Get-Date -Format "yyyy/MM/dd HH:mm:ss"))

Write-Host "`n
===== Microsoft CSS Authentication Scripts started tracing =====`n
The tracing has now started.
Once you have created the issue or reproduced the scenario, please run stop-auth.ps1 from this same directory to stop the tracing.`n
Once the tracing and data collection has completed, the script will save the data in a subdirectory from where this script is launched called `"Authlogs`".
The `"Authlogs`" directory and subdirectories will contain data collected by the Microsoft CSS Authentication scripts.
This folder and its contents are not automatically sent to Microsoft.
You can send this folder and its contents to Microsoft CSS using a secure file transfer tool - Please discuss this with your support professional and also any concerns you may have.`n"

# SIG # Begin signature block
# MIInrQYJKoZIhvcNAQcCoIInnjCCJ5oCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCB+HCVb8iH3iOme
# JFm1q6cQr/vaa/yokLiXkRSpkz9sYaCCDYEwggX/MIID56ADAgECAhMzAAACUosz
# qviV8znbAAAAAAJSMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjEwOTAyMTgzMjU5WhcNMjIwOTAxMTgzMjU5WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDQ5M+Ps/X7BNuv5B/0I6uoDwj0NJOo1KrVQqO7ggRXccklyTrWL4xMShjIou2I
# sbYnF67wXzVAq5Om4oe+LfzSDOzjcb6ms00gBo0OQaqwQ1BijyJ7NvDf80I1fW9O
# L76Kt0Wpc2zrGhzcHdb7upPrvxvSNNUvxK3sgw7YTt31410vpEp8yfBEl/hd8ZzA
# v47DCgJ5j1zm295s1RVZHNp6MoiQFVOECm4AwK2l28i+YER1JO4IplTH44uvzX9o
# RnJHaMvWzZEpozPy4jNO2DDqbcNs4zh7AWMhE1PWFVA+CHI/En5nASvCvLmuR/t8
# q4bc8XR8QIZJQSp+2U6m2ldNAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUNZJaEUGL2Guwt7ZOAu4efEYXedEw
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDY3NTk3MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAFkk3
# uSxkTEBh1NtAl7BivIEsAWdgX1qZ+EdZMYbQKasY6IhSLXRMxF1B3OKdR9K/kccp
# kvNcGl8D7YyYS4mhCUMBR+VLrg3f8PUj38A9V5aiY2/Jok7WZFOAmjPRNNGnyeg7
# l0lTiThFqE+2aOs6+heegqAdelGgNJKRHLWRuhGKuLIw5lkgx9Ky+QvZrn/Ddi8u
# TIgWKp+MGG8xY6PBvvjgt9jQShlnPrZ3UY8Bvwy6rynhXBaV0V0TTL0gEx7eh/K1
# o8Miaru6s/7FyqOLeUS4vTHh9TgBL5DtxCYurXbSBVtL1Fj44+Od/6cmC9mmvrti
# yG709Y3Rd3YdJj2f3GJq7Y7KdWq0QYhatKhBeg4fxjhg0yut2g6aM1mxjNPrE48z
# 6HWCNGu9gMK5ZudldRw4a45Z06Aoktof0CqOyTErvq0YjoE4Xpa0+87T/PVUXNqf
# 7Y+qSU7+9LtLQuMYR4w3cSPjuNusvLf9gBnch5RqM7kaDtYWDgLyB42EfsxeMqwK
# WwA+TVi0HrWRqfSx2olbE56hJcEkMjOSKz3sRuupFCX3UroyYf52L+2iVTrda8XW
# esPG62Mnn3T8AuLfzeJFuAbfOSERx7IFZO92UPoXE1uEjL5skl1yTZB3MubgOA4F
# 8KoRNhviFAEST+nG8c8uIsbZeb08SeYQMqjVEmkwggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIZgjCCGX4CAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAlKLM6r4lfM52wAAAAACUjAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgiAATVNLv
# x+0OcuAc++clI7nQvZdWKqHpTmR64m3yE5gwQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQBK09VpkHIZuP/kiF/+uPXvowZ929LlbNIHrW8b/cfx
# 5psapURBgiMcpx9ctfsf4XrK1/nNsLf9nFuUQ50HMYUiswEmmpxrwjWP9urG9Qm9
# Eq4HvMBlH5O4LOhn5V1dyQviNhlAew0Ryzuyjj58Ub3S+7KlXYtBsm4GrWreczGy
# jHxlNaWpPXqfxhNmuzg+V3fdVtYKhKJ7r0PQa/5JNePJyt99jDhwqf+UUnIg7OLI
# jrDfgtb+N57egYp3uvp8xRr4b89be7Uariwu1KCm1PPRAJb4Yr8fHfKJxeWD4aJn
# wmGnvmMQaW9+DGu3Z4QB7Y5+S2nHCwI4Gcen2t/PUxSIoYIXDDCCFwgGCisGAQQB
# gjcDAwExghb4MIIW9AYJKoZIhvcNAQcCoIIW5TCCFuECAQMxDzANBglghkgBZQME
# AgEFADCCAVUGCyqGSIb3DQEJEAEEoIIBRASCAUAwggE8AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEIHJBf8ci10PSMNjL/xf05lQIKJM4L/f85oLL7PBS
# HOj9AgZihMBUxP8YEzIwMjIwNjE2MTcxOTI3LjQzN1owBIACAfSggdSkgdEwgc4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1p
# Y3Jvc29mdCBPcGVyYXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjowQTU2LUUzMjktNEQ0RDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZaCCEV8wggcQMIIE+KADAgECAhMzAAABpzW7LsJkhVApAAEA
# AAGnMA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MB4XDTIyMDMwMjE4NTEyMloXDTIzMDUxMTE4NTEyMlowgc4xCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVy
# YXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjowQTU2
# LUUzMjktNEQ0RDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vydmlj
# ZTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAO0jOMYdUAXecCWm5V6T
# RoQZ4hsPLe0Vp6CwxFiTA5l867fAbDyxnKzdfBsf/0XJVXzIkcvzCESXoklvMDBD
# a97SEv+CuLEIooMbFBH1WeYgmLVO9TbbLStJilNITmQQQ4FB5qzMEsDfpmaZZMWW
# gdOjoSQed9UrjjmcuWsSskntiaUD/VQdQcLMnpeUGc7CQsAYo9HcIMb1H8DTcZ7y
# Ae3aOYf766P2OT553/4hdnJ9Kbp/FfDeUAVYuEc1wZlmbPdRa/uCx4iKXpt80/5w
# oAGSDl8vSNFxi4umXKCkwWHm8GeDZ3tOKzMIcIY/64FtpdqpNwbqGa3GkJToEFPR
# 6D6XJ0WyqebZvOZjMQEeLCJIrSnF4LbkkfkX4D4scjKz92lI9LRurhMPTBEQ6pw3
# iGsEPY+Jrcx/DJmyQWqbpN3FskWu9xhgzYoYsRuisCb5FIMShiallzEzum5xLE4U
# 5fuxEbwk0uY9ZVDNVfEhgiQedcSAd3GWvVM36gtYy6QJfixD7ltwjSm5sVa1voBf
# 2WZgCC3r4RE7VnovlqbCd3nHyXv5+8UGTLq7qRdRQQaBQXekT9UjUubcNS8ZYeZw
# K8d2etD98mSI4MqXcMySRKUJ9OZVQNWzI3LyS5+CjIssBHdv19aM6CjXQuZkkmlZ
# OtMqkLRg1tmhgI61yFC+jxB3AgMBAAGjggE2MIIBMjAdBgNVHQ4EFgQUH2y4fwWY
# LjCFb+EOQgPz9PpaRYMwHwYDVR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIw
# XwYDVR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9w
# cy9jcmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3Js
# MGwGCCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3Nv
# ZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENB
# JTIwMjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcD
# CDANBgkqhkiG9w0BAQsFAAOCAgEATxL6MfPZOhR91DHShlzal7B8vOCUvzlvbVha
# 0UzhZfvIcZA/bT3XTXbQPLnIDWlRdjQX7PGkORhX/mpjZCC5J7fD3TJMn9ZQQ8MX
# nJ0sx3/QJIlNgPVaOpk9Yk1YEqyItOyPHr3Om3v/q9h5f5qDk0IMV2taosze0JGl
# M3M5z7bGkDly+TfhH9lI03D/FzLjjzW8EtvcqmmH68QHdTsl84NWGkd2dUlVF2aB
# WMUprb8H9EhPUQcBcpf11IAj+f04yB3ncQLh+P+PSS2kxNLLeRg9CWbmsugplYP1
# D5wW+aH2mdyBlPXZMIaERJFvZUZyD8RfJ8AsE3uU3JSd408QBDaXDUf94Ki3wEXT
# tl8JQItGc3ixRYWNIghraI4h3d/+266OB6d0UM2iBXSqwz8tdj+xSST6G7ZYqxat
# Ezt806T1BBHe9tZ/mr2S52UjJgAVQBgCQiiiixNO27g5Qy4CDS94vT4nfC2lXwLl
# hrAcNqnAJKmRqK8ehI50TTIZGONhdhGcM5xUVeHmeRy9G6ufU6B6Ob0rW6LXY2qT
# LXvgt9/x/XEh1CrnuWeBWa9E307AbePaBopu8+WnXjXy6N01j/AVBq1TyKnQX1nS
# MjU9gZ3EaG8oS/zNM59HK/IhnAzWeVcdBYrq/hsu9JMvBpF+ZEQY2ZWpbEJm7ELl
# /CuRIPAwggdxMIIFWaADAgECAhMzAAAAFcXna54Cm0mZAAAAAAAVMA0GCSqGSIb3
# DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMTIw
# MAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAx
# MDAeFw0yMTA5MzAxODIyMjVaFw0zMDA5MzAxODMyMjVaMHwxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
# 5OGmTOe0ciELeaLL1yR5vQ7VgtP97pwHB9KpbE51yMo1V/YBf2xK4OK9uT4XYDP/
# XE/HZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY6GB9alKDRLemjkZrBxTzxXb1
# hlDcwUTIcVxRMTegCjhuje3XD9gmU3w5YQJ6xKr9cmmvHaus9ja+NSZk2pg7uhp7
# M62AW36MEBydUv626GIl3GoPz130/o5Tz9bshVZN7928jaTjkY+yOSxRnOlwaQ3K
# Ni1wjjHINSi947SHJMPgyY9+tVSP3PoFVZhtaDuaRr3tpK56KTesy+uDRedGbsoy
# 1cCGMFxPLOJiss254o2I5JasAUq7vnGpF1tnYN74kpEeHT39IM9zfUGaRnXNxF80
# 3RKJ1v2lIH1+/NmeRd+2ci/bfV+AutuqfjbsNkz2K26oElHovwUDo9Fzpk03dJQc
# NIIP8BDyt0cY7afomXw/TNuvXsLz1dhzPUNOwTM5TI4CvEJoLhDqhFFG4tG9ahha
# YQFzymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZki1ugpoMhXV8wdJGUlNi5UPkL
# iWHzNgY1GIRH29wb0f2y1BzFa/ZcUlFdEtsluq9QBXpsxREdcu+N+VLEhReTwDwV
# 2xo3xwgVGD94q0W29R6HXtqPnhZyacaue7e3PmriLq0CAwEAAaOCAd0wggHZMBIG
# CSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYEFCqnUv5kxJq+gpE8RjUp
# zxD/LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJlpxtTNRnpcjBcBgNVHSAEVTBT
# MFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIBFjNodHRwOi8vd3d3Lm1pY3Jv
# c29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5odG0wEwYDVR0lBAwwCgYI
# KwYBBQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGG
# MA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb186a
# GMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3Br
# aS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoGCCsG
# AQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwDQYJKoZIhvcN
# AQELBQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/ypb+pcFLY+TkdkeLEGk5c9MTO1
# OdfCcTY/2mRsfNB1OW27DzHkwo/7bNGhlBgi7ulmZzpTTd2YurYeeNg2LpypglYA
# A7AFvonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM9W0jVOR4U3UkV7ndn/OOPcbz
# aN9l9qRWqveVtihVJ9AkvUCgvxm2EhIRXT0n4ECWOKz3+SmJw7wXsFSFQrP8DJ6L
# GYnn8AtqgcKBGUIZUnWKNsIdw2FzLixre24/LAl4FOmRsqlb30mjdAy87JGA0j3m
# Sj5mO0+7hvoyGtmW9I/2kQH2zsZ0/fZMcm8Qq3UwxTSwethQ/gpY3UA8x1RtnWN0
# SCyxTkctwRQEcb9k+SS+c23Kjgm9swFXSVRk2XPXfx5bRAGOWhmRaw2fpCjcZxko
# JLo4S5pu+yFUa2pFEUep8beuyOiJXk+d0tBMdrVXVAmxaQFEfnyhYWxz/gq77EFm
# PWn9y8FBSX5+k77L+DvktxW/tM4+pTFRhLy/AsGConsXHRWJjXD+57XQKBqJC482
# 2rpM+Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU5nR0W2rRnj7tfqAxM328y+l7
# vzhwRNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEGahC0HVUzWLOhcGbyoYIC0jCC
# AjsCAQEwgfyhgdSkgdEwgc4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
# dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1ZXJ0byBSaWNv
# MSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjowQTU2LUUzMjktNEQ0RDElMCMGA1UE
# AxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUA
# wH7vHimSAzeDLN0qzWNb2p2vRH+ggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFt
# cCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIFAOZVeTQwIhgPMjAyMjA2MTYxMzQx
# MDhaGA8yMDIyMDYxNzEzNDEwOFowdzA9BgorBgEEAYRZCgQBMS8wLTAKAgUA5lV5
# NAIBADAKAgEAAgIWbQIB/zAHAgEAAgIRdDAKAgUA5lbKtAIBADA2BgorBgEEAYRZ
# CgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0G
# CSqGSIb3DQEBBQUAA4GBAG4Z5uxgXL2v2ZTy8QTrBya+hVfAbD/phvVeaUtOYBK7
# AYxJ69OGK+H2EEn8cgUA+zLKwLcMqv8Ker+f0nOKAuuUuS3gTxcikbQbaqiyXTds
# hKD+LnBlbGi6YNQWiV/vWDKuaTC0sZjwsN1SmANceghsYV8SILlNR4Zq+mTJZVWI
# MYIEDTCCBAkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMA
# AAGnNbsuwmSFUCkAAQAAAacwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJ
# AzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQgfbiCc6v2umz9471+XgC3
# 4MPGEfndSZHIckz3b9XC9WowgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCBH
# 8H/nCZUC4L0Yqbz3sH3w5kzhwJ4RqCkXXKxNPtqOGzCBmDCBgKR+MHwxCzAJBgNV
# BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4w
# HAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29m
# dCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAABpzW7LsJkhVApAAEAAAGnMCIEIBHH
# AuobS/5slX9UDw+LDYJCL+CXRUL3d9hgYG7BPC65MA0GCSqGSIb3DQEBCwUABIIC
# AF0vur5CiwMiNAJFuJbg2pw8Fu4Dnncc/qkMix6TCBZrO8QT4HhIOlE5Yy9nJclX
# 9fnJDDRbDA6qHClkvaGkNpTN8zNqXHwsJnk6xGaNwvZv88xGoSmpu0V/K3zvSJkk
# GOyAXVy1Rn8m8RcCvO3WaV5ZL9TiO6yKJ+Qyi4ZxFmeM5/d2kRHklZFgfhuYBkta
# 1CVm/NVMXN7mzWKQew//K5Od2WyQoAGLaq7z1/l99zwJsmPACqJmqf+VeT409qon
# xgJdnftn7lbxh9sKyv/JECK4TN16/+7SCQ1llSWhAhbom2n9LwT+lK3E4qUIT02g
# NejoXPtTrUHa4xy9lElfUeGFhmOpS1P+Nat0sM34YxozVTXr9RRMjU2ikwPe04S5
# RD5hiCXJXMyxNUxTu1wSmMycsS/5qGBLr5bpNd0OJhA3P4vkMAplJQUnpGKvAaqU
# wYZSIF1s8XO8/5k3q0e7m/5nlwWOPo2UUP0esZpE1f3s3To6eMGBEylznecLBTK3
# qFPcMVaRg5kVLXQKgz6I+X8yVdjxe9pjxd1DwPSr6rNu84WZaJ+G4Unofa9Ih2dw
# iAy8kp31DDSE9dk5PnCJkFQmwf5fuJm2E6bLxY9fIR7hgAzL3mL5V0lXdkVFS7sI
# qjADE5lcjm7+txPhPL3R6YOrWPYlSbJDxccQtKKpnYDs
# SIG # End signature block
