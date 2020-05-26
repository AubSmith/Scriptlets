window.onload = function() {
	var ulElm = document.getElementById("myUL");
	var liElms = ulElm.getElementsByTagName("li");
	for (var i = 0; i < liElms.length; i++) {
    	alert(liElms[i].innerHTML);
	}
};
