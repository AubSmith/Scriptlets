package main

import (
	"crypto/sha1"
	"fmt"
	"io"
	"os"
)

func main() {

	test_sha1_string()

	test_sha1_file()
}

func test_sha1_string() {
	s := "sha1 this string" // Hash of a string

	h1 := sha1.New()    // We first initialize an instance of SHA1 function
	h1.Write([]byte(s)) // Feed the input message to hash function instance
	bs1 := h1.Sum(nil)  // Finish hash calculation

	fmt.Println(s)
	fmt.Printf("%x\n", bs1)
	fmt.Printf("The number of bytes is %d\n", len(bs1))

}

func test_sha1_file() {
	fmt.Printf("Calculate the SHA1 value of a file\n")
	file, _ := os.Open("Text-for-test.txt") //Hash of a file
	h2 := sha1.New()
	io.Copy(h2, file)
	bs2 := h2.Sum(nil)
	fmt.Printf("%x\n", bs2)
	fmt.Printf("The number of bytes is %d\n", len(bs2))

}
