# List available Linux distributions
wsl --list --online

# List installed Linux distributions
wsl --list

# Install a specific Linux distribution
wsl --install --distribution <Distribution Name>

# Set default Linux distribution
wsl --set-default <Distribution Name>

# Change directory to home
wsl ~

# Run a specific Linux distribution from PowerShell or CMD
wsl --distribution <Distribution Name> --user <User Name>

# Update WSL
wsl --update

# Check WSL status
wsl --status

# Help command
wsl --help

# Change the default user for a distribution
<DistributionName> config --default-user <Username>

# Shutdown
wsl --shutdown
wsl --terminate <Distribution Name>

# Export a distribution to a TAR file
wsl --export <Distribution Name> <FileName>

# Import a new distribution
wsl --import <Distribution Name> <InstallLocation> <FileName>

# Mount a disk or device
wsl --mount <DiskPath>
wsl --mount --type <Filesystem> # If not specified defaults to ext4
wsl --mount --partition <Partition Number>
wsl --unmount <DiskPath>

# Misc commands
# Run Linux tools from a Windows command line
wsl ls -la
wsl sudo apt-get update
dir | wsl grep git
wsl ls -la > out.txt
wsl ls -la /proc/cpuinfo
wsl ls -la "/mnt/c/Program Files"

# Mix Linux and Windows commands
wsl ls -la | findstr "git"
dir | wsl grep git

# Run a Windows tool directly from the WSL (bash) command line
notepad.exe .bashrc
explorer.exe .
ipconfig.exe | grep IPv4 | cut -d: -f2
ls -la | findstr.exe foo.txt
cmd.exe /C dir
ping.exe www.microsoft.com
notepad.exe "C:\temp\foo.txt"
notepad.exe C:\\temp\\foo.txt

# Run the Windows ipconfig.exe tool with the Linux Grep tool
ipconfig.exe | grep IPv4 | cut -d: -f2

# WSL FS
\\wsl$

<#
There are four flags available in WSLENV to influence how the environment variable is translated.

WSLENV flags:

/p - translates the path between WSL/Linux style paths and Win32 paths.
/l - indicates the environment variable is a list of paths.
/u - indicates that this environment variable should only be included when running WSL from Win32.
/w - indicates that this environment variable should only be included when running Win32 from WSL.
Flags can be combined as needed.
#>