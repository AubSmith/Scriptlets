# Use appropriate command to create a file /tmp/testfile from now
# Use appropriate solution to run the fstrim command on a daily basis
# Ensure that on a daily basis at 4PM the message "hello" is written to syslog

# Working

# Use appropriate command to create a file /tmp/testfile from now
at now +5min
touch /tmp/testfile
# Ctrl D

# Use appropriate solution to run the fstrim command on a daily basis
systemctl disable --now fstrim.timer
cd /etc/cron.daily/
vim fstrim.cron

###########
# #!/bin/bash
# fstrim
#
###########

# Ensure that on a daily basis at 4PM the message "hello" is written to syslog
crontab -e

0 16 * * * logger hello