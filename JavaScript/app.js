// --- Variables --- //

// console.log('Hi');

let x = 7;
let y = 3;
let z = x + y;
console.log('Answer: ' +z);

var a = 7; // var no longer recommended
const b = 3; // variable value cannot be changed
let c = a + b;
console.log('Answer: ' +c);

// Variable only declared once, value can be set multiple times
// Variables are case-sensitive

// --- Data Types --- //

/*
Multi-line comment
*/

let x = 7;
console.log(typeof x);

let y = true;
console.log(typeof y);

let z = 'Hello world';
console.log(typeof z);

let a;
console.log(a);
console.log(typeof z);

// --- Type Coercion and Conversion --- //

let a = 7;
let b = '6';
let c = a + b;
console.log('Answer: ' + c);

let a = 7;
let b = '6';
b = parseInt(b, 10);
let c = a + b;
console.log('Answer: ' + c);

let d = parseInt('Hello world', 10);
let e = isNaN(d);
console.log(d);
console.log(e);

// --- Expressions --- //

// Types of expressions //

let a; // variable declaration

a = 3; // assign a value

let b = 1;
let c = 2;
let a = b + c; // result assigned to a & perform an eval (a + b)

b + C; // perform an operation that returns a single value

// Operators //

/* 
= assignment
+-*% maths
*/

// Increment/Decrement //

var a = 1;
a++;
console.log(a);
console.log(a++);
console.log(++a);

var m = 10 % 3; // modulus
console.log(m);

// String //
''; 

var b = 1 + 2 * 3;
console.log(b);

var b = (1 +2) *3; // Precedence
console.log(b);

console.log(); // () funtion invocation operator

// Logical and: && or: ||

console.log // . Member accessor operator

// Code block operator {}
// Array element access operator [] 