#!/usr/bin/env python3

import time
import argparse
from subprocess import check_call, CalledProcessError
from urllib.request import urlopen, Request


parser = argparse.ArgumentParser()
parser.add_argument('-i', '--image', action='store', required=True, help='image name')
args = parser.parse_args()

print(args.image)

try:
    check_call("podman rm smk".split())
except CalledProcessError as err:
    pass

check_call(
    "podman run --rm --name=smk -p 8080:8080 -d {}".format(args.image).split()
)

time.sleep(5)

r = Request("http://localhost:8080", headers={'Host': 'chris.collins.is'})
try:
    print(str(urlopen(r).read()))
finally:
    check_call("podman kill smk".split())