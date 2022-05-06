sudo yum -y install podman
sudo service podman start
sudo groupadd podman
sudo usermod -aG podman $(whoami)
sudo systemctl enable podman.service 
sudo shutdown -r now 

sudo podman login docker-redhat-remote.artifactory.nz.service.wayneent.com

sudo podman pull docker-redhat-remote.artifactory.nz.service.wayneent.com/ubi8/python-38:latest

# Find images
podman images

# Tag new image
podman tag 487b5552b51 docker-redhat-remote.artifactory.nz.service.wayneent.com/hello-world:1.0.0

# Sub-domain push
podman push docker-redhat-remote.artifactory.nz.service.wayneent.com/hellow-world

# Info
podman info
podman version