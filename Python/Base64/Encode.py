import base64

encoded = open("encoded.txt", "w")

with open('decoded.txt', 'rb') as decoded:
    decoded = decoded.read()
    encode = base64.b64encode(decoded)
    encoded.write(encode.decode('utf-8'))
encoded.close()
