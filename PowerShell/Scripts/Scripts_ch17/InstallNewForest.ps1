# Create New Forest, add Domain Controller
$domainname = "nwtraders.msft"
$netbiosName = "NWTRADERS"

  Import-Module ADDSDeployment
  Install-ADDSForest -CreateDnsDelegation:$false `
   -DatabasePath "C:\Windows\NTDS" `
   -DomainMode "Win2012" `
   -DomainName $domainname `
   -DomainNetbiosName $netbiosName `
   -ForestMode "Win2012" `
   -InstallDns:$true `
   -LogPath "C:\Windows\NTDS" `
   -NoRebootOnCompletion:$false `
   -SysvolPath "C:\Windows\SYSVOL" `
   -Force:$true 


