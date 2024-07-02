$GitPath = "C:\Aubs\source\repos\Aubrey Git\Git\"
$BitBucket = "https://user@bitbucket.com/scm/repo.git"
$BitBucketBranch = "master"
$TFS = "http://tfs.com/tfs/aubrey/SQL%20Code/_git/Aubrey%20Git"
$TFSBranch = "master"

# Browse to local Git repo

Set-Location $GitPath

# Pull updated source from BitBucket

git pull  $BitBucket $BitBucketBranch

# Push updated source to TFS

git push -u $TFS $TFSBranch