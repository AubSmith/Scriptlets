var guitar = {
    "color": "red",
    "strings": 6,
    "type": "electric",
    "playString": function (stringName) {
        var playIt = "I played the " + stringName + " string";
        return playIt;
    }, 
    "getColor": function() {
        return this.color;
    },
    "setColor": function(colorName) {
        this.color = colorName;
    }
};

alert(guitar.getColor());
guitar.setColor("blue");
alert(guitar.getColor());


