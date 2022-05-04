# Create SSH Key
ssh-keygen -t rsa
cat /home/esmith/.ssh/id_rsa.pub
# Copy to BitBucket profile + explicit permissions on repo

git remote -v
git remote set-url origin ssh://esmith@bitbucket.service.wayneent.com:7998/proj/repo_name.git

git pull

mkdir project1
cd project1
git clone ssh://bitbucket.smith.com:7598/project1/code.git
cd code
git checkout -b feature/jira-team123
# Make code changes
git commit -am "New feature added"
git push --set-upstream origin feature/jira-team123

# Git Branches
# Which branch
git status

# Local branches
git branch
# Remote branches
git branch -r
# All branches
git branch -a
# New branch
git checkout -b my-branch-name
# Switch to branch
git checkout my-branch-name

# Switch branch from remote
# Get list of branches
git pull
# Switch to branch
git checkout --track origin/my-branch-name
# Push to branch
git push -u origin my-branch-name
# Or - Head = top of current branch
git push -u origin HEAD
# If local branch exists
git push