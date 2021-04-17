cd /usr/lib/systemd/system
ls *timer
cat fstrim.timer
ls fstrim.*

systemctl status fstrim.timer

man -k systemd | grep timer