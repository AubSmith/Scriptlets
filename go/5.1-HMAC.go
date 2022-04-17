package main

import (
	"crypto/hmac"
	"crypto/sha256"
	"fmt"
)

func main() {

	secret := "mysecret"
	data := "data"
	fmt.Printf("Secret: %s\nData: %s\n", secret, data)

	// Create new HMAC - define hash type and key (as Byte array)
	h := hmac.New(sha256.New, []byte(secret))

	// Write Data to instance
	h.Write([]byte(data))

	//Get result and encode as hex string (do the work)
	hmac := h.Sum(nil)

	fmt.Println(hmac)
}
