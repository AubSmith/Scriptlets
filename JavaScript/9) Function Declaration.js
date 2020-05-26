// --- Function Declaration --- //

// console.log // console.log function

function sayHello() {
    console.log('..........');
    console.log('Hello');
    console.log('...........');
}

let a = sayHello;
a();



function sayHello(name) {
    console.log('..........');
    console.log('Hello' + ' ' + name);
    console.log('...........');
}

sayHello('Bob');
sayHello('Steve');

function calcTax(amount) {
    let result = amount * 0.15;
    return result;
}

let tax = calcTax(50);
console.log(tax);