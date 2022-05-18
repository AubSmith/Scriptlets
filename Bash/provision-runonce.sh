if [ -f "/var/vagrant_provision" ]; then
  exit 0
fi

# Actual shell commands here.

touch /var/vagrant_provision