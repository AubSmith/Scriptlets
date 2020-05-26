var telephone = {
    "numLines": 4,
	"usedLines": 0,
	"isLineAvail": function() {
		if (this.usedLines < this.numLines) {
			return true;
		} else {
			return false;
		}
	},
	"getLine": function() {
		if (this.isLineAvail) {
			this.usedLines++;
			return true;
		} else {
			return false;
		}
	},
    "startCall": function (line,dialNum) {
		if (this.getLine) {
			return "Called " + dialNum + " on line " + line;
		} else {
			return "No lines available at this time.";
		}
	},
	"endCall": function (line) {
		this.usedLines--;
	}
};

for (var propt in telephone) {
	if (typeof(telephone[propt]) !== "function") {
    	document.write(propt + "<br />");
	}
}
