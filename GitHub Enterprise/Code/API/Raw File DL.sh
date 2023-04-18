curl -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3.raw" \
  -O \
  -L http://github.wayneent.com/api/v3/repos/$ORG/$REPO/contents/$FILE?ref=my-branch


curl -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3.raw" \
  -O \
  -L http://github.wayneent.com/api/v3/repos/$ORG/$REPO/contents/path/to/file/$FILE?ref=my-branch