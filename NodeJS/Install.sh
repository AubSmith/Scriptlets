# Red Hat Software Collections
sudo subscription-manager repos --list | egrep rhscl

sudo subscription-manager repos --enable rhel-server-rhscl-7-rpms
sudo subscription-manager repos --enable rhel-7-server-optional-rpms

sudo yum install rh-nodejs16

# Enable software collection
scl enable rh-nodejs16 bash

node --version
npm --version

npm install crypress