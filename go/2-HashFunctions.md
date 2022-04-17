Hash Function Definition and Security Features
1) Arbitary large input -> fixed output
2) Don't require capability to recover original input from hash result
3) Cheap to compute and is important feature
4) Given hash result = hard to find original message (onewayness) and expensive to reverse
5) Hard to find another message with same hash value
6) Hard to find any pair of messages with same image
7) Gen 0 and 1 are considered broken.
8) Good keys not easy to remember
9) KDF - Key Derivation Function can't add extra entropy to the key

Run Go file
go run filename