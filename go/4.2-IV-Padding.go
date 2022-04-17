package main

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"fmt"
	"io"
)

/*
CBC Encryption - Follow golang standard library code examples
*/

// Use PKCS7 to fill
func PKCS7Padding(origData []byte, blockSize int) []byte {
	padding := blockSize - len(origData)%blockSize
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)
	return append(origData, padtext...)
}

func PKCS7UnPadding(origData []byte) []byte {
	length := len(origData)
	unpadding := int(origData[length-1])
	return origData[:(length - unpadding)]
}

/*
AES Encryption - filling 16 bits of the key
16 bit key = AES-128
24 bit key = AES-192
32 bit key = AES-256
*/
func AesCBCEnrypt(rawData, key []byte) ([]byte, error) {
	// Create AES instance
	block, err := aes.NewCipher(key)
	if err != nil {
		panic(err)
	}

	// Fill the original
	blockSize := block.BlockSize()
	rawData = PKCS7Padding(rawData, blockSize)
	// IV must be unique but not secret
	// First block is for IV
	// Hold encryption result
	cipherText := make([]byte, blockSize+len(rawData))
	// Block size 16
	iv := cipherText[:blockSize]
	// Handle exception
	if _, err := io.ReadFull(rand.Reader, iv); err != nil {
		panic(err)
	}

	// Block size and initial vector size must be ==
	mode := cipher.NewCBCEncrypter(block, iv)
	mode.CryptBlocks(cipherText[blockSize:], rawData)

	return cipherText, nil
}

func AesCBCDecrypt(encryptData, key []byte) ([]byte, error) {
	block, err := aes.NewCipher(key)
	if err != nil {
		panic(err)
	}

	blockSize := block.BlockSize()

	if len(encryptData) < blockSize {
		panic("Cyphertext is too short")
	}
	iv := encryptData[:blockSize]
	encryptData = encryptData[blockSize:]

	// CBC mode always works in whole blocks.
	if len(encryptData)%blockSize != 0 {
		panic("Cyphertext is not a multiple of the block size.")
	}

	mode := cipher.NewCBCDecrypter(block, iv)

	// CryptBlocks can work in-place  if the two args ==
	mode.CryptBlocks(encryptData, encryptData)
	// Unfill
	encryptData = PKCS7UnPadding(encryptData)
	return encryptData, nil
}

func Encrypt(rawData, key []byte) (string, error) {
	data, err := AesCBCEnrypt(rawData, key)
	if err != nil {
		return "", err
	}
	return base64.StdEncoding.EncodeToString(data), nil
}

func Decrypt(rawData string, key []byte) (string, error) {
	data, err := base64.StdEncoding.DecodeString(rawData)
	if err != nil {
		return "", err
	}
	dnData, err := AesCBCDecrypt(data, key)
	if err != nil {
		return "", err
	}
	return string(dnData), nil
}

func main() {
	key := make([]byte, 16)
	msg := "Hello world!"

	c1, _ := Encrypt([]byte(msg), key)
	p1, _ := Decrypt(c1, key)

	fmt.Println(c1)
	fmt.Println(p1)

}
