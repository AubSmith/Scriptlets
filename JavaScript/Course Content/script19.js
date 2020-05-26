$(function() {
  
  $('#clickme').click(function() {
   
    /*
    $.getJSON('data19.json', function(data) {

        var items = [];

        $.each(data, function(key, val) {

          items.push('<li id="' + key + '">' + val + '</li>');    

        });

        $('<ul/>', {
          'class': 'interest-list',
          html: items.join('')
        }).appendTo('body');

     });
     */
    
    $.ajax({
       url: 'data19a.json',
       dataType: 'json',
       success: function(data) {
          var items = [];

          $.each(data, function(key, val) {

            items.push('<li id="' + key + '">' + val + '</li>');    

          });

          $('<ul/>', {
             'class': 'interest-list',
             html: items.join('')
          }).appendTo('body');

       },
      statusCode: {
         404: function() {
           alert('There was a problem with the server.  Try again soon!');
         }
       }
    });
  });

});