# Setup new Git user
git config --global user.name "Aubrey Smith"
git config --global user.email aubrey.smith@orcon.net.nz

# Shell Command: Install 'code' command in path
git config --global core.editor vscode

# Create new SSH key
ssh-keygen -t rsa -b 4096 -C "aubrey.smith@orcon.net.nz"

# Git remote
git remote add GitHub ssh://git@github.com/AubSmith/Private