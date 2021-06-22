# Initiate Replication
curl -u username:token -X POST "https://artifactory.url/artifactory/api/replication/execute/$repo"

# Verify Replication
curl -H 'X-Jfrog-Art-Api:token' -X GET "https://artifactory.url/artifactory/api/replication/$repo"