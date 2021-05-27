sudo yum install tree

# Create a directory structure /tmp/files/pictures, /tmp/files/photos and /tmp/files/videos
mkdir -p /tmp/files/pictures /tmp/files/photos /tmp/files/videos

# Copy all files that have a name starting with an a, b or c from /etc to /tmp/files
copy /etc/[a-c]* /tmp/files

# From /tmp/files, move all files that have a name starting with an a or b to /tmp/files/photos,
# and all files with a name starting with a c to /tmp/files/videos
mv /tmp/files/[ab]* /tmp/files/photos
mv /tmp/files/c* /tmp/files/videos

# Find all files on /etc that have a size small than 1000 bytes and copy those files to /tmp/files/pictures
find /etc -size -1000c -type f -exec cp {} /tmp/files/pictures/ \; 2>/dev/null

tree /tmp/files

# In /tmp/files, create a symbolic link to /var
ln -s /var /tmp/files/

# Create a compressed archive file of the /home directory
tar -czvf my_archive.tgz /home

# Extract this compressed archive file with relative file names to /tmp/archive
mkdir /tmp/archive
tar -xvf my_archive.tgz -C /tmp/archive