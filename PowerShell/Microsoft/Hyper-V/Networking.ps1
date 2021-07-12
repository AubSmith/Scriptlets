# List VM Attached Switch
$VMs = Get-VM
Get-VMNetworkAdapter -VMName $VMs.Name | Select-Object VMName, SwitchName

Get-VM | Get-VMNetworkAdapter -VMName {$_.Name} | Select-Object VMName, SwitchName

# List Switches
$VMHost = Hostname
Get-VMSwitch -ComputerName $VMHost