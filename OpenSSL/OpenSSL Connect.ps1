# C:\Program Files\Git\usr\bin\openssl.exe

echo | openssl s_client -connect example.com:443

openssl s_client -CApath /etc/ssl/certs/ -connect address.com:443

openssl s_client -showcerts -connect google.com:443
openssl s_client -connect google.com:443