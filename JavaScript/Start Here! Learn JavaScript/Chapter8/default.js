// For an introduction to the Blank template, see the following documentation:
// http://go.microsoft.com/fwlink/?LinkId=232509
(function () {
    "use strict";

    var app = WinJS.Application;
    var ui = WinJS.UI;
    var utils = WinJS.Utilities;

    app.onactivated = function (eventObject) {
        if (eventObject.detail.kind === Windows.ApplicationModel.Activation.ActivationKind.launch) {
            if (eventObject.detail.previousExecutionState !==
Windows.ApplicationModel.Activation.ApplicationExecutionState.terminated) {
                // TODO: This application has been newly launched. Initialize 
                // your application here.
            } else {
                // TODO: This application has been reactivated from suspension. 
                // Restore application state here.
            }
            WinJS.UI.processAll();
        }
    };

    app.oncheckpoint = function (eventObject) {
        // TODO: This application is about to be suspended. Save any state
        // that needs to persist across suspensions here. You might use the 
        // WinJS.Application.sessionState object, which is automatically
        // saved and restored across suspension. If you need to complete an
        // asynchronous operation before your application is suspended, call
        // eventObject.setPromise(). 
    };

    app.start();


    function getSiteStatus() {
        var siteSubmit = document.getElementById("siteSubmit");
        siteSubmit.setAttribute("disabled", "true");
        var progress = document.getElementById("progress");
        progress.className = "win-ring";
        var siteURL = document.getElementById('siteURL').value;
        var resultMessage = document.getElementById('resultMessage');
        var resultStaticText = document.getElementById('resultStaticText');
        var appURL = "http://sr.sitereportr.com/siterep.php";
        var appID = "StartHere";
        var appKey = "5150";
        var params = "guid=" + appID;
        params += "&site=" + siteURL;
        params += "&key=" + appKey;
        WinJS.Promise.timeout(10000, WinJS.xhr({
            url: appURL,
            type: "POST",
            headers: { "Content-type": "application/x-www-form-urlencoded" },
            data: params
        }).then(function complete(result) {
            var siteSubmit = document.getElementById("siteSubmit");
            siteSubmit.removeAttribute("disabled");
            var progress = document.getElementById("progress");
            progress.className = "hide";
            if (result.responseText != "Invalid URL") {
                var myResult = JSON.parse(result.responseText);
            } else {
                var myResult = "Unknown";
            }
            if (myResult.status == "Up") {
                resultMessage.innerHTML = myResult.status;
                resultMessage.className = "resultUp";
                resultStaticText.className = "";
                resultMessage.setAttribute("display", "inline");

            } else if (myResult.status == "Down") {
                resultMessage.innerHTML = myResult.status;
                resultMessage.className = "resultDown";
                resultStaticText.className = "";
                resultMessage.setAttribute("display", "inline");
            } else {
                if (myResult.status == "Message") {
                    resultMessage.innerHTML = myResult.message;
                } else {
                    resultMessage.innerHTML = "Unknown";
                }
                resultMessage.className = "resultUnknown";
                resultStaticText.className = "";
                resultMessage.setAttribute("display", "inline");
            }
            // WinJS.Utilities.addClass(resultMessage, 'resultUp');
            //WinJS.Utilities.removeClass(resultMessage, 'hide');
            //WinJS.Utilities.removeClass(resultStaticText, 'hide');
        }, function error(error) {
            var siteSubmit = document.getElementById("siteSubmit");
            siteSubmit.removeAttribute("disabled");
            var progress = document.getElementById("progress");
            progress.className = "hide";
            resultMessage.innerHTML = "Error";
            resultMessage.className = "resultUnknown";
            resultStaticText.className = "";
            resultMessage.setAttribute("display", "inline");
        },
        function progress(result) {
            var progress = document.getElementById("progress");
            progress.className = "win-ring";
        }));
    } //end function getSiteStatus

    ui.Pages.define("default.html", {
        ready: function (element, options) {
            /*
            var form = document.getElementById('siteForm');
            form.addEventListener("submit", getSiteStatus, false);
            */
            document.getElementById('siteSubmit').addEventListener("click", getSiteStatus, false);
        }
    });

})();

