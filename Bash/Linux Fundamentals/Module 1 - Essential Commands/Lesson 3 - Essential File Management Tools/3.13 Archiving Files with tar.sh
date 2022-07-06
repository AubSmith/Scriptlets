# tar Tape Archiver
# Create Verbose
tar -cvf my_archive.tar /home
# Extract Verbose
tar -xvf my_archive -C /home/location
# List Verbose
tar -tvf

tar -cvf my_archive.tar /home /root
tar tvf my_archive.tar
tar -xvf my_archive # Extract current directory

ls -l my_archive.tar
mv my_archive.tar /tmp
# Use G-zip for compression
tar -czvf /tmp/home.tgz /home /root
ls -l /tmp/home.tgz

# Use BZip2 for compression
tar -cjvf /tmp/homej.tgz /home /root
ls -l /tmp/homej.tgz

# List contained files
tar -t /tmp/homej.tgz