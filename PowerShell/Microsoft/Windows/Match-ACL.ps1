Function Match-ACL {
	<#
		.SYNOPSIS
			Compare two ACL's ACE(s). Will return True if the Access Rules match and will return false if the Access rules do not match.
			Note: Ignores Inherited permissions.
		.DESCRIPTION
			Checks if two ACLs are matching by finding identical ACE(s) in the Current and Desired non-inherited ACL(s).
			Returns False if all Desired ACE(s) match Current ACE(s) but there is not the same amount of ACE(s) in each.		
		.EXAMPLE
			Acl-Match -CurrentACL (Get-ACL C:\temp) -DesiredACL (Get-ACL C:\test)
		.EXAMPLE
			It is also possible to create a System Security object in powershell to compare to:
			$DesiredACL = New-Object System.Security.AccessControl.DirectorySecurity
			#Create the ACE
			$ace = New-Object System.Security.AccessControl.FileSystemAccessRule(
				'Contoso\Domain Users', 
				'Modify', 
				'ContainerInherit, ObjectInherit', #ThisFolderSubfoldersAndFiles
				'None', 
				'Allow'
			)
			#Add the ACE to the ACL
			$DesiredACL.AddAccessRule($ace)
			$ace = New-Object System.Security.AccessControl.FileSystemAccessRule(
				"Contoso\User1", 
				'FullControl',
				'ContainerInherit, ObjectInherit', #ThisFolderSubfoldersAndFiles
				'None', 
				'Allow'
			)
			$DesiredACL.AddAccessRule($ace)
			Acl-Match -CurrentACL (Get-ACL C:\temp) -DesiredACL $DesiredACL
		.NOTES
			ToDo:
				Output object similar to Compare-Object
	#>
	param(
		[System.Security.AccessControl.FileSystemSecurity]$DesiredACL,
		[System.Security.AccessControl.FileSystemSecurity]$CurrentACL
	)
	$DesiredRules = $DesiredACL.GetAccessRules($true, $false, [System.Security.Principal.NTAccount])
	$CurrentRules = $CurrentACL.GetAccessRules($true, $false, [System.Security.Principal.NTAccount])
	$Matches = @()
	Foreach($DesiredRule in $DesiredRules){
		$Match = $CurrentRules | Where-object { 
			($DesiredRule.FileSystemRights -eq $_.FileSystemRights) -and 
	        ($DesiredRule.AccessControlType -eq $_.AccessControlType) -and 
			($DesiredRule.IdentityReference -eq $_.IdentityReference) -and 
	        ($DesiredRule.InheritanceFlags -eq $_.InheritanceFlags ) -and 
			($DesiredRule.PropagationFlags -eq $_.PropagationFlags ) 
		}
		If($Match){
			$Matches += $Match
		}
		Else{
			Return $False
		}
	}
	If($Matches.Count -ne $CurrentRules.Count){
		Return $False 
	}
	Return $True
}