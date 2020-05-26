$(document).ready(function () {
    $.get('/WebForm1.aspx', function (resp) {
        alert("Response was: " + resp);
    });
});
