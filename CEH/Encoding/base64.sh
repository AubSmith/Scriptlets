# Encode file
base64 ~/toencode.txt > encoded.txt

# Encode string
echo -n "encode me please" | base64

# Decode file
base64 --decode ~/todecode.txt > decoded.txt

base64 --decode ~/todecode.txt

# Decode string
echo -n "YmFzZTY0IGVuY29kZWQgc3RyaW5n" | base64 --decode
