# Distribution
curl https://distribution.url/api/v1/system/ping

# Jfrog Artifactory
curl https://artifactory.url/artifactory/api/system/ping

# Jfrog Mission Control
curl https://missioncontrol.url/api/v3/ping

# Jfrog Artifactory Insecure SSL
curl https://artifactory.url/artifactory/api/system/ping -k

# Create repo
curl -u admin:password -X PUT -H "Content-Type: application/json" -d '{"key":"value","key":"value"}' https://artifactory.url/artifactory/api/repositories/generic-tooling-local