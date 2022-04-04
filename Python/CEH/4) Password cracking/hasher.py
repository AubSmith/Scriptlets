#!/usr/bin/python

import hashlib

hashvalue = input("Enter s string to hash: ")

hashmd5 = hashlib.md5()
hashmd5.update(hashvalue.encode())
print(hashmd5.hexdigest())

hashsha1 = hashlib.sha1()
hashsha1.update(hashvalue.encode())
print(hashsha1.hexdigest())

hashsha224 = hashlib.sha224()
hashsha224.update(hashvalue.encode())
print(hashsha224.hexdigest())

hashsha256 = hashlib.sha256()
hashsha256.update(hashvalue.encode())
print(hashsha256.hexdigest())

hashsha512 = hashlib.sha512()
hashsha512.update(hashvalue.encode())
print(hashsha512.hexdigest())