# Must be item and include name, repo, path
aql = 'items.find(' \
                      '{' \
                          '{"repo": "reponame",' \
                          '"path": {{"$match':'python*"}},' \
                          '"name": ""}' \
                          '}' \
                        ').sort(' \
                                '{' \
                                  '{"desc": ["created"]}' \
                                '}' \
                        ').limit(1)' \