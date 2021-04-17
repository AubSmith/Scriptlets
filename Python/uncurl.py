# Elevate privileges
# python -m pip install --upgrade pip
# pip install uncurl

import uncurl

print(uncurl.parse("curl -uusername:password -XPOST 'https://artifactory.com/artifactory/api/security/token' -d 'username=username' -d 'scope=member-of-groups:groupname' -d 'expires_in=0' -d 'refreshable=true' "))
