# Verbose cURL download
curl.exe -LO https://github.com/github/backup-utils/releases/download/v3.6.0/github-backup-utils-v3.6.0.tar.gz -v

# Pull down code from Bitbucket
curl --silent -H "Authorization: Bearer $Token" https://bitbucket.com/projects/TopSecret/repos/batmobile_firmware/firmware_upgrade.sh?at=refs%2Fheads%2fmaster -o /var/firmware/firmware_upgrade.sh

# Check redirects
curl -LO https://github.com/github/backup-utils/releases/download/v3.8.0/github-backup-utils-v3.8.0.tar.gz -v

# Download
curl https://artifactory.test/artifactory/github-remote/github/backup-utils/releases/downloads/v3.8.0/githun-backup-utils-v3.8.0.tar.gz -o github-backup-utils-v3.8.0.tar.gz -kvvv
