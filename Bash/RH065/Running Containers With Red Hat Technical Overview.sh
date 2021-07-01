sudo yum module install -y container-tools | tail -f
# Podman - manage containers
# Skopeo - Manage images
# Buildah - Build image

podman login -u admin -p redhat321 registry.access.redhat.com

podman images

podman pull registry.lab.example.com/rhel8/httpd-24:latest

podman run --name myweb -it registry.lab.example.com/rhel8/httpd-24 /bin/bash

ps aux

id

exit

podman run --rm registry.lab.example.com/rhel8/httpd-24 httpd -v

podman ps

podman run -d registry.lab.example.com/rhel8/httpd-24:latest

podman ps

podman images

podman exec -it id# bash

id

ps -ef

ss -plnt

exit

podman ps

podman stop goofy_goldwasser

podman ps
podman ps -a

podman logs id#

podman rm id#

grep ^[^#] /etc/containers/registries.conf

podman info | grep -A15 registries

podman info | less

podman search registry.redhat.io/mysql | head

podman search --no-trunc registry.redhat.io/mysql | head -5

podman search --no-trunc --limit 3 --filter is-official=false registry.redhat.io/mysql | head

podman pull registry.lab.example.com/rhel8/httpd-24

podman images

skopeo inspect docker://registry.lab.example.com/rhel8/httpd-24 | less

podman images
podman rmi registry.lab.example.com/rhel8/httpd-24
podman images



lab containers-managing start

cat /home/student/.config/containers/registries.conf
podman search registry.lab.example.com/ubi

podman login -u admin -p redhat321 registry.lab.example.com

skopeo inspect docker://registry.lab.example.com/rhel8/httpd-24 | head -19

podman pull registry.lab.example.com/rhel8/httpd-24

podman inspect registry.lab.example.com/rhel8/httpd-24 | head -18

podman rmi registry.lab.example.com/rhel8/httpd-24

podman images
lab container-managing finish



podman images
podman pull registry.lab.example.com/rhel8/mariadb-103:1-102
podman run -d registry.lab.example.com/rhel8/mariadb-103:1-102
podman ps
podman ps -a
podman logs registry.lab.example.com/rhel8/mariadb-103:1-102

podman run -d -e MYSQL_USER=dipsy -e MYSQL_PASSWORD=bongle -e MYSQL_DATABASE=tubbies -e MYSQL_ROOT_PASSWORD=niftyhat365 registry.lab.example.com/rhel8/mariadb-103:1-102
podman ps
podman stop id#
podman ps

podman rm id#

podman run -d -p 3306:3306 -e MYSQL_USER=dipsy -e MYSQL_PASSWORD=bongle -e MYSQL_DATABASE=tubbies -e MYSQL_ROOT_PASSWORD=niftyhat365 registry.lab.example.com/rhel8/mariadb-103:1-102

podman ps

mysql -h127.0.0.1 -udipsy -pbongle -P3306
podman ps
podman stop id#
# podman kill -s 
podman restart id#
podman rm id#
podman ps -a



lab containers-advanced start

ssh student@servera
podman login -u admin -p redhat321 registry.lab.example.com
podman run -d --name mydb -e MYSQL_USER=user1 -e MYSQL_PASSWORD=redhat -e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=redhat registry.lab.example.com/rhel8/mariadb-103:1-102
podman ps

mysql -u user1 -p --port=3306 --host=127.0.0.1
podman stop mydb

podman run --name myweb -it registry.lab.example.com/rhel8/httpd-24:1-105 /bin/bash
cat /etc/redhat-release
exit

podman ps -a

podman run --name mysecondweb -d registry.lab.example.com/rhel8/httpd-24:1-105

podman exec mysecondweb uname -sr
podman exec -l uptime

podman run --name myquickweb --rm registry.lab.example.com/rhel8/httpd-24:1-105 cat /etc/redhat-release

podman ps -a | grep myquickweb
podman ps -a
podman stop -a
podman rem -a
podman ps -a

exit
lab containers-advanced finish


# Persistent storage = SELinux context container_file_t (:Z)
lab containers-storage start

ssh student@servera
mkdir -pv ~/webcontent/html
echo "Hello World" > ~/webcontent/html/index.html
ls -ld ~/webcontent/html/
ls -l ~/webcontent/html/index.html

podman login -u admin -p redhat321 registry.lab.example.com
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

lab containers-storage finish


ls /etc/systemd/system
mkdir -pv ~/.config/systemd/user/

# Containers as a service

lab containers-services start

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
cd ~/.config/systemd/user
podman generate systemd --name myweb --files --new
podman stop myweb
podman rm myweb

podman ps

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

lab containers-services finish


lab rhcsa-compreview4 start
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

lab containers-services start

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

lab rhcsa-compreview4 grade


lab containers-review start

ssh student@serverb
sudo yum module install -y container-tools | tail -4

ssh podsvc@serverb
podman login -u admin -p redhat321 registry.lab.example.com
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

lab containers-review grade
lab containers-review finish