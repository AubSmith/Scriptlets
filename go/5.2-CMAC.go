package main

import (
	"crypto/aes""
	"fmt"

	"github.com/aead/cmac"
)

func main() {

	secret := make([]byte, 16)
	data := "data"
	fmt.Printf("Secret: %s\nData: %s\n", secret, data)

	// Create new CMAC - define cypher and key (as Byte array)
	cipher, _ := aes.NewCipher(secret)
	h, _ := cmac.sum([]byte(data), cipher, 16)

	v := cmac.Verify(h, []byte(data), cipher, 16)

	fmt.Println(h)

	if v{
		fmt.Println("Yes")
	}
	if !v {
		fmt.Println("No")
	}
}
