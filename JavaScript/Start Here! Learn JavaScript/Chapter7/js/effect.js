$(document).ready(function () {
    $("form").live('submit', function () {
		var effect = $(":input[name=effect]").val();
		var options = {};
		var effectTime = 1000;
		if (effect === "transfer") {
			options = { to: "#trash", className: "transfer" };
			effectTime = 500;
		}
		$("#startHereBox").effect(effect, options, effectTime);
		return false;
	});
	$(":input[name=reset]").live('click',function() {
		$("#startHereBox").removeAttr("style");
	});

});
