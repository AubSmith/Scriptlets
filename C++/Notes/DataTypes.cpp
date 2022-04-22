#include <iostream>
using namespace std;

int main() {
	// << = Stream insertion operators
	cout << "Size of char : " << sizeof(char) << endl; // endl (stream manipulator) = Flush output buffer
	// cout statement
	cout << "Size of int : " << sizeof(int) << endl; // endl = Flush output buffer
	cout << "Size of short int : " << sizeof(short int) << endl; // endl = Flush output buffer
	cout << "Size of long int : " << sizeof(long int) << endl; // endl = Flush output buffer
	cout << "Size of float : " << sizeof(float) << endl; // endl = Flush output buffer
	cout << "Size of double : " << sizeof(double) << endl; // endl = Flush output buffer
	cout << "Size of wchar_t : " << sizeof(wchar_t) << endl; // endl = Flush output buffer

	return 0;
}