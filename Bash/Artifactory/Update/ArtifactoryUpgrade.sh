# !/bin/bash

# Source variables from artup.conf
if ls ./artup.conf ; then
    . ./artup.conf
else echo "Configuration files are missing" >> ./artup.log
    exit 1
fi

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
else echo "Artifactory service has not been stopped" >> ./artup.log
    exit 1
fi

# Stop the httpd service and if successful write status to log
if sudo systemctl stop httpd.service; then
    systemctl is-failed --quiet httpd.service && echo "Httpd service is stopped" >> ./artup.log
else echo "Httpd service has not been stopped" >> ./artup.log
    exit 1
fi

echo -e "\n" >> ./artup.log
echo "Installing the RPM package" >> ./artup.log
echo -e "\n" >> ./artup.log

# Install the RPM package
sudo /bin/rpm -U /var/tmp/$VERSION $>> ./artup.log

echo -e "\n" >> ./artup.log

# Return status of the installation and write to log
if sudo systemctl start artifactory.service ; then
    systemctl is-active --quiet artifactory.service && echo "Service is running" >> ./artup.log
else echo "Installation errors have been detected" >> ./artup.log
fi

# Start the httpd service and if successful write status to log
if sudo systemctl start httpd.service ; then
    systemctl is-active --quiet httpd.service && echo "Httpd service is running" >> ./artup.log
else echo "Httpd service is not running" >> ./artup.log
fi

# Start the Artifactory service and if successful write status to log
if sudo systemctl stop artifactory.service ; then
    systemctl is-active --quiet artifactory.service && echo "Artifactory service is active" >> ./artup.log
else echo "Artifactory service is not running" >> ./artup.log
fi

echo "Script $0 execution is complete!"
exit 0