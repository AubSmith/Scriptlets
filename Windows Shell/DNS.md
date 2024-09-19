## NSlookup
nslookup
set query=ns
ox.ac.uk
server dns2.ox.ac.uk
set query=any

nslookup -type=soa ox.ac.uk
nslookup
server dns2.ox.ac.uk
test.ox.ac.uk