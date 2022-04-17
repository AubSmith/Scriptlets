package main

import (
	"crypto/pbkdf2"
	"crypto/sha1"
	"crypto/sha256"
	"fmt"
)

func main() {
	fmt.Printf("%s\n\n", " >>> Supply password to generate a secure key")

	// Get password from user
	// Password is in bytes
	password := []byte("This is a password")

	// Add salt o make key harder to crack
	salt := []byte("mysaltedSalt")

	// Print original password supplied by user
	fmt.Printf("1.) Original Password :-> %s\n\n", string(password))

	// Hash the orginal password
	// Using SHA1
	hashedPassword := sha256.Sum256([]byte(password))

	fmt.Printf("2.) Hashed password :-> %x\n\n", hashedPassword)

	// Generate the derived key
	// Based on input parameter
	// Password to stretch
	// Salt to use
	// Number of iterations while generating
	// Length of new generated key
	// Hash function used to derive key
	derivedKey := pbkdf2.Key(password, salt, 10, 128, sha1.New)

	// Print derived key
	fmt.Printf("3.) KDF Key :-> %x\n\n", derivedKey)

	// Compute hash function of derived key to make it stronger
	hashDerivedKey := sha256.Sum256(derivedKey)

	// Print hash of derived key
	fmt.Printf("4.) Hashed derived key :-> %x\n\n", hashDerivedKey)

}
