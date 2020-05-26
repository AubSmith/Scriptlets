$(document).ready(function () {
    $.getJSON('/WebForm1.aspx', function (resp) {
        $.each(resp["Trees"], function(element,tree) {
            $("#treeNameLabel").append('<input type="checkbox"' +
            'name="treeName" value="' + tree +
            '">' + tree + '<br />');
        })
    }).error(function () {
        $("#treeNameLabel").append('<input type="checkbox"' +
                    'name="treeName" value="Birch"' +
                    '>Birch<br />');
    });
});
