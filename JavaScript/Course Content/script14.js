$(function() {
  // start up code goes here
  //alert("this works!");

  //$("#title").text("Yay, I can now get at the H1 immediately!");

  //$("#first").html("<h2>Great quotes</h2>");

  // append and prepend work INSIDE the given selection
  $("#first").prepend("<h2>Great quotes</h2>");
  $("#first").append("<h3>... for your to ponder ... </h3>");

  // before, after, insertBefore, insertAfter work OUTSIDE
  // the given selection.

  //$("#myAnchor").attr("href", "http://channel9.msdn.com");

  $("#title").addClass("standout");

});

















