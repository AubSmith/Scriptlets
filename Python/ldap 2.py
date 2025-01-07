import ldap
l = ldap.initialize('ldap://ldapserver')
username = "uid=%s,ou=People,dc=mydotcom,dc=com" % username
password = "my password"
try:
    l.protocol_version = ldap.VERSION3
    l.simple_bind_s(username, password)
    valid = True
except Exception, error:
    print error