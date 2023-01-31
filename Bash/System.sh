# Kernel version
uname -srm

uname --kernel-name --kernel-release --machine

# Linux distribution
cat /etc/os-release

# All info
hostnamectl

# System FQDN
hostname --fqdn

# Shutdown
sudo shutdown -h 60 # Shutdown in 60 seconds
sudo shutdown -h now # Shutdown now

# CPU info
echo "CPU threads: $(grep -c processor /proc/cpuinfo)"
