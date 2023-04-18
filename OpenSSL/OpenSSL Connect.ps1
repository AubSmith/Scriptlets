# C:\Program Files\Git\usr\bin\openssl.exe

echo | openssl s_client -connect wayneent.com:443

openssl s_client -CApath /etc/ssl/certs/ -connect address.com:443

openssl s_client -showcerts -connect google.com:443
openssl s_client -connect google.com:443

# Use SNI
# Server Name Identification (SNI) is an extension of the Secure Socket Layer (SSL) and Transport Layer Security (TLS) protocol that enables you to host multiple SSL certificates on a single unique Internet Protocol (IP) address.
echo | openssl s_client -connect wayneent.com:443 -servername  wayneent.com -showcerts

openssl s_client -connect webserver.wayneent.com:433 -quiet # Returns webserver certificate
openssl s_client -connect webserver.wayneent.com:4433 -servername sniservice2.wayneent.com -quiet # Returns sniservice2 certificate
