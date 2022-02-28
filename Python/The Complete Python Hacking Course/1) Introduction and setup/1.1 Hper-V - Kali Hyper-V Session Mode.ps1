# Verify SSH
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

# Install SSH
Add-WindowsCapability -Online -Name OpenSSH.CLient~~~~0.0.1.0

# Enable Enhanced Session
Set-VM "Kali" -EnhancedSessionTransportType HVSocket


# Troubleshoot SSH
Remote-SSH: Kill VS Code Server on Host
