sudo yum -y install docker
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker $(whoami)
sudo systemctl enable docker.service
sudo shutdown -r now
