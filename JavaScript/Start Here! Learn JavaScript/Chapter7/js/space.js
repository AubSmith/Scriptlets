$(document).ready(function () {
    $.ajax({        
        url: 'flights.aspx',
        dataType: "json",
        success: function(data) {
            var counter = 0;
            $.each(data, function(key, value) {
                $("#flightList").append('<li ' +
                       'id="flight' + counter + '"' + 
                       ' class="flightLi">' +
                       value['trip'] + '<span class="hiddenPrice">' + 
                       value['price'] + '</span></li>');
                counter++;
            });
        }               
    });     
    $("#priceSlider").slider({
        orientation: "vertical",
        min: 10000,
        max: 500000,
        step: 10000,
        value: 500000,
        slide: function (event, uiElement) {
            $("#flightDetails").html("<p>Flight Details</p>").addClass("hidden");
            var numRegex = /(\d+)(\d{3})/;
            var inputNum = uiElement.value;
            var strNum = inputNum.toString();
            strNum = strNum.replace(numRegex, '$1' + ',' + '$2');
            $("#spanPrice").text(strNum);
            $("#inputPrice").val(uiElement.value);
            $(".hiddenPrice").each(function() {
                if ($(this).text() > inputNum) {
                    $(this).parent().addClass("hidden");
                }
                else if ($(this).text() < inputNum) {
                    $(this).parent().removeClass("hidden");
                }
            });
        }
    });
    $(".flightLi").live('click', function () {
        $("#flightDetails").html("<p>Flight Details</p>").addClass("hidden");
        var myId = $(this).attr("id");
        $.ajax({
            url: "details.aspx",
            dataType: "json",
            data: { "flightID": myId },
            type: "POST",
            success: function (data) {
                $("#flightDetails").removeClass("hidden").append('<ul>' +
                        '<li class="detailsLi">Trip Duration: ' +
                          data['duration'] + '</li>' +
                        '</ul>');
            }
        });
    }); //end flightLi live click.
});

