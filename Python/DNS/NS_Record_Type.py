import dns.resolver
answer = dns.resolver.query('google.com')
rdt = dns.rdatatype.to_text(answer.rdtype)
print(rdt)