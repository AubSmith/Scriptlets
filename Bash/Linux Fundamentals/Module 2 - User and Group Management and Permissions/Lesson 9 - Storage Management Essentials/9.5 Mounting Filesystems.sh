mount /dev/sdb1 /mnt # Temporary mount point
cd /mnt 

touch file{a..z}

lsof /mnt # List Open Files
cd ..
umount /mnt

mount | grep '^/dev'

findmnt
