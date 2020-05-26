$(function() {
  //alert('got here');
  $("#tabs").tabs().tabs("add", "C9JS_16.html", "Click-a-bob");
  $("#datepicker").datepicker({
    onSelect: function(dateText, inst) {
      $('#title').text("You picked: " + dateText);
    }
  });
});