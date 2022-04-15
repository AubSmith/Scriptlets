# Red Hat Web Console
sudo yum install cockpit

# https://192.168.1.101:9090

sudo systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit --permanent

firewall-cmd --reload

systemctl status cockpit.service
systemctl start cockpit.service
systemctl status cockpit.service
