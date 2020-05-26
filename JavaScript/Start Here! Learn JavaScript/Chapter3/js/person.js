
var Person = function(username,email,twitter) {
	this.username = username;
	this.email = email;
	this.twitter = twitter;
	this.listDetails = function() {
		document.write("Username: " + this.username + "<br />");
		document.write("E-mail: " + this.email + "<br />");
		document.write("Twitter ID: " + this.twitter + "<br />");
	}	
}

var myPerson = new Person("steve","suehring@braingia.com","@stevesuehring");
myPerson.listDetails();

