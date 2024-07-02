$GitPath = "C:\Users\Aubs\source\repos\Aubs Git\Git\"
$BitBucket = "https://aubs@bitbucket.service.smith.com:8443/Source/aubs.git"
$BitBucketBranch = "master"
$TFS = "https://tfs.service.smith.com:8443/tfs/Source/aubs.git"
$TFSBranch = "master"

# Browse to local Git repo

Set-Location $GitPath

# Pull updated source from BitBucket

git pull $BitBucket $BitBucketBranch

# Push updated source to TFS

git push -u $TFS $TFSBranch