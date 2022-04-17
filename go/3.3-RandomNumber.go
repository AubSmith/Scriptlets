package main

import (
	"crypto/rand" // This is the package used for random number generator
	"fmt"
	"math/big"
)

func main() {
	v, _ := rand.Int(rand.Reader, big.NewInt(1000))

	fmt.Println(v) // Print generated numbers

}
