## Set the Execution Policy and Scope ##

$ExecPol = #Restricted #AllSigned RemoteSigned #Unrestricted #Bypass #Undefined
$Scp = #Process CurrentUser #LocalMachine

Set-ExecutionPolicy -ExecutionPolicy $ExecPol -Scope $Scp -Force

Get-ExecutionPolicy -List

## Create profile if it does not exist ##

$ChkProfile = Test-Path $Profile
If ($ChkProfile -eq $True) {Copy-Item $profile $Home\mycurrentbackupprofile.ps1
Write-Host "Profile has been backed up"
}
ELSE
{New-Item -Path $profile -Type File –Force}

ise $Profile

<#

Set-Location c: # Sets starting location to C:\

Start-Transcript

$Shell.WindowTitle=”Aubrey Smith”

$Shell = $Host.UI.RawUI
$size = $Shell.WindowSize
$size.width=70
$size.height=25
$Shell.WindowSize = $size
$size = $Shell.BufferSize
$size.width=70
$size.height=5000
$Shell.BufferSize = $size

$shell.BackgroundColor = “Gray”
$shell.ForegroundColor = “Black”

new-item alias:np -value C:WindowsSystem32notepad.exe

Clear-Host

#Stop-Transcript

#>