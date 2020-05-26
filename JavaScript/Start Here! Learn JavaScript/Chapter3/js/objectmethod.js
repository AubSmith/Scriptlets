
var guitar = {
    "color": "red",
    "strings": 6,
    "type": "electric",
    "playString": function (stringName) {
        var playIt = "I played the " + stringName + " string";
        return playIt;
    } //end function playString
};

alert(guitar.playString("E"));
