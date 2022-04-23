#!/bin/bash

echo "Number of arguments : $#"
echo "Argument 1= $1"
echo "Argument 2= $2

Square_Area() {
area=$(($1 * $1))
echo "Area of square is : $area"
}

Square_Area 10    #calling the function