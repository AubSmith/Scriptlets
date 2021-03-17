zip -r ~/output.zip /var/tmp/source1 ~/tmp/source2

# Create tar archive
tar -cvf filename.tar /source/directory/here
tar -cvf filename.tar /source/filename/here


# Unzip
unzip -d /dest/directory/ {file.zip}

# tar (Tape Archiver)
tar cvf my_archive.tar /home # Create archive of /home
tar xvf my_archive # extract -C to change extract path
tar tvf my_archive # show contents
tar czvf my_archive /home # Compression engine
tar cjvf my_archive /home # Compression engine

# Compression
dd if=/dev/zero of=bigfile1 bs=1M count=1024 # Create 1GB file
dd if=/dev/zero of=bigfile2 bs=1M count=1024 # Create 1GB file
dd if=/dev/zero of=bigfile3 bs=1M count=1024 # Create 1GB file

time gzip bigfile1 # gunzip to extract
time bzip2 bigfile2
time zip bigfile3.zip bigfile3

ls -l bigfile*

mv bigfile1.gz bigfile1
file bigfile1