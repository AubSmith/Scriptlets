sc query spooler

# Read file in cmd shell
more filename.txt
type filename.txt

# Logged in user
query user /server:computername

# User account details
ney user esmith /domain

# User group membership
whoami /groups /fo list |findstr /:c "Group Name:" | sort