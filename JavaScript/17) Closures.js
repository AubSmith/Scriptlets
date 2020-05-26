// Closures //

function sayHello(name) {
    return function() {
        console.log('Howdy' + ' ' + name);
    }
}

let bob = sayHello('Bob');
let Conrad = sayHello('Conrad');
let Grant = sayHello('Grant');

bob();
Conrad();
Grant();