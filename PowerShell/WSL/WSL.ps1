wsl.exe
wslconfig.exe /l

bash.exe

# View wsl distributions
PS C:\Users\aubre> wsl --list --verbose
  NAME            STATE           VERSION
* kali-linux      Stopped         2
  Ubuntu-20.04    Running         2
# Shutdown Ubuntu
  PS C:\Users\aubre> wsl --terminate Ubuntu-20.04
# Shutdown all
wsl --shutdown

# Restart wsl service
Get-Service LxssManager | Restart-Service