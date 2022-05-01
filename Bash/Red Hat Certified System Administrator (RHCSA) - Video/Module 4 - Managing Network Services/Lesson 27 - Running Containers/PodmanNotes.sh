# --latest (-l) flag - use the latest (last) container that Podman created
podman create ubi8 echo hi

podman start --attach -l

podman inspect -l --format '{{ .Id }}'

podman rm -l


# --replace - if another container with same name already exists, replace and remove it. The default is false.
podman run --name test ubi8 echo hello # wrong container - meant to run goodbye

podman run --name test ubi8 echo goodbye # correct container

podman run --replace --name test ubi8 echo goodbye # fixed


# Stop all Podman containers
podman stop --all

# Remove all Podman containers
podman rm --all

# Remove all Podman images
podman rmi --all

# Remove all containers even if they are running
podman rm --all -t 0 --force # -t = immediately send SIGKILL


# --ignore - tells Podman to ignore errors when object does not exist
podman rm --ignore test1 test2 test3 # All podman rm* commands have --ignore option


# Set correct timezone
podman run --tz=local fedora date

podman run --tz=Iceland fedora date


# If you want to modify any container you create with a time zone automatically
# add a timezone.conf file on your system in /etc/containers/containers.conf.d or
# $HOME/.config/containers/containers.conf.d that looks like this:

# $ cat $HOME/.config/containers/containers.conf.d/timezone.conf
# [containers]
# tz=”local”

podman run fedora date


# Create pod
podman run -dt --pod new:example docker.io/library/mysql:latest
podman run -dt --pod example quay.io/libpod/alpine_nginx

podman pod ls
podman ps --pod


#########################################################################################
# Create additional image stores
podman images

sudo mkdir --mode=u+rwx,g+rws /var/sharedstore
sudo chgrp -R wheel /var/sharedstore

podman --root /var/sharedstore/ pull fedora

sudo semanage fcontext -a -e /var/lib/containers/storage /var/sharedstore

sudo restorecon -r /var/sharedstore/

# Then edit sudo restorecon -r /var/sharedstore/
# root Users - /etc/containers/storage.conf
# Standard users - $HOME/.config/containers/storage.conf

# [storage]
# driver = "overlay"
# [storage.options]
# additionalimagestores = [ "/var/sharedstore"
# ]

 # root can share additional image store. root must edit /etc/containers/storage.conf

podman images
podman run -it --rm fedora cat /etc/redhat-release

###########################################################################################

podman images
podman network ls

# Reset Podman - removes everything
podman system reset –force

podman images
podman network ls


# play kube = import Kubernetes yaml file
# generate kube 
sudo podman play kube lamp.yaml
