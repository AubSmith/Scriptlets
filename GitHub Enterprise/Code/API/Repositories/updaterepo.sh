curl -uuser:token -X PATCH -H "Accept: application/vnd.github.v3+json" https://githuburl.com/api/v3/repos/myorg/hello-world -d '{"name":"hellow-world-archive"}'

curl -uuser:token -X PATCH -H "Accept: application/vnd.github.v3+json" https://githuburl.com/api/v3/repos/myorg/hello-world-private -d '{"name":"hellow-world-private-archive"}'