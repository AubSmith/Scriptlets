# Find out which version of the kernel is being used
# Use man and related resources to find out how to change the computer hostname
# Read the help output for lvcreate to find out which options must be used

# Working
# Find out which version of the kernel is being used
uname -sr
Linux 5.4.72-microsoft-standard-WSL2

# Use man and related resources to find out how to change the computer hostname
man -k hostname
hostname --help
hostname -b NewHostname

# Read the help output for lvcreate to find out which options must be used
lvcreate --help | less
