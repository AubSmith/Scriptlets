curl -uusername:token https://artifactory.com/artifactory/api/repositories?packageType=docker

curl -uusername:token -X PUT -H "Content-Type: application/json" -d @./docker-prod-virtual.json https://artifactory.com/artifactory/api/repositories/docker-prod-virtual

curl -uusername:token -X DELETE https://artifactory.com/artifactory/api/repositories/docker-prod-virtual