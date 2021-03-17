# Show logged in user
whoami

# Show current computer name
hostname

hostnamectl set-hostname

# System info
uname
uname -r # Kernel release
uname -p # CPU architecture

# Clear screen
Ctrl + L

# Show current date time
date

# Set password
passwd

su -username # Switch user
su - # Centos switch root
sudo -i # Ubuntu switch root

# Create empty file
touch filename

# Show last login activity
last

# Find man page
man -k keyword # Replace keyword as appropriate
man -k keyword | grep 8
man -k user | grep 8 | create

appropos # = man -k

########## man ##########
# Update man pages
sudo mandb

# man Section
# 1 = Executable commands
# 5 = File formats and conventions
# 8 = System administrator commands

# Word count
man -k keyword | wc

########## pinfo ##########

# pinfo Manual pages
pinfo -a whoami

# Scroll U for up
# N for next
# P for previous
# Q to quit

########################

less /var/tmp/myfile
head /var/tmp/myfile # show first 10 lines
head -n 5 /var/tmp/myfile # show first 5 lines
tail /var/tmp/myfile # show last 10 lines
tail -n 5 /var/tmp/myfile # show last 5 lines
tail -20f /var/tmp/myfile # shows refreshes of file in real-time
head -n 5 /var/tmp/myfile | tail -n 1
head -n 5 /etc/passwd | tail -n 1

##### cat #####
# -A shows non-printable characters
# -b number lines
# -n numbers populated lines
# -s suppress repeated empty lines
##### tac #####
# Like cat but reversed

# cut - filter output from text file
cut -d : -f 1 /etc/passwd

# sort - sort files - often used in pipes
cut -d : -f 1 /etc/passwd | sort

# tr - translate between uppercase and lowercase
echo hello | tr [:lower:] [:upper:]
echo HELLO | tr [:upper:] [:lower:]

# awk - search for specific patterns
awk -F : '{ print $4 }' /etc/passwd # Print column 4
awk -F : '{ print $4 }' /etc/passwd | sort
awk -F : '{ print $4 }' /etc/passwd | sort -n
awk -F : '/amy/ { print $4}' /etc/passwd
ps aux | awk '{ print $1 }'

# sed - stream editor to batch-modify text files
sed -n 5p /etc/passwd # Print line 5 of file
sed -i s/word1/word2/g myfile # Interacively replace word1 with word2 globally in myfile
sed -i -e '2d' myfile # Edit and delete line 2 from myfile