$(document).ready(function() {
	$('#myLink').click(function(e) {
		alert($('#myLink').text() + " is currently unreachable.");s
		e.preventDefault();
	});
});
