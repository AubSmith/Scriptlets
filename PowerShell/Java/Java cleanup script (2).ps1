<#	
	.NOTES
	===========================================================================
	 Created on:   	7/03/2017 5:30 PM
	 Created by:   	Aubrey Smith
	 Organization: 	Aubrey Smith (2017)
	 Filename:     	Java uninstallation cleanup script
	===========================================================================

.SYNOPSIS

Script to cleanup after a Java uninstall.
.DESCRIPTION

This script removes traces that may be left behind after uninstalling Java on Windows systems.

#>

$RegUninstallPaths = @(
	'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
	'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall')

Get-WmiObject Win32_Process | Where { $_.ExecutablePath -like '*\Java\*' } |
Select @{ n = 'Name'; e = { $_.Name.Split('.')[0] } } | Stop-Process -Force

get-process -Name *iexplore* | Stop-Process -Force -ErrorAction SilentlyContinue

$UninstallSearchFilter = {
	($_.GetValue('DisplayName') -like '*Java*') -and
	(($_.GetValue('DisplayName') -eq 'Oracle') -or
		($_.GetValue('DisplayName') -eq 'Sun Microsystems, Inc.'))
}

foreach ($Path in $RegUninstallPaths)
{
	if (Test-Path $Path)
	{
		Get-ChildItem $Path | Where $UninstallSearchFilter |
		Foreach { Start-Process 'C:\Windows\System32\msiexec.exe' "/x $($_.PSChildName) /qn" -Wait }
	}
}

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
$ClassesRootPath = "HKCR:\Installer\Products"
Get-ChildItem $ClassesRootPath |
Where { ($_.GetValue('ProductName') -like '*Java*') } |
Foreach { Remove-Item $_.PsPath -Force -Recurse }


$JavaSoftPath = 'HKLM:\SOFTWARE\JavaSoft'
if (Test-Path $JavaSoftPath)
{
	Remove-Item $JavaSoftPath -Force -Recurse
}

Remove-Item $env:Programfiles\Java\ -Force -Recurse
Remove-Item $env:JavaHome -Force -Recurse

# Retrieve the PATH env. variable
$path = [System.Environment]::GetEnvironmentVariable(
	'PATH'
)
# Remove Java references in the PATH env. variable
$path = ($path.Split(';') | Where-Object { $_ -ne 'Java' }) -join ';'
# Set the PATH env. variable
[System.Environment]::SetEnvironmentVariable(
	'PATH',
	$path
)