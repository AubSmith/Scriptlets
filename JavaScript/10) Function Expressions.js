// --- Function Expressions --- //
/*
setTimeout(function() {
    console.log('I waited 5 seconds');
}, 5000);

let counter = 0;
function timeout() {
    setTimeout(function() {
        console.log('Hi' + counter++);
        timeout();
    }, 5000);
}

timeout();

//Ctrl + C to break infinite loop
*/

(function() {
    console.log('Immediately Invoked Function Expression');
})();