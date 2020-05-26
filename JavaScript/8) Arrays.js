let a = [1, 2, 3, 4, 5];
let b = ['Áubs', 'Rose', 'Oliie', 'Belle'];
console.log(a[0]);
console.log(a[1]);
console.log(a);

a[0] = 7;
console.log(a);

console.log(typeof a);
console.log(typeof b);

let c = [4, 'Alex', true];
console.log(c);

console.log(b[4]);

console.log(a.length); // Actual length, not zero based

a[10] = 77;  // add value to 10th array value
console.log(a);
console.log(a.length); // Sparse array

a.push(88); // push method - assigns value to end of array
console.log(a);
console.log(a.length);

a.pop(); // pop method removes last item from array
a.pop();
a.pop();
console.log(a);
console.log(a.length);