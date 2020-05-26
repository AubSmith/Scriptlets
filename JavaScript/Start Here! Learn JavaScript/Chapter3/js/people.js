
var Person = function(username,email) {
	this.username = username;
	this.email = email;
	this.listDetails = function() {
		document.write("Username: " + this.username + "<br />");
		document.write("E-mail: " + this.email + "<br />");
	}	
}

// Create arrays of data
var usernames = ['steve','rebecca','jakob','owen'];
var emails = ['suehring@braingia.com','rebecca@braingia.com',
				'jake@braingia.com','owen@braingia.com'];

// Get length of usernames array
var usernamesLength = usernames.length;

// Create an array to hold Person objects
var myPeople = new Array();

// Iterate through all of the usernames and create Person objects
for (var i = 0; i < usernamesLength; i++) {
	myPeople[i] = new Person(usernames[i],emails[i]);
}

// Get length of the myPeople array
var numPeople = myPeople.length;

// Iterate through all of the Person objects in myPeople and
//    show their details.
for (var j = 0; j < numPeople; j++) {
	myPeople[j].listDetails();
}

