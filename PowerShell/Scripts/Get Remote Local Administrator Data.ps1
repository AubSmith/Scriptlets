Function Get-SSALocalAdministrator
{
<#
	.SYNOPSIS
		The Get-SSALocalAdministrator function is used to report on the members of the local administrators group.

	.DESCRIPTION
		The Get-SSALocalADministrator function utilizes WinRM to remotely gather the members of the local administrators group and enumerate password and account information.

	.PARAMETER  ComputerName
		The ComputerName Parameter is used to designate the host to scan against.

	.EXAMPLE
        PS C:\Windows\system32> Get-SSALocalAdministrators -ComputerName SCCM | Format-Table -AutoSize

        Host      Entry                      SID                                            Type     State                  PasswordChangeable PasswordRequired PasswordNeverExpiress
        ----      -----                      ---                                            ----     -----                  ------------------ ---------------- ---------------------
        SCCM      administrator              S-1-5-21-1111111111-222222222-3333333333-500   Local    Disabled                             True             True N/A                  
        SCCM      DOMAIN\juser               S-1-5-21-1111111111-222222222-3333333333-39560 AD User  Enabled                              True             True False                
        SCCM      DOMAIN\Domain Admins       S-1-5-21-1111111111-222222222-3333333333-512   AD Group Active with 3 members                N/A              N/A  N/A                  
        SCCM      DOMAIN\sccmadmin           S-1-5-21-1111111111-222222222-3333333333-42613 AD User  Enabled                              True             True True                 
        SCCM      localadmin                 S-1-5-21-1111111111-222222222-3333333333-1058  Local    Enabled                              True             True N/A                  

	.INPUTS
		System.String

	.OUTPUTS
		System.Array

	.NOTES
		Author: Joshua Dostie, Information Systems Security Specialist
		Last Edit: 7/27/2017 10:54 AM
        Comments: This script is part of a series of solutions used to automate common server security assessments (SSA) through Windows PowerShell. 
	    This cmdlet will require WinRM which is enabled by default on Windows 2012 and up but needs to be turned on manually with 'winrm quickconfig' on older servers.

	.LINK
		about_functions_advanced

	.LINK
		about_comment_based_help

	.LINK
		about_functions_advanced_parameters

	.LINK
		about_functions_advanced_methods
#>
	[CmdletBinding()]
	param (
		[Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'default')]
		[ValidateScript({(Test-Connection -Quiet -Count 1 -ComputerName $_) -eq $true})]
		[System.String]$ComputerName
	)
	Begin
	{
		Try
		{
			$domainname = Get-ADDomain | Select-Object -ExpandProperty NetBIOSName
			$allmembers = Invoke-Command -ComputerName $ComputerName -ScriptBlock { net localgroup administrators }; $allmembers = $allmembers[6 .. ($allmembers.Length - 3)]
		}
		Catch
		{
			Write-Output "$(Get-Date -Format '[HH:mm:ss-MM-dd-yyyy]') - Block: Begin | ScriptLine: $($_.InvocationInfo.ScriptLineNumber) | ExceptionType: $($_.Exception.GetType().FullName) | ExceptionMessage: $($_.Exception.Message)"
			Break
		}
	}
	Process
	{
		Try
		{
			$allmembers | ForEach-Object {
				If ($_ -like "$domainname\*")
				{
					$name = $_ -replace "$domainname\\"
					If ((Get-ADUser -Filter "SamAccountName -like '$name'" -Properties SamAccountName | Measure-Object).Count -ne '0')
					{
						$AD = Get-ADUser -Filter "SamAccountName -like '$name'" -Properties Enabled, CannotChangePassword, PasswordNotRequired, SID, PasswordNeverExpires
						$type = 'AD User'
						If ($AD.Enabled -eq 'True') { $state = 'Enabled' }
						Else { $state = 'Disabled' }
						If ($AD.CannotChangePassword -eq 'True') { $passwordchangable = 'False' }
						Else { $passwordchangable = 'True' }
						If ($AD.PasswordNotRequired -eq 'False') { $passwordrequired = 'False' }
						Else { $passwordrequired = 'True' }
						[PSCustomObject]@{ 'Host' = $ComputerName; 'Entry' = $_; 'SID' = $AD.SID; 'Type' = $type; 'State' = $state; 'PasswordChangeable' = $passwordchangable; 'PasswordRequired' = $passwordrequired; 'PasswordNeverExpires' = $AD.PasswordNeverExpires }
					}
					ElseIf ((get-adgroup -Filter "SamAccountName -like '$name'" -Properties SamAccountName | Measure-Object).Count -ne '0')
					{
						$type = 'AD Group'
						$count = (Get-ADGroup -Filter "SamAccountName -like '$name'" -Properties SamAccountName | Get-ADGroupMember | Measure-Object).Count
						$AD = Get-ADGroup -Filter "SamAccountName -like '$name'" -Properties SamAccountName | Select-Object SID
						[PSCustomObject]@{ 'Host' = $ComputerName; 'Entry' = $_; 'SID' = $AD.SID; 'Type' = $type; 'State' = "Active with $count members"; 'PasswordChangeable' = 'N/A'; 'PasswordRequired' = 'N/A'; 'PasswordNeverExpires' = 'N/A' }
					}
					ElseIf ((Get-ADComputer -Filter "SamAccountName -like '$name'" -Properties SamAccountName | Measure-Object).Count -ne '0')
					{
						$type = 'AD Computer'
					}
				}
				ElseIf ($_ -notlike "$domainname\*")
				{
					$name = $_
					$type = 'Local'
					$cim = Get-CimInstance -Class win32_useraccount -ComputerName $ComputerName -Filter 'LocalAccount=True' | Where-Object { $_.Name -eq $name } | Select-Object Disabled, PasswordChangeable, PasswordRequired, SID
					If ($cim.Disabled -eq 'True')
					{
						$state = 'Disabled'
					}
					Else
					{
						$state = 'Enabled'
					}
					[PSCustomObject]@{ 'Host' = $ComputerName; 'Entry' = $name; 'SID' = $cim.sid; 'Type' = $type; 'State' = $state; 'PasswordChangeable' = $cim.PasswordChangeable; 'PasswordRequired' = $cim.PasswordRequired; 'PasswordNeverExpires' = 'N/A' }
				}
				Else
				{
					$type = 'Unknown'
				}
			}
		}
		Catch
		{
			Write-Output "$(Get-Date -Format '[HH:mm:ss-MM-dd-yyyy]') - Block: Process | ScriptLine: $($_.InvocationInfo.ScriptLineNumber) | ExceptionType: $($_.Exception.GetType().FullName) | ExceptionMessage: $($_.Exception.Message)"
			Break
		}
	}
}