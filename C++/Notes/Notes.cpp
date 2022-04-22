// This is a single line comment
/*
This is a multi-line comment
*/

/*
Preprocessor direction - executes before compilation
Imports header files - iostream and string
iostream - predefines cout/cin
*/
#include <iostream>
#include <string>

// Using directive - not preferred
// using namespace std;

// Best practice - include using declaration
using std::cout;
// using std::cin;
// using std::endl;
// using std::string;

// Function declaration AKA Prototype - code execution begins
// int = Function return type
// main() = bootstraps application
int main() {
   // std:: = standard namespace. Not needed if using declaration
   // :: = scope resolution operator
   // << stream insertion operator
   std::cout << "Ethan was here!\n"; // \n = escape sequence 

   cout << "This line will ";
   cout << "not be split!\n";

   std::cout << "This line will \nbe\nsplit\n";

   // main() must have return value. Automatically inserted by compiler if not included
   return 0;
}
