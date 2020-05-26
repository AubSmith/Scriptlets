$(document).ready(function() {
	var formError = false;
	$('#myForm').submit(function() {
		if ($('#customerName').val() == "") {
			formError = true;
		}
		else if ($('#emailAddress').val() == "") {
			formError = true;
		}
	
		if (formError) {
			alert("One or more required fields missing.");	
			return false;
		} else {
			alert("Form valid, submitting to server.");	
			return true;
		}
	});
});
