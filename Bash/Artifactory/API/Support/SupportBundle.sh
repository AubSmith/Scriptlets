# Create
curl -X POST -u admin:password -H "Content-Type: application/json" "https://artifactory.url/artifactory/api/system/support/bundle" -d @/var/tmp/SupportBundleCreate.json

# Download
curl -X GET -u admin:password "https://artifactory.url/artifactory/api/system/support/bundle/20210102-12345-111" -o /var/tmp/12345.zip

# Upload
curl -t -T filename.ext "https://supportlogs.jfrog.com/logs/12345/"
