curl -uadmin:password https://arturl.com/artifactory/api/system/ping

# Jfrog Artifactory Verbose
curl https://artifactory.url/artifactory/api/system/ping -vvv
curl -Sv https://artifactory.url/artifactory/api/system/ping

# Jfrog Artifactory Insecure SSL
curl https://artifactory.url/artifactory/api/system/ping -k

# Jfrog Artifactory Download
curl https://artifactory.url/artifactory/generic-software-virtual/path/path/file.txt -o /var/tmp/file.txt

# Connection Test - openssl
echo | openssl s_client -connect artifactory.url:443
echo | openssl s_client -connect distribution.url:443