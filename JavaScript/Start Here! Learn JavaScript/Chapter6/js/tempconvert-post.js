$(document).ready(function () {
    $('#myForm').live('submit', function () {
        var inputTemp = $('#temp').val();
        var inputTempType = $('#tempType').val();
        $.post('/WebForm1.aspx', 
            { "temp": inputTemp, "tempType": inputTempType },
            function (resp) {
                $("#result").text(resp["Temp"] + " " + resp["TempType"]);
            },
            "json"
        ).error(function () {
            $("#result").text('An unknown error has occurred.');
        });
        return false;
    });
});
