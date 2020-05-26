
function redirect(destURL) {
	if (typeof(location.replace) !== "undefined") {
		location.replace(destURL);
	} else {
		location.href = destURL;
	}
}

setTimeout('redirect("http://www.braingia.org?shjs")',5000);
