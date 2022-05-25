# Minute - Hour - Day - Month - Week

systemctl status crond

man 5 crontab
vim /etc/crontab

# Create cron job
crontab -e

cd /etc/cron.d
vim sysstat

less man-db.cron

tail /var/log/messages

# Auto update
0 22 * * 0 apt-get upgrade -y