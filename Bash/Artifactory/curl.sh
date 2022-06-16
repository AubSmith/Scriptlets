curl -uadmin:password https://arturl.com/artifactory/api/system/ping

# Jfrog Artifactory Verbose
curl https://artifactory.url/artifactory/api/system/ping -vvv
curl -Sv https://artifactory.url/artifactory/api/system/ping

# Jfrog Artifactory Insecure SSL
curl https://artifactory.url/artifactory/api/system/ping -k

# Jfrog Artifactory Download
# Download file to current working directory with same filename as remote source
curl -O https://artifactory.url/artifactory/generic-software-virtual/path/path/file.txt

# Download file to specific directory with filename
curl -o /var/tmp/file.txt/var/tmp/file.txt https://artifactory.url/artifactory/generic-software-virtual/path/path/file.txt

# Connection Test - openssl
echo | openssl s_client -connect artifactory.url:443
echo | openssl s_client -connect distribution.url:443

curl -X PUT -u myUser:myPassword -T test.txt "http://localhost:8081/artifactory/libs-release-local/test/test.txt"

# -L redirects -O filenamed as downloaded -v verbose
curl -LOv "http://localhost:8081/artifactory/libs-release-local/test/test.txt"

# Test docker registry with domain cert
curl --cacert domain.crt https://your.registry:5000/v2/_catalog

# SSL Certificates
curl -sSLK https://artifactory.waynecorp.com/artifactory/repo/certs/prod.tar | tar xf - -C /etc/pki/ca-trust/source/anchors/ \
&& cd /etc/pki/ca-trust/source/anchors/ \
&& update-ca-trust extract

# Check for redirects
curl -Lov https://downloads.cypress.com/desktop/10.0.3 -v