# Set script permission
# chmod +x TFSRefresh.sh

GitPath="/c/Users/Aubs/source/repos/Aubrey Git/Git/"
BitBucket="ssh://git@bitbucket..com/repo/repo.git"
BitBucketBranch="master"
TFS="http://tfs.com/tfs/aubrey/SQL%20Code/_git/Aubrey%20Git"
TFSBranch="master"

# Browse to local Git repo

cd $GitPath

# Pull updated source from BitBucket

git pull  $BitBucket $BitBucketBranch

# Push updated source to TFS

git push -u $TFS $TFSBranch