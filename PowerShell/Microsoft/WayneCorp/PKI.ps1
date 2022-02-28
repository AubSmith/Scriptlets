# Renew Certification Authority certificate
certutil -f -renewcert reusekeys
Restart-Service certsvc

# Uninstall CA
Uninstall-AdcsCertificationAuthority