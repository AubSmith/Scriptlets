package main

import (
	"crypto/rand"
	"crypto/rsa"
	"fmt"
)

func main() {
	/* 1024 = modulus and defines hardness */
	sk, _ := rsa.GenerateKey(rand.Reader, 1024)

	fmt.Println("The private key is: ", sk.D)
	fmt.Println("The public key is: ", sk.PublicKey)
	fmt.Println("The modulus N is: ", sk.PublicKey.N)
}

/*
Data structure of key pair

type PrivateKey struct {
	PublicKey			// public part
	D       *big.Int	// private exponent
	Primes   []*big.Int   // prime factors of N, has >= 2 elements

	// Precomputer contains precomputer values to speed up provate
	// operations, if available
	Precomputed PrecomputerValues
}

type PublicKey struct {
	N *big.Int // modulus
	E int 	   // public exponent
}

*/
