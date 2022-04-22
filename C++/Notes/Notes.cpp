// This is a single line comment
/*
This is a multi-line comment
*/

/*
Preprocessor direction - executes before compilation
Imports header file - iostream
iostream - predefines cout/cin
*/
#include <iostream>

// Function declaration AKA Prototype - code execution begins
// int = Function return type
// main() = bootstraps application
int main() {
   // std:: = standard namespace
   // :: = scope resolution operator
   // << stream insertion operator
   std::cout << "Ethan was here!\n"; // \n = escape sequence 

   std::cout << "This line will ";
   std::cout << "not be split!\n";

   std::cout << "This line will \nbe\nsplit\n";

   // main() must have return value. Automatically inserted by compiler if not included
   return 0;
}
