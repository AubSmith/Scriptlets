# Apache
sudo yum install httpd
sudo service httpd start
systemctl status httpd.service

# Java
which java
java -version

# Artifactory
unzip -d /var/opt/jfrog /var/tmp/jfrog-artifactory-pro-6.9.0.zip
sudo mv /var/opt/jfrog/artifactory-pro-6.9.0 /var/opt/jfrog/artifactory
chmod 777 /var/opt/jfrog/artifactory/*
mkdir /var/opt/jfrog/run
chmod 777 /var/opt/jfrog/run
sudo /var/opt/jfrog/artifactory/bin/installService.sh
sudo vi /etc/opt/jfrog/artifactory/default
sudo /var/opt/jfrog/artifactory/bin/artifactoryManage.sh start
systemctl status artifactory.service


# Uninstall
systemctl stop artifactory.service
systemctl disable artifactory.service
rm /etc/systemd/system/artifactory.service
rm /etc/systemd/system/artifactory.service # and symlinks that might be related
rm /usr/lib/systemd/system/artifactory.service 
rm /usr/lib/systemd/system/artifactory.service # and symlinks that might be related
systemctl daemon-reload
systemctl reset-failed
cd /etc/init.d/
ls
