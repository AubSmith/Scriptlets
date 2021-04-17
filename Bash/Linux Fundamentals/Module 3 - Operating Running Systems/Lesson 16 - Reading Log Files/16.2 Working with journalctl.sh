journalctl # Tab completion available
journalctl -u sshd # Tab completion available
journalctl --dmesg # Kernel ring buffer
journalctl -u crond --since yesterday --until 9:00 -p info

systemctl status sshd
