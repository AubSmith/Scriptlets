# Examine contents oh sshd service
# Ensure sshd service is automatically started after reboot
# Find system default target
# Show list of all active units



# Working

# Examine contents oh sshd service
systemctl cat sshd.service

# Ensure sshd service is automatically started after reboot
systemctl enable sshd.service

# Find system default target
systemctl get-default

# Show list of all active units
systemctl list-units
