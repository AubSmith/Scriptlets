# Install management tools
sudo yum module install container-tools

# Run container
podman run -d nginx

# Login registries - use Red Hat account credentials
podman login

# Access specific registry
podman pull registry.access.redhat.com/ubi8/ubi:latest

podman run nginx

podman -d nginx

podman ps

# See containers that ran previously
podman ps --all

podman run ubuntu

podman ps

podman ps --all

podman run -it ubuntu

ps aux
ls

# Containers are minimal - no networking
ip a

cat /etc/os-release
uname -r

Ctrl-P, Ctrl-Q

# Install docker cli - allows using docker commands from podman
docker ps # Select y

uname -r

podman login

podman pull registry.access.redhat.com/ubu8/ubi:latest