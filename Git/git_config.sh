# Setup new Git user
git config --global user.name "Ethan Smith"
git config --global user.email "Aubrey.Smith@orcon.net.nz"

# Shell Command: Install 'code' command in path
git config --global core.editor vscode

# Create new SSH key
ssh-keygen -t rsa -b 4096 -C "aubrey.smith@orcon.net.nz"

# Git remote
git remote add GitHub ssh://git@github.com/AubSmith/Private
# View all Push/Pul repos
git remote -v
git remote remove GitHub
git push --set-upstream GitHub master
git remote set-url origin https://aubs@bitbucket.com/scm/repo.git
git push -u origin master
git push -u origin --all
git push origin --tags

# SSL
git config --global http.sslBackend schannel # Git will use Windows cert store and ignore http.sslCAInfo config setting
# git config --global http.sslBackend openssl


# Create a new local repository:
git init


# Code is ready to be pushed:
cd existing-project
git add <filename>
git add *
git add --all
git commit -m "Initial Commit"

# Clone a repository:
git clone https://aubs@bitbucket.com/scm/repo.git

# My code is already tracked by Git
cd existing-project

# Find excluded files:
git ls-files --others -i --exclude-standard


# Delete a remote repo
git remote rm BitBucket

# Cert Trust
# Update ca-bundle.crt
# Copy to relevant path such as profile
# UNIX
git config --global http.sslCAInfo /etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt
# Windows
git config --global http.sslCAInfo C:/Users/username/ca-bundle.crt

# Hard reset local with remote
git reset --hard origin/master

# see current branch
git branch
git branch --show-current

# Turn off SSL verification per remote
git config --global http.sslVerify false


# Check the Credential Manager CP for credentials

# Git Bash:
# Confirm SSH agent is running
eval 'ssh-agent.exe'
# Add the SSH private key
ssh-add $KeyPath