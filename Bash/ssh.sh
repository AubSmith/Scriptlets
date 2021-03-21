ssh ip -X # Xforwarding - allow graphical UI over SSH
ssh ip # Login as current user
ssh newuser@ip # Login as newuser

# Setup SSH
ssh-keygen
ssh-copy-id ip
# or
ssh-copy-id user@ip