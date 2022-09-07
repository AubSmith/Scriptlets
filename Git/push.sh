# Create SSH Key
ssh-keygen -t rsa
cat /home/esmith/.ssh/id_rsa.pub
# Copy to BitBucket profile + explicit permissions on repo

git remote -v
git remote set-url origin ssh://esmith@bitbucket.service.wayneent.com:7998/proj/repo_name.git

git remote add origin git@git.bitbucket.service.wayneent.com:7998/proj/repo_name.git

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

# Rename a local branch
git branch -m <old_branch_name> <new_branch_name>

git push origin <new_branch_name>
git push origin -d -f <old_branch_name>

# Delete a local branch
git checkout <central_branch_name>
git branch -a
git branch -d <name_of_the_branch>

# Delete a remote branch
git checkout <central_branch_name>
git branch -a
git push origin -d <name_of_the_branch>


# Push to two repos simultaneously
# Updates remote.origin.pushurl config
git remote set-url --add --push origin ssh://git@bitbucket.corp.waynecorp.com:7998/mil/batmobile.git
git remote set-url --add --push origin ssh://git@github.corp.waynecorp.com:mil/batmobile.git

git remote show origin
git fetch --all
