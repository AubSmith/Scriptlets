# !/bin/bash

# Import variables
if ls ./ghe.conf; then
    . ./ghe.conf
else echo "The GitHub Enterprise configuration file is missing" >> ./ghe.log
    exit 1
fi

# Download the tarball from Artifactory
if curl --silent -o "/var/tmp/github-backup-utils-v$NEW_VERSION.tar.gz" -L "https://$PRODUCTION/artifactory/generic-ots-ghe-local/github-backup-utils-v$NEW_VERSION.tar.gz"; then
    echo ls -l /var/tmp/github-backup-utils-v$NEW_VERSION --block-size=M >> ./ghe.log
else
    echo "Artifactory download has failed" >> ./ghe.log
    exit 1
fi

# Backup the old version
if mv /app/ghe/github/backup-utils /app/ghe/github-backup-utils-$OLD_VERSION/; then
    echo "Backup utils version $OLD_VERSION backed up successfully" >> ./ghe.log
    echo ls -l /app/ghe/github-backup-utils-$OLD_VERSION >> ./ghe.log
else
    echo "Artifactory download has failed" >> ./ghe.log
    exit 1
fi

# Extract the new version
if tar -xvf github-backup-utils-$NEW_VERSION -C /app/ghe/github && mv /app/ghe/github/github-backup-utils-$NEW_VERSION.tar /app/ghe/github/backup-utils/ ; then
    echo "$NEW_VERSION extracted successfully" >> ./ghe.log
    echo ls -l /app/ghe/github/backup-utils/ >> ./ghe.log
else
    echo "$NEW_VERSION extract has failed" >> ./ghe.log
    exit 1

# Download backup utilities config file from Bitbucket
if curl --silent -H "Authorization: Bearer $Token" $URL -o /app/ghe/github/backup-utils/$TMP_FILE; then
    echo "Backup utils config file deployed successfully" >> ./ghe.log
else
    echo "Backup utils config file deployment has failed" >> ./ghe.log
    exit 1
fi

# Perform a backup

# Script completed successfully
echo "Upgrade of the GitHub backup utilities to version $NEW_VERSION has completed successfully" >> ./ghe.log
exit 0
