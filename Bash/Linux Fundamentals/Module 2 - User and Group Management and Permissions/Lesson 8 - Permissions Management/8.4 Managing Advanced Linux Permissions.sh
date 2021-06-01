touch user/playme
vi user/playme

# #!/bin/bash
# echo Do you want to play?
# read
#
# rm -rf /

su - user
ls
./playme
ls -l
exit

# As root
chmod +x playme

su - linda
./playme

# Add Set User ID
chmod u+s filename
# Remove Set User ID
chmod u-s filename
# Find Set User ID files
find / -perm /4000

touch myfile
ls -ld .
# Add Set Group ID
chmod g+s .
touch myfile2
ls -ld .
# Find Set Group ID folders
find / -perm /2000

# Add Sticky Bit
chmod +t myfolder/
find / -perm /1000