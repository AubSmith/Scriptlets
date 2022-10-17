# Console on appliance

ghe-check-disk-usage

ghe-logs-tail

# Give organization owner privileges in a specific organization to a single user
ghe-org-admin-promote -u USERNAME -o ORGANIZATION

# Give organization owner privileges in all organizations to a specific site admin
ghe-org-admin-promote -u USERNAME

# Give organization owner privileges in a specific organization to all site admins
ghe-org-admin-promote -o ORGANIZATION

# Give organization owner privileges in all organizations to all site admins
ghe-org-admin-promote -a

# This utility lists all of the services that have been started/stopped or are running/waiting
ghe-service-list

# Set a new password to authenticate into the Management Console
ghe-set-password

# This utility allows you to install a custom root CA certificate
ghe-ssl-ca-certificate-install -h
ghe-ssl-ca-certificate-install -c /path/to/certificate # Install
