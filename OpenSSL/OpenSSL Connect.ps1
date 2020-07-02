echo | openssl s_client -connect example.com:443

openssl s_client -CApath /etc/ssl/certs/ -connect address.com:443