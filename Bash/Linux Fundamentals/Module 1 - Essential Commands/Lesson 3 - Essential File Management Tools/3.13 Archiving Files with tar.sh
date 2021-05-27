# tar Tape Archiver
tar -cvf my_archive.tar /home
tar -xvf my_archive -C /home/location
tar -tvf

tar -cvf my_archive.tar /home /root
tar tvf my_archive.tar
tar -xvf my_archive # Extract current directory

ls -l my_archive.tar
mv my_archive.tar /tmp
tar -czvf /tmp/home.tgz /home /root
ls -l /tmp/home.tgz

tar -cjvf /tmp/homej.tgz /home /root
ls -l /tmp/homej.tgz