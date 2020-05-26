$(document).ready(function() {
    var customerRegex = /[\w\s]+/;
    var emailRegex = /@/;
    $('#myForm').submit(function() {
           var formError = false;
        if (!customerRegex.test($('#customerName').val())) {
            formError = true;
        }
        else if (!emailRegex.test($('#emailAddress').val())) {
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
