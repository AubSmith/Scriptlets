import base64

decoded = open("decoded.txt", "wb")
encoded = open("encoded.txt", "r").read()
decode = base64.b64decode(encoded)
decoded.write(decode)
decoded.close()
