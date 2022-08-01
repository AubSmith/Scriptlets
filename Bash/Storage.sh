# List disk usage per mount
df -h
df -h | grep -v run # Hide lines containing run
df -aTH
df -h --total
df -ih # Inode

# List disk usage for folder
du -h .
du -csh
du -csh --block-size=1G
du -csh --block-size=1M
du -sh *
du -a ~/Downloads # All files
du -ah ~/Downloads # All files + Human readable

# Find and sort directories by size
du -sh * | sort -h
du -sh * | sort -h | tail -5

# Count directories in current directory
find . -mindepth 1 -maxdepth 1 -type d | wc -l
# Find aged files
find . -type f -mtime +70 | wc -l
# Delete aged files
find . -type f -mtime +70 -exec rm {} \;

find . -type f -atime +60 |wc -l

# View file/directory age
ls -al

# Find log files older than 60 days
find /var/log/httpd/* -mtime +60 -exec ls {} \;

# NVMe drives
sudo dnf install nvme-cli

sudo apt install nvme-cli

# Exploring an NVMe drive
nvme help

sudo nvme list

sudo nvme id-ctrl /dev/nvme0n1

sudo nvme smart-log /dev/nvme0n1

sudo nvme format /dev/nvme0nX

# Securely wipe drive
sudo nvme sanitize /dev/nvme0nX


# Disk format
df -h 
# Or for unformatted disk
ls -ltr /dev/sd*
sudo umount /dev/sdc1
sudo mkfs.vfat /dev/sdc1
sudo mkfs.ntfs /dev/sdc1
sudo mkfs.ext4 /dev/sdc1


# Extend Volume
sudo parted -ls /dev/sda1
sudo parted /dev/sda1

# p # Print
# resizepart 2 18GiB