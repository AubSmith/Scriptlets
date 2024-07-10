# User profiles are read from ~/.config/powershell/profile.ps1
# Default profiles are read from $PSHOME/profile.ps1
# Default modules are read from $PSHOME/Modules
# Shared modules are read from /usr/local/share/powershell/Modules

# Download the powershell '.tar.gz' archive
curl -L -o /volumes/Samsung\ 128GB/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.3.4/powershell-7.3.4-osx-x64.tar.gz

# Expand powershell to the target folder
sudo tar zxf /volumes/Samsung\ 128GB/powershell.tar.gz -C /volumes/Samsung\ 128GB/VSCode/code-portable-data/PowerShell

# Set execute permissions
sudo chmod +x /volumes/Samsung\ 128GB/VSCode/code-portable-data/PowerShell/pwsh

# Create the symbolic link that points to pwsh
sudo ln -s "/volumes/Samsung 128GB/VSCode/code-portable-data/PowerShell/pwsh" /usr/local/bin/pwsh

echo $PSHOME # /Volumes/Samsung 128GB/VSCode/code-portable-data/PowerShell
ls ~/.local/share/powershell # User modules are read from ~/.local/share/powershell/Modules
                             # PSReadLine history are recorded to ~/.local/share/powershell/PSReadLine/ConsoleHost_history.txt
