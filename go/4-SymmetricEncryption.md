1) Integrity - Only require that modified info can be detected, not required that info can't be modified.
2)  Stream cypher = algorythm used to generate key stream from shared key (usually constant size). Stream size same as message, and message is XOR'ed with key stream bit by bit to generate cypher text. 
3) Stream decypher - Recipient uses same algorythm as sender to generate same key stream and XOR's messages to retrieve message. Message can be any length.
4) Block cypher - Block divided into fixed size blocks and applies key to encrypt blocks
5) Block decypher - use same key to decypher blocks to retrieve same message
6) Stream cypher more symmetric than block
7) Block and cypher equally secure - block cyphers more popular
8) Block cyphers better standardised than stream cyphers
9) Block  cyphers more flexible and can be configured to work with app requirements
10) Block Cypher - Appends original key into longer bitstream to generate cypher stream. Message not directly encrypted with key. This step is usually included in library functions.
11) AES - Standard only defines a single block
12) Blocks padded to create even sized blocks
13) AES - Must be used with operation mode to protect data properly
14) Recommended to implement AES as black box, and implement standard libraries - do not reinvent wheel
15) Increasing key size by 1 bit doubles brute-force search difficulty
16) If cryptographic scheme design is insecure then key recovery may require far less complexity than brute-force
17) Key recovery is a serious attack, but key does not not need to be recovered for cryptographic scheme to be compromised. E.g. If cyphertext and random bit stream can be distinguished then encryption scheme is not secure
18) If attacker can distinguish an encrypted message then attacker can learn something from cyphertext
19) Adequate key length is alway necessarry condition to secure encryption, but not the sufficient condition
20) Incorrect initial vector or padding implementation compromises security of the ecnryption scheme
21) IV and padding essential for defining operation mode
22) Re-using IV for different keys compromises security of encryption
