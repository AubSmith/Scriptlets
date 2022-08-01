# Windows
C:\Users\%USERNAME%\.pip\pip.ini

[global]
index-url = https://artifactory.service.waynecorp.com/artifactory/api/pypi/pypi-remote/simple

# Linux
~/.pip/pip.conf

[global]
index-url = https://artifactory.service.waynecorp.com/artifactory/api/pypi/pypi-remote/simple
cert = /etc/ssl/certs/ca-bundle.trust.crt

# Pip Timeout
pip install simplerot --default-timeout=100
