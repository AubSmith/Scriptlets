# OS Name and version
cat /etc/os-release
lsb_release -a
hostnamectl

grep '^VERSION' /etc/os-release
egrep '^(VERSION|NAME)=' /etc/os-release

# Linux Kernel version
uname -r