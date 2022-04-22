#include <iostream>

// function main begins program execution
int main() {
   // Declare and initialise variables
   int number1{0}; // first integer (initialised to 0)  
   int number2{0}; // second integer (initialised to 0) 

   std::cout << "Enter first integer: "; // prompt user for data
   std::cin >> number1; // read first integer from user into number1

   std::cout << "Enter second integer: "; // prompt user for data
   std::cin >> number2; // read second integer from user into number2

   // Optional - initialise 
   // sum = number1 + number2; // add the numbers; store result in sum
   // OR
   // int sum{ number1 + number2 };

   // Optional
   // std::cout << "Sum is " << sum << std::endl; // display sum; end line
   std::cout << "Sum is " << number1 + number2 << std::endl; // display sum; end line
} // end function main
