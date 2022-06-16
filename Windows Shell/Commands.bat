sc query spooler

# Read file in cmd shell
more filename.txt
type filename.txt

# Logged in user
query user /server:computername

# User account details
net user esmith /domain
net user %username% /domain
net user %username%admin /domain

# User group membership
whoami /groups /fo list |findstr /:c "Group Name:" | sort

# File extension associations
assoc

# Securely dispose of disk
cipher

# Driver info
driverquery

# Compare files
fc

# System info
systeminfo

# System file checker
sfc

# Tasks
tasklist
tasklist -v

# Kill Tasks
taskkill

chkdsk

# Change cmd prompt
prompt


qwinsta

echo "Hello World" > test.txt
type test.txt