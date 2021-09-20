# Validate Circle of Trust
curl -uaccess-admin -X Post http://localhost:8081/artifactory/api/access/api/v1/system/federation/validate_server -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"url\": \"http://artifactory.com/artifactory/api/access\"}" -vvl
curl -uaccess-admin -X Post http://localhost:8081/artifactory/api/access/api/v1/system/federation/validate_server -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"url\": \"http://external.artifactory.com/artifactory/api/access\"}" -vvl

# Get Service ID
curl -uusername:token -X GET "https://artifactory.com/artifactory/api/system/service_id" -k

# Verify
curl https://artifactory.com/artifactory/api/system/ping
