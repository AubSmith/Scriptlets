curl -uuser:token -X POST -H "Accept: application/vnd.github.v3+json" https://githuburl.com/api/v3/orgs/myorg/repos -d '{"name":"hellow-world"}'

curl -uuser:token -X POST -H "Accept: application/vnd.github.v3+json" https://githuburl.com/api/v3/orgs/myorg/repos -d '{"name":"hellow-world-private","private":true}'