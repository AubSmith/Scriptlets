#CreateReadOnlyDomainController.ps1

Import-Module ADDSDeployment
Install-ADDSDomainController `
-AllowPasswordReplicationAccountName @("NWTRADERS\Allowed RODC Password Replication Group") `
-NoGlobalCatalog:$false `
-Credential (Get-Credential -Credential nwtraders\administrator) `
-CriticalReplicationOnly:$false `
-DatabasePath "C:\Windows\NTDS" `
-DenyPasswordReplicationAccountName @("BUILTIN\Administrators", 
  "BUILTIN\Server Operators", "BUILTIN\Backup Operators", 
  "BUILTIN\Account Operators", 
  "NWTRADERS\Denied RODC Password Replication Group") `
-DomainName "nwtraders.msft" `
-InstallDns:$false `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-ReadOnlyReplica:$true `
-SiteName "Default-First-Site-Name" `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
