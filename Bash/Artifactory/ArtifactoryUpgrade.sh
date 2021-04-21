# !/bin/bash

# Source variables from artup.conf
ls ./artup.conf && . ./artup.conf

# Download the RPM package
if curl --silent -o "/var/tmp/$VERSION.rpm" -L "https://$PROD/artifactory/generic-team-local/$VERSION.rpm"; then
    echo ls -l /var/tmp/$VERSION --block-size=M >> ./artup.log
else
    echo "Download has not completed successfully" >> ./artup.log
    exit 1
fi

# Stop the Artifactory service and if successful write status to log
systemctl stop artifactory.service && echo systemctl status artifactory.service >> ./artup.log

# Install the RPM package
rpm /var/tmp/$VERSION

# Return status of the installation and write to log
if $? = 0 ; then
    systemctl start artifactory.service
    echo "Installation has completed without errors" >> ./artup.log
else $? ! = 0
    echo "Installation errors have been detected" >> ./artup.log
fi
