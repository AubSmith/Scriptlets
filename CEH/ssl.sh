# Linux trust anchor - place cert
# /usr/share/pki/ca-trust-source/anchors/
# OR
# /etc/pki/ca-trust/source/anchors/
update-ca-trust


# Confirm certificate trust
trust list

trust list | grep label ; 
trust list | grep label | wc -l

# SSL certificate trust verification
openssl s_client -showcerts -connect servicename.com:443

openssl s_client -showcerts -connect servicename.com:443 -CAfile ./cacerts

cat /dev/null | openssl s_client -showcerts -connect servicename.com:443


# cURL SSL certificate trust verification
curl --verbose https://servicename.com


# Retrieve certificate serial number and thumbprint
openssl x509 -noout -serial -fingerprint -sha1 -inform dem -in RootCertificateHere.crt

