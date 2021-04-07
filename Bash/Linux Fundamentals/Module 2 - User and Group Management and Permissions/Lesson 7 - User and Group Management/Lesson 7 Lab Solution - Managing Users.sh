# Create 4 users: linda, laura, anna, and anouk
# Set their passwords to expire after 60 days
# Create a group sales and make linda and laura members of that group
# Create a group account and make anna and anouk members of that group
# Also create a group users, and make all four users members of that group as a secondary group
# Use input redirection to set the password for these users to "password"
# Ensure all these users get a home directory in /home



# Working #

# Set their passwords to expire after 60 days
vim /etc/login.defs
# PASS_MAX_DAYS     60

# Ensure all these users get a home directory in /home
vim /etc/default/useradd

# Create a group sales and make linda and laura members of that group
# Create a group account and make anna and anouk members of that group
# Also create a group users, and make all four users members of that group as a secondary group
groupadd sales
groupadd account
groupadd users

# Create 4 users: linda, laura, anna, and anouk
useradd -G sales,users laura
useradd -G account,users anna
useradd -G account,users anouk
usermod -aG sales,users linda

# Use input redirection to set the password for these users to "password"
echo password | passwd --stdin linda
echo password | passwd --stdin laura
echo password | passwd --stdin anna
echo password | passwd --stdin anouk

# OR #

for i in anna anouk laura linda; do echo password | passwd --stdin $i; done