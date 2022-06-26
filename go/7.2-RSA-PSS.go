package main

import (
	"crypto"
	"crypto/rand"
	"crypto/rsa"
	"fmt"
	"os"
)

func main() {
	// Generate RSA keys
	miryanPrivateKey, err := rsa.GenerateKey(rand.Reader, 2048)

	if err != nil {
		fmt.Println(err.Error)
		os.Exit(1)
	}

	miryanPublicKey := &miryanPrivateKey.miryanPublicKey

	message := []byte("Code must be like a piece of music")

	// Message - Signature
	var opts rsa.PSSOptions
	opts.SaltLength = rsa.PSSSaltLengthAuto
	PSSmessage := message
	newhash := crypto.SHA256
	pssh := newhash.New()
	pss.Write(PSSmessage)
	hashed := pssh.Sum(nil)

	signature, err := rsa.SignPSS(rand.Reader, miryanPrivateKey, newhash, hashed, &opts)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Printf("PSS Signature : %x\n", signature)

	// Verify Signature
	err = rsa.VerifyPSS(miryanPublicKey, newhash, hashed, signature, &opts)

}
