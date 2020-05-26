/*

let a = 'first';

function scopeTest() {
    console.log(a);
}

scopeTest();

//-------------------------//

let a = 'first';

function scopeTest() {
    console.log(a);

    let b = 'second';
}

scopeTest();
console.log(b);


//-------------------------//

let a = 'first';

function scopeTest() {
    console.log(a);

    if (a != '') {
        console.log(a);
    }
}

scopeTest();

//-------------------------//

let a = 'first';

function scopeTest() {
    console.log(a);

    if (a != '') {
        console.log(a);

        let c = 'third';
    }
    console.log(c)
}

scopeTest();

//-------------------------//

let a = 'first';

function scopeTest() {
    console.log(a);
    a = 'changed';

    if (a != '') {
        console.log(a);
    }
}

console.log(a);

//-------------------------*/

let a = 'first';

function scopeTest() {
    console.log(a);
    a = 'changed';

    let b = 'second';

    if (a != '') {
        console.log(a);
        console.log('inside if' + ' ' + b);
    }
}

scopeTest();