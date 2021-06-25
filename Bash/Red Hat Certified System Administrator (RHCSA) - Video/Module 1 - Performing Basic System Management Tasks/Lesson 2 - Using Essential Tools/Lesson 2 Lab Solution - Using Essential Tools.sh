# Locate the man page that shows how to set a password
man -k password | grep 1
passwd

# Use the man page for useradd and as root, create a user with the name anna
man -k useradd
useradd --help
sudo useradd anna

# Set the password for anna to "password"
sudo passwd anna

# Use cd /etc to make /etc your current directory
cd /etc

# Use globbing and ls to show all files in /etc that have a number in their name
ls -d *[0-9]*

# Still from /etc, use the command ls -l. Use a pipe to display the results page by page. Next type cd without any arguments
ls -l | less
cd

# Use vim to create a file with the name users, and make sure that it contains the names alex, alexander, linda and belinda on separate lines
vim users
# i
# alex
# alexander
# linda
# belinda
# Esc
# :wq!