source Credentials.txt

curl --user ${user}:${token} -X POST https://artifactory.url.com/artifactory/api/replication/execute/repo