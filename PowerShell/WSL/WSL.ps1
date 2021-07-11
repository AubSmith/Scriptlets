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
