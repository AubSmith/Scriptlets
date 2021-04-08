date
date -s 12:00 # Set system time

hwclock --help
hwclock -s # Set system time from hardware clock
hwclock -w # Set hardware clock from system time

timedatectl --help
timedatectl list-timezones
timedatectl set-timezone timezone
timedatectl status
