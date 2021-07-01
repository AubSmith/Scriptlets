When converting text between different text encoding standards (e.g. ASCII, UTF-8) data can become lost or corrupted due to differences in character sets.

Encoding using Base64 mitigates the risk associated with transforing data between the different encodings by allowing arbitary bytes to be encoded using bytes which are known to be safe.

First encode bytes using a preferred text encoding such as UTF-8, and then Base64 encode the resulting binary data. This creates a text string that is safe to send encoded as ASCII. The reccipient of the data reverses this process to recover the original message. The original encodings used needs to be sent separately, and is used to decode the string.

Encode text in ASCII starts with a text string and converts it to a sequence of bytes.
Encode data in Base64 starts with a sequence of bytes and converts it to a text string.

# ASCII only recognises 128 characters
# UTF-8 is a superset of ASCII