$(document).ready(function() {

	function theWorks(elm) {
		if (elm.val() == "works") {
			$('#mush').prop("checked","checked");	
			$('#peppers').prop("checked","checked");	
			$('#sausage').prop("checked","checked");	
		} else {
			$('#works').removeProp("checked");	
		}
	} //end function theWorks

	$(':input[name="toppings"]').on("click", function() {
		theWorks($(this));
	});

	// Validation Code
	var customerRegex = /[\w\s]+/;
	var emailRegex = /@/;
	$('#myForm').submit(function() {
	 	var	formError = false;
		if ($(':input[name="orderType"]:checked').val() == undefined) {
			formError = true;
		}
		else if (!customerRegex.test($('#customerName').val())) {
			formError = true;
		}
		else if (!emailRegex.test($('#emailAddress').val())) {
			formError = true;
		}
		else if ($(':input[name="crust"] :selected').val() == "") {
			formError = true;
		}	
		else if ($(':input[name="toppings"]:checked').val() == undefined) {
			formError = true;
		}
		else { 
			// Here's the first place that you know the form is valid.
			// So you can do fun things like enumerate through checkboxes.
			// $(':input[name="toppings"]:checked').each(function() {
			//	alert($(this).val());
			// });
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
