mkdir -p .ssh/authorized_keys

echo $PATH

# Add path
vi .bashrc

#
# Add following line to add to path
# export PATH=~:$HOME/ocp:$PATH
#

source .bashrc
source ./.bashrc

curl https://artifactory.wayeent.com/artifactory/OpenShift/oc-4.10.6.tar.gz -o ./oc-4.10.6.tar.gz

mkdir ocp

tar xvzf oc-4.10.6.tar.gz -C ~/ocp/
# mv kubectl oc README.md ocp/

ls -al ocp

oc login -u admin -p admin https://api.crc.testing:6443 --insecure-skip-tls-verify=true

# Create new project named ocp-sqldb
oc new-project ocp-sqldb