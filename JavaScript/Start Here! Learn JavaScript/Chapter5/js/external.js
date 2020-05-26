$(document).ready(function() {
	var charTotal = 100;
	$(':input[name="messageText"]').on("keyup",function() {
		var curLength = $(':input[name="messageText"]').val().length;
		var charRemaining = charTotal - curLength;
		$('#charRemain').text(charRemaining);
	});	
});
