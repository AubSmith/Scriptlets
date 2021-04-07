# Ensure that files created by the user root cannot be accessed by group or others; files of ordinary users should be readable by the group owners
# Create the directories /data/sales and /data/account
# Members of the group sales should be able to read and write files in /data/sales
# Members of the group account should be able to read and write files in /data/account
# No other users should have access to these directories
# Users will only be able to delete files they have created themselves, but user anna is the sales manager and should be able to manage all sales files 



# Working #

# Ensure that files created by the user root cannot be accessed by group or others; files of ordinary users should be readable by the group owners
umask 077

# Create the directories /data/sales and /data/account
mkdir -p /data/sales/
mkdir -p /data/account/

# Members of the group sales should be able to read and write files in /data/sales
# No other users should have access to these directories
# Users will only be able to delete files they have created themselves, but user anna is the sales manager and should be able to manage all sales files
cd /data/
chown anna:sales sales
chmod 770 sales
chmod +t sales

# Members of the group account should be able to read and write files in /data/account
# No other users should have access to these directories
# Users will only be able to delete files they have created themselves
cd /data/
chgrp account account
chmod 770 account
chmod +t account