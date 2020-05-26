/* var car = {
    make: "bmw",
    model: "745li",
    year: "2010",
    getPrice: function() {
        //Perform some calculation
        return 5000
    },
    printDescription: function() {
        console.log(this.make + ' ' + this.model);
    }
}

// this depends on HOW a function is called

car.printDescription(); */

// this is Node's global object because that is where the first method was called

/* function first() {
    return this;
}

console.log(first() === global); */



/* function second() {
    'use strict';

    return this;
}

console.log(second() === global);
console.log(second() === undefined); */

/* 
// an object can be passed as the first argument to call or apply and this will bound to it

let myObject = { value: 'My Object'};

// Values is set on the global object

global.value = 'Global Object';

function third(name) {
    // Returns something different depending on how we call this method
    return this.value + name;
}

console.log(third());
// Both call and apply allow you to explicitly set what you want to represent 'this'. The difference is in how additional arguments tothe function are sent.
console.log(third.call(myObject, 'bob'));
console.log(third.apply(myObject, ['bob']));
 */

 function fifth() {
     console.log(this.firstname + ' ' + this.surname);
 }

 let customer1 = {
     firstname: 'bob',
     surname: 'tabor',
     print: fifth
 }

 let customer2 = {
    firstname: 'Aubs',
    surname: 'Smith',
    print: fifth
 }

 customer1.print();
 customer2.print();