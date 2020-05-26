$(document).ready(function () {
    $.get('/WebForm1.aspx', function (resp) {
        var splitResp = resp.split("|");
        var splitRespLength = splitResp.length;
        for (var i = 0; i < splitRespLength; i++) {
            $("#treeNameLabel").append('<input type="checkbox"' +
                    'name="treeName" value="' + splitResp[i] +
                    '">' + splitResp[i] + '<br />');
        }
	
    });
});
