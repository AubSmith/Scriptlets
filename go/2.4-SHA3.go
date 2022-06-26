package main

import (
	"fmt"
	"golang.org/x/crypto/sha3"
)

func main() {

	buf := []byte("Data that will be hashed")

	// Hash 64 bytes long to have 256-bit collission resistance
	h := make([]byte, 64)

	// Compute 64-byte hash of buf and put it in h
	sha3.ShakeSum256(h, buf)
	fmt.Printf("%x\n", h)
}
