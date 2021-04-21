import uncurl

print(uncurl.parse("curl -uadmin:password -XPOST 'http://localhost:8081/artifactory/api/security/token' -d 'username=johnq' -d 'scope=member-of-groups:readers' -d 'expires_in=3600'"))

# Prints
requests.post("http://localhost:8081/artifactory/api/security/token",
    data='expires_in=3600',
    headers={},
    cookies={},
    auth=('admin', 'password'),
)