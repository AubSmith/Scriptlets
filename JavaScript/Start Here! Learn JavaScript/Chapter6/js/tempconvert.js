$(document).ready(function () {
    $('#myForm').live('submit', function () {
        var inputTemp = $('#temp').val();
        var inputTempType = $('#tempType').val();
        $.getJSON('/WebForm1.aspx', 
        { "temp": inputTemp, "tempType": inputTempType },
            function (resp) {
            $("#result").text(resp["Temp"] + " " + resp["TempType"]);
        }).error(function () {
            $("#result").text('An unknown error has occurred.');
        });
        return false;
    });
});
