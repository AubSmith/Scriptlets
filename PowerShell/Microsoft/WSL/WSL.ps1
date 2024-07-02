# WSL Instance IP
wsl hostname -I

# List Distro and WSL Version
wsl -l -v

# Start WSL default dist terminal shell
wsl.exe

# Start WSL default dist terminal shell
bash.exe

# List WSL distributions
wslconfig.exe /l


# View wsl distributions
wsl --list --verbose
#  NAME            STATE           VERSION
#* kali-linux      Stopped         2
#  Ubuntu-20.04    Running         2

# Shutdown Ubuntu
wsl --terminate Ubuntu-20.04

# Shutdown all
wsl --shutdown

# Restart wsl service
Get-Service LxssManager | Restart-Service


# WSL -> WSL2
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2
wsl --set-version kali-linux 2

# Stop WSL
wsl --shutdown

# Import custom distro
# Create tar on source and copy to local disk - see wsl.sh
wsl --import RHEL8 D:\Software\wslDistro\RHEL8\ H:\rhel8.tar.gz

# Start custom distro
wsl -d RHEL8