import string

# ord() function returns the number representing the unicode code of a specified character
# Therefore offset = 97
LOWERCASE_OFFSET = ord("a")
# string.ascii_lowercase :16 will give the lowercase letters ‘abcdefghijklmnop'
ALPHABET = string.ascii_lowercase[:16]

# Base16 (HEX)
def b16_encode(plain):
	enc = ""
	for c in plain:
		# Output = ASCII value of c in binary form
		binary = "{0:08b}".format(ord(c))
		# Split binary value into nibbles convert DEC
		enc += ALPHABET[int(binary[:4], 2)]
		enc += ALPHABET[int(binary[4:], 2)]
	return enc

# Apply shift cypher
def shift(c, k):
	t1 = ord(c) - LOWERCASE_OFFSET
	t2 = ord(k) - LOWERCASE_OFFSET
	return ALPHABET[(t1 + t2) % len(ALPHABET)]

flag = "redacted"
key = "redacted"
assert all([k in ALPHABET for k in key])
assert len(key) == 1

b16 = b16_encode(flag)
enc = ""
for i, c in enumerate(b16):
	enc += shift(c, key[i % len(key)])
print(enc)
