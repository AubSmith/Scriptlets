package main

import (
	"crypto/aes"
	"fmt"
)

// Put AES function in a wrapper to process more than one block
// Accept Data (Cyphertext) and key and create byte array
// ECB is Operation mode
func DecryptAes128Ecb(data, key []byte) []byte {
	// Create instance of func and provide key
	cipher, _ := aes.NewCipher([]byte(key))
	// Create cache to hold decryted size as array of bytes
	decrypted := make([]byte, len(data))
	// Block size = 16. AES 128/8=16
	size := 16

	// Loop - process input block by block
	for bs, be := 0, size; bs < len(data); bs, be = bs+size, be+size {
		cipher.Decrypt(decrypted[bs:be], data[bs:be])
	}

	return decrypted
}

// Accept Data (Plaintext) and key and create byte array
func EncryptAes128Ecb(data, key []byte) []byte {
	cipher, _ := aes.NewCipher([]byte(key))
	encrypted := make([]byte, len(data))
	size := 16

	for bs, be := 0, size; bs < len(data); bs, be = bs+size, be+size {
		cipher.Encrypt(encrypted[bs:be], data[bs:be])
	}

	return encrypted
}

func main() {
	key := make([]byte, 16)
	msg := make([]byte, 32)
	// Result. rst size == msg size
	rst := make([]byte, 32)

	rst = EncryptAes128Ecb(msg, key)
	msg2 := DecryptAes128Ecb(rst, key)

	fmt.Println("The message is ", msg)
	fmt.Println(rst)
	fmt.Println(msg2)

}
