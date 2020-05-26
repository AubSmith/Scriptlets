$(document).ready(function () {
    $('#myForm').live('submit', function () {
        var inputTemp = $('#temp').val();
        var inputTempType = $('#tempType').val();
        $.post('/WebForm1.aspx', 
            { "temp": inputTemp, "tempType": inputTempType },
            function (resp) {
            $("#result").text(resp["Temp"] + " " + resp["TempType"]);
            $("#result").css("background-color", "#00FF00");
            },
            "json"
        ).error(function () {
            $("#result").text('An unknown error has occurred.');
            $("#result").css("background-color", "#FF0000");
        });
        return false;
    });
    $('#temp').live('click', function () {
        $("#result").text("");
        $("#result").css("background-color", "");
    });

});
