package main

import (
	"fmt"
	"crypto/sha1"
	"crypto/sha256"

	"golang.org/x/crypto/pbkdf2"
)

func main() {
	fmt.Printf("%s\n\n", ">>> Supply password to generate a secure key")

	// Get password from terminal
	//Password in bytes
	password := []byte("This is a password")

	// Salt
	salt := []byte("mySaltedSalt")

	// Print supplied password
	fmt.Printf("1.) Original Password :-> %s\n\n", string(password))

	// Hash SHA1
	hashedPassword := sha256.Sum256([]byte(password))

	fmt.Printf("2.)Hashed Password :-> %s\n\n", string(hashedPassword))

	// Generate derived key based on input parameter
	// Password to stretch
	// Salt to use
	// Number of iterations
	// Length of new key
	// Hash function
	derivedKey := pbkdf2.key(password, salt, 10, 128, sha1.New)

	// Print derived key
	fmt.Printf("3.) KDF Key :-> %x\n\n", derivedKey)

	// Compute hash function of  derived key to srengthen
	hashDerivedKey := sha256.Sum256(derivedKey)

	// Print hash of derived key
	fmt.Printf("4.) Hash Derived Key :-> %s\n\n", string(hashDerivedKey))

}
