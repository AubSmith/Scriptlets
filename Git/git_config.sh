# Setup new Git user
git config --global user.name "Aubrey Smith"
git config --global user.email "Aubrey.Smith@outlook.com"

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
git commit -m "Initial Commit"
git add <filename>
git add *
git add --all

# Clone a repository:
git clone https://aubs@bitbucket.com/scm/repo.git

# My code is already tracked by Git
cd existing-project

# Find excluded files:
git ls-files --others -i --exclude-standard


# Delete a remote repo
git remote rm BitBucket

# Cert Trust
git config --global http.sslCAInfo /etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt

# Check the Credential Manager CP for credentials

# Git Bash:
# Confirm SSH agent is running
eval 'ssh-agent.exe'
# Add the SSH private key
ssh-add $KeyPath