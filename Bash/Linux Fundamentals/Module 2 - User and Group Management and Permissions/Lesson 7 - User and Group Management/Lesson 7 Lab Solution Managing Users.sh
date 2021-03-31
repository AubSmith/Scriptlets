# Create 4 users: linda, laura, anna, and anouk
# Set their passwords to expire after 60 days
# Create a group sales and make linda and laura members of that group
# Create a group account and make anna and anouk members of that group
# Also create a group users, and make all four users members of that group as a secondary group
# Use input redirection to set the password for these users to "password"
# Ensure all these users get a home directory in /home



# Working #

# Create a group sales and make linda and laura members of that group
# Create a group account and make anna and anouk members of that group
groupadd sales
groupadd account

# Create 4 users: linda, laura, anna, and anouk
useradd -G sales linda
useradd -G sales laura
useradd -G account anna
useradd -G account anouk

# Set their passwords to expire after 60 days

# Also create a group users, and make all four users members of that group as a secondary group
# Use input redirection to set the password for these users to "password"
# Ensure all these users get a home directory in /home



# Answer #