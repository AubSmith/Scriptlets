// Module Pattern //

// Immediately invoked function expression (iife) 

var counter = (function() {
    // Private variable
    let count = 0;

    function print(message) {
        console.log('Message' + '...' + count);
    }

        return {
            value: count,

            increment: function() {
                count += 1;
                print('After increment: ');
            },
        
        reset: function() {
            print('Before reset: ');
            count =0;
            print('After reset: ');
            }
        }
})();

console.log(counter.count); // Undefined - count not a property of counter
console.log(counter.value);

//////////////////////////////////////////////////

var counter = (function() {
    // Private variable
    let count = 0;

    function print(message) {
        console.log('Message' + '...' + count);
    }

        return {
            value: count,

            increment: function() {
                count += 1;
                print('After increment: ');
            },
        
        reset: function() {
            print('Before reset: ');
            count =0;
            print('After reset: ');
            }
        }
})();

counter.increment();
counter.increment();
counter.increment();

//  Accidentally created a closure
console.log(counter.value);

counter.reset();

//////////////////////////////////////////////////

var counter = (function() {
    // Private variable
    let count = 0;

    function print(message) {
        console.log('Message' + '...' + count);
    }

        return {
            get: function() {return count;},

            set: function(value) {count = value},

            increment: function() {
                count += 1;
                print('After increment: ');
            },
        
        reset: function() {
            print('Before reset: ');
            count =0;
            print('After reset: ');
            }
        }
})();

counter.increment();
counter.increment();
counter.increment();
counter.set(7);
console.log(counter.get());
counter.reset();

// Revealing Module Pattern

var counter = (function() {
    // Private variable
    let count = 0;

    function print(message) {
        console.log('Message' + '...' + count);
    }

        function getCount() {return count;}

        function setCount(value) {count = value;}

            function incrementCount() {
                count += 1;
                print('After increment: ');
            }
        
        function resetCount() {
            print('Before reset: ');
            count =0;
            print('After reset: ');
            }
        
        return {
            get: getCount,
            set: setCount,
            increment: incrementCount,
            reset: resetCount
        };
})();

console.log(counter);
console.log(counter.get());
