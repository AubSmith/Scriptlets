package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"fmt"
	"time"
)

func main() {

	rng := rand.Reader

	sk, _ := rsa.GenerateKey(rng, 2048)

	secretMessage := []byte("Let's use this as an example.")
	/*
		- Length of message must be smaller than selected module
		- Message will be padded - consider hash length
	*/

	start := time.Now()

	ciphertext, _ := rsa.EncryptOAEP(sha256.New(), rng, &sk.PublicKey, secretMessage, nil)

	fmt.Printf("Time to encrypt %d\n", time.Since(start))
	fmt.Printf("The ciphertext: %x\n", ciphertext)

	start = time.Now()
	plaintext, _ := rsa.DecryptOAEP(sha256.New(), rng, sk, ciphertext, nil)
	fmt.Printf("Time to decrypt: %d\n", time.Since(start))
	fmt.Printf("Plaintext: %s\n", string(plaintext))
}
