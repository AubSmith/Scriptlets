#include <iostream>

// Global variable - available everywhere
std::string myName = "Ethan";

int main() {

   std::string yourName{}; // Local variable - only valid in current code block
   std::cout << "My name is " << myName;
   std::cout << "\nWhat is your name?\n";
   std::cin >> yourName;
   std::cout << "Your name is " << yourName;

};
