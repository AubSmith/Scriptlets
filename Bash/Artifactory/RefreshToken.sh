# Non-expiring token
curl -uasmith:token -X POST 'https://artifactory.com/artifactory/api/security/token' -d "username=asmith" -d "expires_in=3600" -d "scope=member-of-groups:readers" -d "refreshable=true" 

# Refresh token
curl -uasmith:token -X POST 'https://artifactory.com/artifactory/api/security/token' -d "username=asmith" -d "expires_in=3600" -d "scope=member-of-groups:readers" -d "refreshable=true" 

# Expiring
curl -uadmin:token -X POST 'https://artifactory.com/artifactory/api/security/token' -d "grant_type=refresh_token" -d "refresh_token=abcdef123456" -d "access_token="