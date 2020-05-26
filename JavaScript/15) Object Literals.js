// Object Literals //

let car ={
    make: 'bmw',
    model: '745li',
    year: 2010,
    getPrice: function() {
        return 5000;
    },
    printDescription: function() {
        console.log(this.make + ' ' + this.model);
    }
}

car.printDescription();
console.log(car.year);

console.log(car['year']);

var anotherCar = {};
anotherCar.whatever = 'bob';
console.log(anotherCar.whatever);

var a = {
    myProperty: { b: 'hi'}
};

console.log(a.myProperty.b);

// Object Graph

var c = {
    myProperty: [
        {d: 'this'},
        {e: 'can'},
        {f: 'get'},
        {g: 'Crazy'}
    ]
};

let carLot = [
    {year: 2017, make: 'Toyota', model: 'Hilux'},
    {year: 2018, make: 'Mazda', model: 'CX5'},
    {year: 2018, make: 'BMW', model: 'M3'},
];

let contacts = {
    customers: [
        {firstName: 'Rich', lastName: 'Collins', phoneNumbers: ['021 212 345', '(09) 312 4456'] },
        {firstName: 'Charis', lastName: 'Cook', phoneNumbers: ['027 987 654', '(09) 323 5643'] },
    ],
    employees: [
        {firstName: 'Aubrey', lastName: 'Smith', phoneNumbers: ['021 234 234', '(03) 678 4563'] },
        {firstName: 'Emma', lastName: 'Smith', phoneNumbers: ['027 768 397', '(03) 678 4563'] },
    ]
};

console.log(contacts.customers);