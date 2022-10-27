# Verify certificate
openssl verify -CAfile C:\ca.pem C:\mycert.cer

# Extract CSR info
openssl req -in shellhacks.com.csr -text -noout

# Verify signature
openssl req -in shellhacks.com.csr -noout -verify

# Who cert will be issued to
openssl req -in shellhacks.com.csr -noout -subject

# Public Key
openssl req -in shellhacks.com.csr -noout -pubkey