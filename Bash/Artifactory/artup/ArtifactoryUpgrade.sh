# !/bin/bash

# verify_env () {
#   if [ "$#" - lt 1 ] ; then
#        echo "Usage: $0 Environment"
#        exit 1
#   else echo "Environment $1 will be upgraded." >> ./artup.log
#   fi

# Source variables from artup.conf
ls ./artup.conf && . ./artup.conf

# Download the RPM package
if curl --silent -o "/var/tmp/$VERSION.rpm" -L "https://$PROD/artifactory/generic-team-local/$VERSION.rpm"; then
    echo ls -l /var/tmp/$VERSION --block-size=M >> ./artup.log
else
    echo "Download has not completed successfully" >> ./artup.log
    exit 1
fi

# Create system export
curl --header "Content-Type: application/json" --header "X-JFrog-Art-Api:APIKEY" --request POST --data @system-export.json https://$ARTENV/artifactory/api/export/system

# Stop the Artifactory service and if successful write status to log
if sudo systemctl stop artifactory.service; then
    systemctl is-failed --quiet artifactory.service && echo "Artifactory service is stopped" >> ./artup.log
else systemctl is-failed --quiet artifactory.service || echo "Artifactory service has not stopped" >> ./artup.log
    exit 1
fi

# Stop the httpd service and if successful write status to log
if sudo systemctl stop httpd.service; then
    systemctl is-failed --quiet httpd.service && echo "Httpd service is stopped" >> ./artup.log
else systemctl is-failed --quiet httpd.service || echo "Httpd service has not stopped" >> ./artup.log
    exit 1
fi

# Install the RPM package
sudo /bin/rpm -U /var/tmp/$VERSION

# Return status of the installation and write to log
if $? = 0 ; then
    sudo systemctl start artifactory.service
    systemctl is-active --quiet artifactory.service && echo "Service is running" >> ./artup.log
else $? ! = 0
    echo "Installation errors have been detected" >> ./artup.log
fi

# Start the httpd service and if successful write status to log
if sudo systemctl stop httpd.service; then
    systemctl is-active --quiet httpd.service && echo "Httpd service is running" >> ./artup.log
else systemctl is-active --quiet httpd.service || echo "Httpd service has not active" >> ./artup.log
    exit 1
fi

# Start the Artifactory service and if successful write status to log
if sudo systemctl stop artifactory.service; then
    systemctl is-active --quiet artifactory.service && echo "Artifactory service is active" >> ./artup.log
else systemctl is-active --quiet artifactory.service || echo "Artifactory service has not active" >> ./artup.log
    exit 1
fi
