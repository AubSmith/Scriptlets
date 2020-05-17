##
# this script generates an ico bitmap showing the last 3 digits of you IP address and adds that ico to systray together with an balloon type notification
# to run this script automatically when any user logs in, use this command (change the path accordingly):
# schtasks.exe /create /tn "notify" /tr "powershell.exe -WindowStyle Hidden -NoExit -File C:\temp\notify.ps1" /sc onlogon /ru builtin\users 

## Author: Daniel M Alexandrescu ##  

function ico0
	{
		$g.drawline([System.Drawing.Pens]::Green,1+$off,3,1+$off,12)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,2,2+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,12,2+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,2,3+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,12,3+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,3,4+$off,12)
	}

function ico1
	{
		$g.drawline([System.Drawing.Pens]::Green,1+$off,4,1+$off,4)
		$g.drawline([System.Drawing.Pens]::Green,1+$off,13,1+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,3,2+$off,4)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,12,2+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,2,3+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,12,4+$off,13)
	}

function ico2
	{
		$g.drawline([System.Drawing.Pens]::Green,1+$off,3,1+$off,4)
		$g.drawline([System.Drawing.Pens]::Green,1+$off,9,1+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,2,2+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,8,2+$off,9)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,12,2+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,2,3+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,7,3+$off,8)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,12,3+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,3,4+$off,7)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,11,4+$off,13)
	}

function ico3
	{
		$g.drawline([System.Drawing.Pens]::Green,1+$off,3,1+$off,4)
		$g.drawline([System.Drawing.Pens]::Green,1+$off,11,1+$off,12)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,2,2+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,7,2+$off,8)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,12,2+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,2,3+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,7,3+$off,8)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,12,3+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,3,4+$off,6)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,9,4+$off,12)
	}

function ico4
	{
		$g.drawline([System.Drawing.Pens]::Green,1+$off,7,1+$off,10)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,5,2+$off,6)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,9,2+$off,10)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,3,3+$off,4)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,9,3+$off,10)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,2,4+$off,13)
	}	
	
function ico5
	{
		$g.drawline([System.Drawing.Pens]::Green,1+$off,2,1+$off,7)
		$g.drawline([System.Drawing.Pens]::Green,1+$off,12,1+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,2,2+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,6,2+$off,7)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,12,2+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,2,3+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,6,3+$off,7)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,12,3+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,2,4+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,7,4+$off,12)
	}	
	
function ico6
	{
		$g.drawline([System.Drawing.Pens]::Green,1+$off,3,1+$off,12)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,2,2+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,7,2+$off,8)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,12,2+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,2,3+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,7,3+$off,8)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,12,3+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,3,4+$off,4)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,8,4+$off,12)
	}	
	
function ico7
	{
		$g.drawline([System.Drawing.Pens]::Green,1+$off,2,1+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,1+$off,10,1+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,2,2+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,8,2+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,2,3+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,6,3+$off,8)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,2,4+$off,7)
	}	
	
function ico8
	{
		$g.drawline([System.Drawing.Pens]::Green,1+$off,3,1+$off,6)
		$g.drawline([System.Drawing.Pens]::Green,1+$off,9,1+$off,12)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,2,2+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,7,2+$off,8)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,12,2+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,2,3+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,7,3+$off,8)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,12,3+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,3,4+$off,6)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,9,4+$off,12)
	}	
	
function ico9
	{
		$g.drawline([System.Drawing.Pens]::Green,1+$off,3,1+$off,7)
		$g.drawline([System.Drawing.Pens]::Green,1+$off,11,1+$off,12)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,2,2+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,7,2+$off,8)
		$g.drawline([System.Drawing.Pens]::Green,2+$off,12,2+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,2,3+$off,3)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,7,3+$off,8)
		$g.drawline([System.Drawing.Pens]::Green,3+$off,12,3+$off,13)
		$g.drawline([System.Drawing.Pens]::Green,4+$off,3,4+$off,12)
	}		
	
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
$bmp = New-Object System.Drawing.Bitmap(16,16)
$g = [System.Drawing.Graphics]::FromImage($bmp)

# find ipaddress
$ip = ((ipconfig | findstr [0-9].\.)[0]).Split()[-1]

# alternate methods to find the ip address
# $ip = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | ? { $_.IPAddress -ne $null }).IPAddress
# or
# $ip = (gwmi Win32_NetworkAdapterConfiguration | ? { $_.IPAddress -ne $null }).ipaddress
# trimming extra information (needed for both methods)
# $count = ($ip | measure-object -character | select -expandproperty characters)
# If ($count -gt 13) {$ip = $ip.split(", ")[0]}

$id = $ip.split(".")[3]
$count = ($id | measure-object -character | select -expandproperty characters)
If ($count -eq 2) {$id = "0" + $id}
If ($count -eq 1) {$id = "00" + $id}
	
$id1 = $id.substring(0,1)
$id2 = $id.substring(1,1)
$id3 = $id.substring(2,1)

$i = 0
do
	{
		if ([string]$i -eq $id1) {$function1 = "ico$i"}
		$i++
	}  while ($i -le 9)

$i = 0
do
	{
		if ([string]$i -eq $id2) {$function2 = "ico$i"}
		$i++
	}  while ($i -le 9)

$i = 0
do
	{
		if ([string]$i -eq $id3) {$function3 = "ico$i"}
		$i++
	}  while ($i -le 9)

[int]$off = 0
invoke-expression $function1

[int]$off = 5
invoke-expression $function2

[int]$off = 10
invoke-expression $function3

$ico = [System.Drawing.Icon]::FromHandle($bmp.GetHicon())

# Create the notification object
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$NotifyIcon = New-Object System.Windows.Forms.NotifyIcon 

# Balloon icon type: None, Info, Warning or Error.
$NotifyIcon.BalloonTipTitle = "IT phone support: xxxxxxxxx"
$NotifyIcon.BalloonTipText  = "Your remote ID is $id"
$NotifyIcon.BalloonTipIcon  = "Info"
$NotifyIcon.Icon = $ico
$NotifyIcon.Visible = $True
$NotifyIcon.ShowBalloonTip(300000)

# uncomment the next line to remove the icon after the timeout expires
# if you need this icon to be displayed permanently without a visible window run the script using this command (change the path accordingly):
# "powershell.exe -WindowStyle Hidden -NoExit -File C:\temp\notify.ps1"

#$NotifyIcon.Visible = $False
