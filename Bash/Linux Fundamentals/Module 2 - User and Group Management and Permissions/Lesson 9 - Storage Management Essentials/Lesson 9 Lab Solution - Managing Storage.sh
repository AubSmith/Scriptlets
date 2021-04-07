# Add a new virtual disk to VM
# Create 1GB partition on new disk and format with Ext4 file system
# Mount the partition as a temporary mount on the /mnt directory



# Working #

# Add a new virtual disk to VM
echo 'Performed via Hyper-V'

# Create 1GB partition on new disk and format with Ext4 file system
gdisk /dev/sdb
mkfs.Ext4 /dev/sdb1

# Mount the partition as a temporary mount on the /mnt directory
mount /dev/sdb1 /mnt
