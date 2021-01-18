# List disk usage per mount
df -h
df -h | grep -v run # Hide lines containing run

# List disk usage for folder
du -h .
du -csh
du -csh --block-size=1G
du -csh --block-size=1M
du -hs *

# Count directories in current directory
find . -mindepth 1 -maxdepth 1 -type d | wc -l
# Find aged files
find . -type f -mtime +70 | wc -l
# Delete aged files
find . -type f -mtime +70 -exec rm {} \;

find . -type f -atime +60 |wc -l

# View file/directory age
ls -al