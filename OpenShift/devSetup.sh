mkdir -p .ssh/authorized_keys

# Add path
vi .bashrc

source .bashrc
source ./.bashrc

curl https://artifactory.wayeent.com/artifactory/OpenShift/oc-4.10.6.tar.gz -o ./oc-4.10.6.tar.gz

tar xvzf oc-4.10.6.tar.gz

mkdir ocp

mv kubectl oc README.md ocp/

ls -al ocp

oc login -u admin -p admin https://api.crc.testing:6443 --insecure-skip-tls-verify=true

