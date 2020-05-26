function addNumbers() {
    var argumentsLength = arguments.length;
    var sum = 0;
    for (var i = 0; i < argumentsLength; i++) {
        sum = sum + arguments[i];
    }
    return sum;
}

var finalResult = addNumbers();
alert(finalResult);

