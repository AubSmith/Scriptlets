sudo yum module install -y container-tools | tail -f
# Podman - manage containers
# Skopeo - Manage images
# Buildah - Build image

# Install tools
sudo yum module install -y container-tools

# Connect to image registry
podman login -u admin -p redhat321 registry.access.redhat.com

# List downloaded images
podman images

# Pull image
podman pull registry.lab.example.com/rhel8/httpd-24:latest

# Run image
# -it = Interactive Terminal
podman run --name myweb -it registry.lab.example.com/rhel8/httpd-24 /bin/bash

# Run in container to view running processes
ps aux

# Show container user
id

# Stop container
exit

# Delete container after running
podman run --rm registry.lab.example.com/rhel8/httpd-24 httpd -v

# Run container in detached mode (background)
podman run -d registry.lab.example.com/rhel8/httpd-24:latest
# Show running containers
podman ps

# List downloaded images
podman images

# Interact with container
podman exec -it id# bash
id
ps -ef
# Running ss -plnt doesn't return as running isolated from OS
ss -plnt
exit


podman ps
# Stop container
podman stop goofy_goldwasser

podman ps
# Show archived container
podman ps -a

# View logs - if required do not use --rm as it will remove container and logs
podman logs id#

# Remove archived container
podman rm id#

# List container registries
grep ^[^#] /etc/containers/registries.conf

# List registries in Podman
podman info | grep -A15 registries
# Podman info
podman info | less

# Use Podman to search
podman search registry.redhat.io/mysql | head
# More detailed Podman searches
podman search --no-trunc registry.redhat.io/mysql | head -5
podman search --no-trunc --limit 3 --filter is-official=false registry.redhat.io/mysql | head

podman pull registry.lab.example.com/rhel8/httpd-24

podman images

# Gives metadata about image
skopeo inspect docker://registry.lab.example.com/rhel8/httpd-24 | less

podman images
# Remove image
podman rmi registry.lab.example.com/rhel8/httpd-24
podman images


##### LAB START #####
cat /home/student/.config/containers/registries.conf
# Search UBI images
podman search registry.lab.example.com/ubi

podman login -u admin -p redhat321 registry.lab.example.com

skopeo inspect docker://registry.lab.example.com/rhel8/httpd-24 | head -19

podman pull registry.lab.example.com/rhel8/httpd-24

podman inspect registry.lab.example.com/rhel8/httpd-24 | head -18

podman rmi registry.lab.example.com/rhel8/httpd-24

podman images
##### LAB FINISH #####


podman images
podman pull registry.lab.example.com/rhel8/mariadb-103:1-102
podman run -d registry.lab.example.com/rhel8/mariadb-103:1-102
podman ps
podman ps -a
podman logs registry.lab.example.com/rhel8/mariadb-103:1-102

# Run image with enviroment variables
podman run -d -e MYSQL_USER=dipsy -e MYSQL_PASSWORD=bongle -e MYSQL_DATABASE=tubbies -e MYSQL_ROOT_PASSWORD=niftyhat365 registry.lab.example.com/rhel8/mariadb-103:1-102
podman ps
podman stop id#
podman ps

podman rm id#
# Port forward port
podman run -d -p 3306:3306 -e MYSQL_USER=dipsy -e MYSQL_PASSWORD=bongle -e MYSQL_DATABASE=tubbies -e MYSQL_ROOT_PASSWORD=niftyhat365 registry.lab.example.com/rhel8/mariadb-103:1-102

podman ps
# Connect to DB
mysql -h127.0.0.1 -udipsy -pbongle -P3306

podman ps
podman stop id#

# podman kill -s 
# Create new container using forwarding and name of previous container instance
podman restart id#
podman rm id#
podman ps -a


##### LAB START #####
ssh student@servera
podman login -u admin -p redhat321 registry.lab.example.com
podman run -d --name mydb -e MYSQL_USER=user1 -e MYSQL_PASSWORD=redhat -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=redhat -p 3306:3306 registry.lab.example.com/rhel8/mariadb-103:1-102
podman ps

mysql -u user1 -p --port=3306 --host=127.0.0.1
# show databases;
podman stop mydb

# Interactive session
podman run --name myweb -it registry.lab.example.com/rhel8/httpd-24:1-105 /bin/bash
cat /etc/redhat-release
exit
# Exiting bash terminates container
podman ps -a

podman run --name mysecondweb -d registry.lab.example.com/rhel8/httpd-24:1-105
# Connect to container
podman exec mysecondweb uname -sr
# -l = last container name
podman exec -l uptime

# Statically name container --name
podman run --name myquickweb --rm registry.lab.example.com/rhel8/httpd-24:1-105 cat /etc/redhat-release

podman ps -a | grep myquickweb
podman ps -a
# Stop all containers
podman stop -a
# Delete all
podman rm -a
podman ps -a

exit
##### LAB END #####

# Persistent storage = SELinux context container_file_t (:Z)

##### LAB START #####
ssh student@servera
# Create Directory on container host
mkdir -pv ~/webcontent/html
echo "Hello World" > ~/webcontent/html/index.html
# Need r_x
ls -ld ~/webcontent/html/
# Need r__
ls -l ~/webcontent/html/index.html

# use --password-stdin instead of -p
podman login -u admin -p redhat321 registry.lab.example.com

# -v to mount storage from host to container
# :Z = SELinux context
podman run -d --name myweb -p 8080:8080 -v ~/webcontent:/var/www:Z registry.lab.example.com/rhel8/httpd-24:1-98
podman ps

curl http://localhost:8080/

skopeo inspect docker://registry.lab.example.com/rhel8/httpd-24 | grep -A5 RepoTags
podman stop myweb
podman rm myweb

podman run -d --name myweb -p 8080:8080 -v ~/webcontent:/var/www:Z registry.lab.example.com/rhel8/httpd-24:1-105
podman ps

curl http://localhost:8080/

logout
##### LAB FINISH #####

# Containers as a service

# Need root privileges
ls /etc/systemd/system
# For non-root use
mkdir -pv ~/.config/systemd/user/
# systemctl use --user option

podman generate space systemd

# Trigger user systemd services without needing to login first
loginctl enable linger
# Enable container as service

##### LAB START #####
ssh student@servera

sudo -i
# Add contsvc user to run containers
useradd contsvc

echo redhat | passwd --stdin contsvc

ssh contsvc@servera
# Create containers directory
mkdir -p ~/.config/containers/
# Copy registries file
cp /tmp/containers-services/registries.conf ~/.config/containers/
# Create persistent storage directory
mkdir -p ~/webcontent/html/
echo "Hello World" > ~/webcontent/html/index.html
ls -ld webcontent/html/
ls -l webcontent/html/index.html

podman login -u admin -p redhat321 registry.lab.example.com
podman run -d --name myweb -p 8080:8080 -v ~/webcontent:/var/www:Z registry.lab.example.com/rhel8/httpd-24:1-105
curl http://localhost:8080/

mkdir -p ~/.config/systemd/user/
cd ~/.config/systemd/user
# Generate files in current directory
podman generate systemd --name myweb --files --new
podman stop myweb
podman rm myweb

podman ps
# Re-initialise systemd as user
systemctl --user daemon-reload
systemctl --user enable --now container-myweb
podman ps
curl http://localhost:8080/

systemctl --user stop container-myweb
podman ps -a

systemctl --user start container-myweb
podman ps

loginctl enable-linger 
loginctl show-user contsvc # linger=yes
su -

systemctl reboot

ssh contsvc@servera

podman ps
curl http://localhost:8080/
logout

##### LAB END #####


##### LAB START #####
ssh containers@serverb

sudo -i
mkdir -pv /srv/web/
cd /srv/web/
tar xf /home/containers/rhcsa-compreview4/web-content.tgz
chown -R containers: /svr/web/
ls -ld /svr/web/
ls -ld /svr/web/html/
ls -l /svr/web/html/index/html

sudo yum module install -y container-tools | tail -4
podman login -u admin -p redhat321 registry.lab.example.com
podman run -d --name web -p 8888:8080 -v /srv/web:/var/www:Z -e HTTPD_MPM=event registry.lab.example.com/rhel8/httpd-24:1-105

curl http://localhost:8888/

mkdir -p ~/.config/systemd/user/

# Containers as a service

ssh student@servera

sudo -i
useradd contsvc

echo redhat | passwd --stdin contsvc

ssh contsvc@servera
mkdir -p ~/.config/containers/
cp /tmp/containers-services/registries.conf ~/.config/containers/
mkdir -p ~/webcontent/html/
echo "Hello World" > ~/webcontent/html/index.html
ls -ld webcontent/html/
ls -l webcontent/html/index.html

podman login -u admin -p redhat321 registry.lab.example.com
podman run -d --name myweb -p 8080:8080 -v ~/webcontent:/var/www:Z registry.lab.example.com/rhel8/httpd-24:1-105
curl http://localhost:8080/

mkdir -p ~/.config/systemd/user/
cd ~/.config/systemd/user/
podman generate systemd --name web --files --new
podman ps

podman stop web
podman rm web

systemctl --user daemon-reload
systemctl --user enable --now container-web.service

loginctl enable-linger
###########
ssh student@serverb
sudo yum module install -y container-tools | tail -4

ssh podsvc@serverb
podman login -u admin -p redhat321 registry.lab.example.com
# Grep for 4 lines after RepoTags
skopeo inspect docker://registry.lab.example.com/rhel8/mariadb-103 | grep -A4 RepoTags
mkdir -pv ~/db_data/

chmod 777 ~/db_data

podman run -d --name inventorydb -p 13306:3306 -v /home/podsvc/db_data:/var/lib/mysql/data:Z -e MYSQL_USER=operator1 -e MYSQL_PASSWORD=redhat -e MYSQL_DATABASE=inventory -e MYSQL_ROOT_PASSWORD=redhat registry.lab.example.com/rhel8/mariadb-103:1-86

containers-review/testdb.sh
cat containers-review/testdb.sh
# #!/bin/bash
# 
# echo 'Testing access to the database'
# sleep 5
# mysql -u operator1 --password=redhat \
# --port=13306 --host=127.0.0.1 -e 'show databases' | \
# grep -qwi inventory
# if [ $? -eq 0 ]
# then
#   echo 'SUCCESS'
# else
# echo 'FAILED'
# fi

mkdir -p ~/.config/systemd/user/
cd ~/.config/systemd/user/
podman generate systemd --name inventorydb --files --new

podman stop inventorydb
podman rm inventorydb

systemctl --user daemon-reload
systemctl --user enable --now container-inventorydb.service

loginctl enable-linger
podman ps
