// --- Deciion Statements --- //

var count =3;
if (count = 4) {
    console.log('Count is 4');
} else if (count > 4) {
    console.log('Count is > 4');
} else if (count < 4) {
    console.log('Count is < 4');
}
else {
    console.log('Count is not 4');
}

// Try batman, Batman and Green Arrow

let hero = 'Superman';

switch (hero) {
    case 'Superman':
        console.log('Super strength');
        console.log('Flight');
    case 'Batman':
        console.log('Wealth');
        console.log('Intellect');
    default:
        console.log('Member of JLA');
}

// Try batman, Batman and Green Arrow

let hero = 'Superman';

switch (hero) {
    case 'Superman':
        console.log('Super strength');
        console.log('Flight');
        break;
    case 'Batman':
        console.log('Wealth');
        console.log('Intellect');
        break;
    default:
        console.log('Member of JLA');
}

// Try batman, Batman and Green Arrow

let hero = 'Superman';

switch (hero.toUpperCase()) {
    case 'Superman':
        console.log('Super strength');
        console.log('Flight');
        break;
    case 'Batman':
        console.log('Wealth');
        console.log('Intellect');
        break;
    default:
        console.log('Member of JLA');
}

// Ternary Operator
let a = 1, b = '1';
let result = (a == b) ? 'Equal' : 'Inequal';
Console.log(result);
// console.log((a == b) ? 'Equal' : 'Inequal');

let a = 1, b = '1';
let result = (a === b) ? 'Equal' : 'Inequal';
Console.log(result);