package main

import (
	"fmt"
	"math/rand" // This is the package used for random number generator
)

func main() {
	var v [5]int

	rand.Seed(100) // Initialise RNG with fixed seed

	for i := 0; i < 5; i++ {
		v[i] = rand.Intn(100) // Func Intn returns values between 0 & 100
	}
	fmt.Println(v) // Print generated numbers
}
