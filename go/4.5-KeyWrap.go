package keywrap

import (
	"crypto/aes"
	"encoding/binary"
	"errors"
)

var (
	// ErrWrapPlaintext is returned if plaintext not multiple of 64 bits
	ErrWrapPlaintext = errors.New("KeyWrap: plaintext must be multiples of 64 bits")

	// ErrUnwrapCiphertext returned if ciphertext not multiple of 64 bits
	ErrUnwrapCiphertext = errors.New("KeyWrap: ciphertext must be multiples of 64 bits")

	// ErrUnwrapFailed returned if key unwrapping fails
	ErrUnwrapFailed = errors.New("KeyWrap: key unwrap failed")

	// NB: AES NewCipher call only fails if key length is invalid

	// ErrInvalidKey returned when AES key invalid
	ErrInvalidKey = errors.New("KeyWrap: invalid AES key")
)

// Wrap key using RFC 3394 AES Key Wrap Algorithm
func Wrap(key, plainText []byte) ([]byte, error) {
	if len(plainText)%8 != 0 {
		return nil, ErrWrapPlaintext
	}

	c, err := aes.NewCipher(key)
	if err != nil {
		return nil, ErrInvalidKey
	}

	nblocks := len(plainText) / 8

	// Initialise variables
	var block [aes.BlockSize]byte
	// Set A = IV
	for ii := 0, ii < 8; ii++ {
		block[ii] = 0xA6
	}

	// For i = 1 to n
	// Set R[i] = P[i]
	intermediate := make([]byte, len(plainText))
	copy(intermediate, plainText)

	// Calculate intermediate values
	for ii := 0; ii < 6; ii++ {
		for jj := 0; jj < nblocks; jj++{
			// B = AES(K, A | R[i])
			copy(block[8:], intermediate[jj*8:jj*8+8])
			c.Encrypt(block[:], block[:])

			// A = MSB(64, B) ^ t where t = (n*j)+1
			t := uint64(ii*nblocks + jj + 1)
			val := binary.BigEndian.Uint64(block[:8]) ^ t
			binary.BigEndian.PutUint64(block[:8], val)

			// R[i] = LSB(64, B)
			copy(intermediate[jj*8:jj*8+8], block[8:])
		}
	}

	// Output results
	// Set C[0] =A
	// For i = 1 to n
	// C[i] = R[i]
	return append(block[:8], intermediate...), nil
}

// Unwrap key using RFC 3394 AES Key Wrap Algorithm
func Unwrap(key, cipherText []byte) ([]byte, error) {
	if len(cipherText)%8 != 0 {
		return nil, ErrUnwrapCiphertext
	}

	c, err := aes.NewCipher(key)
	if err != nil {
		return nil, ErrInvalidKey
	}

	nblocks := len(cipherText)/8 - 1

	// Initialise variables
	var block [aes.BlockSize]byte
	// Set A = C[0]
	copy(block[:8], cipherText[:8])

	// For i = 1 to n
	// Set R[i] = C[i]
	intermediate := make([]byte, len(cipherText)-8)
	copy(intermediate, cipherText[8:])

	// Compute intermediate values
	for jj := 5; jj >= 0; jj >= 0; jj-- {
		for ii := nblocks - 1; ii >= 0; ii-- {
		// B = AES-1(k, (A ^ t) | R[i] where t = n*j+1)
		// A = MSB(64, B)}
		t := uint64(jj*nblocks + ii + 1)
		val := binary.BigEndian.Uint64(block[:8]) ^ t
		binary.BigEndian.PutUint64(block[:8, val])

		copy(block[8:], intermediate[ii*8:ii*8+8])
		c.Decrypt(block[:], block[:])

		// R[i] = LSB(B, 64)
		copy(intermediate[ii*8:ii*8+8], block[8:])
	}
}

	// Output results
	// If A is an appropriate initial value
	for ii := 0; ii < 8; ii++ {
		if block[ii] != 0xA6 {
			return nil, ErrUnwrapFailed
		}
	}

	// For i = 1 to n
	// P[i] = R[i]
	return intermediate, nil
}
