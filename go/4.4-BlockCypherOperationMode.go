package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"io"
)

func main() {

	// Must be secret - no hard coding!!!
	key := "myverystringpasswordo32bitlength"
	plaintext := "Hello cryptography.com"
	fmt.Print("Priginal Text: %\n", plaintext)
	fmt.Println()
	fmt.Println("====GCM Encryption/Decryption without AAD====")

	//Never use more than 2^32 random nonces with given key due to risk of repeat
	iv := make([]byte, 12)
	if _, err := io.ReadFull(rand.Reader, iv); err != nil {
		panic(err.Error())
	}
	ciphertext := GCM_encrypt(key, plaintext, iv, nil)
	fmt.Printf("GCM Encrypted Text: %s\n", ciphertext)
	ret := GCM_decrypt(key, ciphertext, iv, nil)
	fmt.Printf("GCM Decrypted Text: %s\n", ret)
	fmt.Println()

	fmt.Println("======GCM Encryption/Decryption with AAD====")

	// Never use same IV or nonce
	iv = make([]byte, 12)
	if _, err := io.ReadFull(rand.Reader, iv); err != nil {
		panic(err.Error())
	}
	additionalData := "Not Secret AAD value"
	//additionalDataR := "Not secret ADD modified"
	ciphertext = GCM_encrypt(key, plaintext, iv, []byte(additionalData))
	fmt.Printf("GCM Encrypted Text: %s\n", ciphertext)
	ret = GCM_decrypt(key, ciphertext, iv, []byte(additionalData))
	//ret = GCM_decrypt(key, ciphertext, iv, []byte(additionalDataR))

	fmt.Printf("GCM Decrypted Text: %s\n", ret)

}

func GCM_encrypt(key string, plaintext string, iv []byte, additionalData []byte) string {
	block, err := aes.NewCipher([]byte(key))
	if err != nil {
		panic(err.Error())
	}
	aesgcm, err := cipher.NewGCM(block)
	if err != nil {
		panic(err.Error())
	}
	ciphertext := aesgcm.Seal(nil, iv, []byte(plaintext), additionalData)
	return hex.EncodeToString(ciphertext)
}

func GCM_decrypt(key string, ct string, iv []byte, additionalData []byte) string {
	ciphertext, _ := hex.DecodeString(ct)
	block, err := aes.NewCipher([]byte(key))
	if err != nil {
		panic(err.Error())
	}
	aesgcm, err := cipher.NewGCM(block)
	if err != nil {
		panic(err.Error())
	}
	plaintext, err := aesgcm.Open(nil, iv, ciphertext, additionalData)
	if err != nil {
		panic(err.Error())
	}
	s := string(plaintext[:])
	return s
}
