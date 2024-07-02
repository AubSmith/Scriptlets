# View packer options
Packer

# Pass variables
packer build \
  -var 'aws_access_key=secret' \
  -var 'aws_secret_key=reallysecret' \
  initial_ubuntu.json

  # OR

  # Use variables.json in initial_ubuntu directory
  packer build \
  -var-file=variables.json \
  initial_ubuntu.json
# Can use multiple variable files
  packer build \
  -var-file=variables.json \
  initial_ubuntu2.json


  # Multiple builders
 "builders": [
 {
   "name": "amazon1",
   "type": "amazon-ebs",
. . .
  },
  {
    "name": "amazon2",
    "type": "amazon-ebs",
  }
]


# Validate template
packer validate initial_ubuntu.json

# Inspect template
packer inspect initial_ubuntu.json

# Build
packer build \
  -var 'aws_access_key=secret' \
  -var 'aws_secret_key=reallysecret' \
  initial_ubuntu.json

  # The inline commands are executed with a shebang of 
  # /bin/sh -e. You can adjust this using the
  # inline_shebang key.

  # Script provisioner
  "provisioners": [{
  "type": "shell",
  "scripts": [
    "install.sh",
    "post-install.sh"
  ]
}]

# File provisioner