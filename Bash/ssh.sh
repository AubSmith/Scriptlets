ssh ip -X # Xforwarding - allow graphical UI over SSH
ssh ip # Login as current user
ssh newuser@ip # Login as newuser
ssh ethan@computestick
exit # Exit SSH session

# Setup SSH
ssh-keygen
ssh-keygen -t ed25519
ssh-keygen -t rsa
ssh-copy-id ip
# or
ssh-copy-id user@ip

ssh -vvv -p 122 user@github.com

sudo apt-get install openssh-server

# Change SSH port and Auth
sudo vi /etc/ssh/sshd_config
# PermitRootLogin no
# AllowUsers ethan
sudo systemctl restart ssh

# Dump all certs in the chain

openssl s_client -showcerts -verify 5 -connect wikipedia.org:443 < /dev/null | awk '/BEGIN/,/END/{ if(/BEGIN/){a++}; out="cert"a".pem"; print >out}'; for cert in *.pem; do newname=$(openssl x509 -noout -subject -in $cert | sed -nE 's/.*CN ?= ?(.*)/\1/; s/[ ,.*]/_/g; s/__/_/g; s/_-_/-/; s/^_//g;p' | tr '[:upper:]' '[:lower:]').pem; echo "${newname}"; mv "${cert}" "${newname}"; done

# Store public keys for remote access
.ssh/authorized_keys