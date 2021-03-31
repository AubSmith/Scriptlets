# Check CRLF 
# ^M = CR (Carriage Return)
# ^$ = LF (Line Feed)
cat -A file

# Strip CR
dos2unix

# List files last mod date
ls -lrt

# View directory properties
ls -ld

# Wildcards (Globbing)
# * = all characters
# ? = single character
# [a-c] or [1-3] = range
# [a-c]* = all files with name starting a,b,c
# ?[z-s]* = all files starting single character followed by second character s,t,u,v,w,x,y,z
# *?[a-z] = all files with letter in last position
# All files and directories start a
ls a*

# All files starting a, exclude directory content
ls -d a*

# Increase filename length - at least 1 character following a
ls -d a?*
ls -d a?t*
ls -d a[ln]*

# Remove all files starting with b or w
rm [bw]*

# cp
# Best practice to copy directories with trailing /
cp /var/tmp .

# Copy all files starting a,b,c
cp /etc/[a-c]* /tmp/files

mkdir ~/remove
cd ~/remove
# Copy /tmp and all contents
cp -R /tmp .
ls -al
rm -rf

##### Directories #####
cd / # Change to root
cd - # Change to previous directory

# Create all directories in path
mkdir -p /aubs/test/data/new
ls -R

touch ~/*
rm ~/\*

# ***** Links *****
ln /etc/hosts hosts # Create hard link
ls -li /etc/hosts hosts # -li = long inode

ln -s /etc/hosts hosts # Create symbolic link

# Find
find / -name "hosts"
find / -name "host" # does not find hosts
mkdir /root/amy; find / -user amy -exec cp {} /root/amy \; # \; closes exec cmd
find / -size +100M 2>/dev/null
find / -type f -size +100M
find /etc -exec grep -l amy {} \; -exec cp {} root/amy/ \; 2>/dev/null
find /etc -name '*' -type   f | xargs grep "127.0.0.1"
find /etc -type f -size -1000c -exec cp {} /tmp/files/pictures \;

# Moving files
mv [ab]* photos/
mv c* video

scp /var/tmp/myfile.txt username@hostname:/var/tmp/