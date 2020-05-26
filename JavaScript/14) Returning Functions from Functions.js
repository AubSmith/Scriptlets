// Returning Functions from Functions //

/*

Don't do this!!!
var myVariable = 'I am at the global scope';

OR this!!!
var myFunction = function() {
    console.log('Me too!');
}
*/

function one() {
    return 'One';
}

console.log(one());

let value = one;
console.log(typeof value);

let value = one;
console.log(typeof one);

let value = one;
console.log(value());

//string
//number
//boolean
//undefined
//function

function two() {
    return funtion () {
        console.log('two');
    }
}

let myFunction = two()
myFunction();

function three() {
    return function() {
        return 'three';
    }
}

console.log(three()());
