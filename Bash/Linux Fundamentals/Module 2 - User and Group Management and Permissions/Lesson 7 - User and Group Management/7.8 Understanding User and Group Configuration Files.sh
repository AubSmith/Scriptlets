ls -l /etc/passwd /etc/shadow /etc/group /etc/gshadow
tail -n 3 /etc/passwd # Stores user information
tail -n 3 /etc/shadow # Stores user password
cat /etc/group # Stores group information
grep wheel /etc/group # Admin group
tail /etc/group
cat /etc/gshadow # Note used anymore

vipw # Use to edit users - modifies /etc/passwd
vipw -s # Use to edit shadow
vigr # Use to edit groups