package main

import (
	"crypto"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha512"
	"fmt"
	"os"
)

func main() {
	// crypto/rand.Reader is good source of entropy for blinding RSA operation
	rng := rand.Reader

	message := []byte("Please sign this message")

	
	// Only small messages can be signed directly, thus sign message hash instead of message
	// Requires collision resistant hash function

	// Generate signature
	// Hash message
	hashed := sha512.Sum512(message)

	sk, _ := rsa.GenerateKey(rand.Reader, 1024)

	// Signature hash algorithm should match message hash algorithm
	signature, _ := rsa.SignPKCS1v15(rng, sk, crypto.SHA512, hashed[:])
	
	fmt.Printf("The signature is: %x\n", signature)

	// Signature verification
	err := rsa.VerifyPKCS1v15(&sk.PublicKey, crypto.SHA512, hashed[:], signature)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error from verification: %s\n", err)
		return
	} else {
		fmt.Printf("Verification successful.")
	}
}