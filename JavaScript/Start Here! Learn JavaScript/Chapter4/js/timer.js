
function redirect() {
         if (typeof(location.replace) !== "undefined") {
             location.replace("http://www.braingia.org?shjs-replace");
         } else {
             location.href = "http://www.braingia.org?shjs-href";
         }
     }

setTimeout('redirect()',5000);