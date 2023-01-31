### DISCOVERY ###
yum list installed | grep mongo # Find installed MongoDB packages

systemctl list-units | grep mongo # Find MongoDB service


### ACTIONS ###
sudo systemctl stop mongod.service

sudo rm -r /var/log/mongodb /var/lib/mongodb

### VERIFICATION ###
systemctl status mongod.service
