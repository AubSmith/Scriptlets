# /usr/lib/systemd/system
# /etc/systemd

systemctl -t help # Shows unit types
systemctl list-unit-files # List all installed units
systemctl list-units # List active units
systemctl enable name.service # Enables but doesn't start service
systemctl start name.service # Starts a service
systemctl disable name.service # Disables but doesn't stop a service
systemctl stop name.service # Stops a service
systemctl status name.service # Gives information about a service