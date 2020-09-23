mkdir project1
cd project1
git clone ssh://bitbucket.smith.com:7598/project1/code.git
cd code
git checkout -b featurebranch
# Make code changes
git commit -am "New feature added"
git push --set-upstream origin featurebranch