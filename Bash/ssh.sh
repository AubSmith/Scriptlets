ssh ip -X # Xforwarding - allow graphical UI over SSH
ssh ip # Login as current user
ssh newuser@ip # Login as newuser

# Setup SSH
ssh-keygen
ssh-copy-id ip
# or
ssh-copy-id user@ip



# Dump all certs in the chain

openssl s_client -showcerts -verify 5 -connect wikipedia.org:443 < /dev/null | awk '/BEGIN/,/END/{ if(/BEGIN/){a++}; out="cert"a".pem"; print >out}'; for cert in *.pem; do newname=$(openssl x509 -noout -subject -in $cert | sed -nE 's/.*CN ?= ?(.*)/\1/; s/[ ,.*]/_/g; s/__/_/g; s/_-_/-/; s/^_//g;p' | tr '[:upper:]' '[:lower:]').pem; echo "${newname}"; mv "${cert}" "${newname}"; done