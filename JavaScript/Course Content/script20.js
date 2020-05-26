/*
$(function() {

  function buildACat() {  
    var catName = "Mr. Tibbles";  
    function catFactory() { 
      // functional scoping: in JavaScript, the scope 
      // of a variable is defined by its location within 
      // the source code, and nested functions have 
      // access to variables declared in their outer scope 

      alert(catName);  
    }  
    catFactory();  // () means it executes the inner method immediately
  }

  $('#buildcat').click(function() {
    buildACat();
  });
   
});
*/

/*
$(function() {
  function buildACat() {
    var catName = "Tuffy";
    function catFactory() {
      alert(catName);
    }
    // Notice: instead of executing it, it just 
    // returns a REFERENCE!
    return catFactory;
  }
  
  $('#buildcat').click(function() {
    var myNewCat = buildACat();
    // buildACat() has executed.  It has gone out of scope now,
    // and all its private function variables with it, right?  Right?
    
    myNewCat(); // <-- Not so fast ... the catName variable value LIVES!
  });


});
*/

a = (function() {
      var privateFunction = function() {
        alert('hello');
      }

      return {
        publicFunction: function() {
          privateFunction();
        }
      }
    })();

a.publicFunction();






















