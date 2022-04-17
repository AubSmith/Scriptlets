package main

import (
	"crypto/rand"
	"crypto/rsa"
	"fmt"
)

func main() {
	sk, _ := rsa.GenerateKey(rand.Reader, 1024)
	/* sk, _ := rsa.GenerateKey(rand.Reader, 2048) */
	/* sk, _ := rsa.GenerateKey(rand.Reader, 4096) */

	fmt.Println("The Public key is: ", sk.PublicKey.E)
	fmt.Printf("The binary format of public key is: %b\n", sk.PublicKey.E)
	fmt.Println("The byte size of two prime factors are: ", len(sk.Primes[0].Bytes()), len(sk.Primes[1].Bytes()))
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
