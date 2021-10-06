# Download JSON config
curl -uusername:token https://artifactory.com/artifactory/generic-project-local/request/chef-project-local.json -O ./chef-project-local.json
curl -uusername:token https://artifactory.com/artifactory/generic-project-local/request/chef-project-virtual.json -O ./chef-project-virtual.json

# Create repo
curl -uusername:token -X PUT -H "Content-Type: application/json" -d @./chef-project-local.json https://artifactory.com/artifactory/api/repositories/chef-project-local
curl -uusername:token -X PUT -H "Content-Type: application/json" -d @./chef-project-virtual.json https://artifactory.com/artifactory/api/repositories/chef-project-virtual

# Verify repo
curl -uusername:token https://artifactory.com/artifactory/api/repositories?packageType=chef

# Delete repo
curl -uusername:token -X DELETE https://artifactory.com/artifactory/api/repositories/chef-project-local
curl -uusername:token -X DELETE https://artifactory.com/artifactory/api/repositories/chef-project-virtual