/**
 * Part of fix for bug 23857 - we want to ping the server
 * before submitting, and if we do not hear back/get an error,
 * tell the user to try again so that the users do not
 * get an uhoh or browser error page.
 */
(function() {
  var util = YAHOO.util,
      Dom = util.Dom,
      Event = util.Event;

  // setting z-index to 100 since timer has z-index of 50
  // to fix bug 27119

  // basic modal dialog that the user can close.
  var errordialog =
      new YAHOO.widget.Panel("healthChkErrorDlg", {
          fixedCenter: true,
          modal: true,
          visible: false,
          draggable: true,
          close: false,
          zindex: 101,
          width: "300px",
          constraintoviewport: true
      });
  errordialog.render();

  // NOTE: we need to load these images right away, because the only time
  // the dialog is shown is when we cannot contact the server, so we
  // need to preload the images from the server.

  var img;// = document.createElement("img");
  //Dom.setAttribute(img, "src", "/static/quia/images/warning.gif");
  
  // when dom ready, get class name of body to determine platform, and then get
  // the approgriate url for the warning image.
  Event.onDOMReady(function() {
    var bodyEl = Dom.getElementsBy(function() {return true;}, "body")[0];
    var bcs = Dom.getAttribute(bodyEl, "class");
    var platformCNames = ["centro", "georgetown", "hlc", "chengtsui", "estudio", "customdemo"];
    var imgUrl = "/static/quia/images/warning.gif";
    for (var i = 0; i < platformCNames.length; i++) {
      var currName = platformCNames[i];
      if (bcs && bcs.indexOf(currName) >= 0) {
        switch (currName) {
          case "centro":
            imgUrl = "/static/quia/images/warningCentro.gif";
            break;
          case "georgetown":
            imgUrl = "/static/quia/images/warningGT.gif";
            break;
          case "hlc":
            imgUrl = "/static/quia/images/warningHLC.gif";
            break;
          case "chengtsui":
            imgUrl = "/static/quia/images/warningCT.gif";
            break;
          case "estudio":
            imgUrl = "/static/quia/images/warningEstudio.gif";
            break;
          case "customdemo":
            imgUrl = "/static/quia/images/warningDemo.gif";
            break;
        }
      }
    }
    img = document.createElement("img");
    Dom.setAttribute(img, "id", "warnImg");
    Dom.setAttribute(img, "src", imgUrl);
  }, this, true);

  var gradientImg = document.createElement("img");
  Dom.setAttribute(gradientImg, "src", "/static/quia/images/gradientOrange.gif");
  gradientImg.id = "gradientImg";
  // modal dialog that the user cannot close.
  var errordialognoclose =
      new YAHOO.widget.Panel("healthChkErrorDlgNoClose", {
          width: "300px",
          fixedCenter: true,
          modal: true,
          visible: false,
          draggable: true,
          close: false,
          zindex: 101,
          constraintoviewport: true
      });

  var dlgheader = 
    "<div class='headerdiv' id='healthChkHeaderDiv'>"
    + "<table class='headerTable'>"
    + "  <tr><td>"
    + "Internet connection lost"
    + "  </td></tr></table>"
    + "</div>";
  var closeFooter = 
    "<div class='buttons'>"
    + "<input type='button' id='closeDlgBtn' value='Ok' class='quia_web_button'/>"
    + "</div>"
    + "<div id='healthCheckErrorDetails'></div>";

  var tryAgainFooter =
    "<div class='buttons'>"
    + "<input type='button' id='trynowbtn' value='Retry now' class='quia_web_button'/>"
    + "</div>"
    + "<div id='healthCheckErrorDetails'></div>";

  Dom.addClass(errordialog.element, "healthchkdlg");
  Dom.addClass(errordialognoclose.element, "healthchkdlg healthchkdlgnoclose");

  var handleHealthCheckSuccess = function(formObj) {
    if (formObj.isBeingSubmitted !== true) {
      formObj.isBeingSubmitted = true;
      if (formObj.markOkToLeave) {
        formObj.markOkToLeave();
      }
      formObj.submit_old();
    }
  };

  // there are some cases where we want the functionality but don't want to call form.submit 
  // once the health check succeeds. This can be used for this case. No ok button will be shown
  // and will continue trying to check the health. once succeeds, will call the function onSuccessFn.
  // -jhernandez Jan 2014
  window.checkHealthStandaloneUntilConnects = function(headerText, bodyText, onSuccessFn) {
    var checkHealth = function(attemptData) {
      attemptData.attempt++;
      var callback = {
        success: function(o) {
          var response = null;
          try {
            response = YAHOO.lang.JSON.parse(o.responseText);
          }
          catch (e) {
            response = null;
          }

          if (response === null || response.status !== "OK") {
            var errCode = response === null ? "S1" : "S2";
            showDialog(errordialognoclose, headerText, bodyText, o.argument.data, errCode); 
            addRetryAttempt(o.argument.data);
          }
          else {
            hideMask();
            errordialognoclose.hide();
            onSuccessFn();
          }
        },
        failure: function(o) {
          var statusRange = o.status % 100;
          var errCode = (statusRange === 4 || statusRange === 5) ? "F" + o.status : "";
          showDialog(errordialognoclose, headerText, bodyText, o.argument.data, errCode); 
          addRetryAttempt(o.argument.data);
          
        },
        timeout: 15000,
        cache: false,
        argument: {
          "data": attemptData
        }
      };
      util.Connect.asyncRequest('GET', "/actions/qStatus/checkhealth", callback, null);
    };

    var waitForRetry = function(data) {
      data.timeRemain -= 1;
      if (data.timeRemain <= 0 || data.tryNow) {
        if (data.tryNow) {
          data.tryNow = false;
        }
        checkHealth(data);
      }
      else {
        continueRetryWait(data);
      }
    };
    var continueRetryWait = function(data) {
      YAHOO.lang.later(1000, this, waitForRetry, data, false);
    };

    var addRetryAttempt = function(data) {
      var attempt = data.attempt;
      var time = Math.ceil(Math.random() * attempt * attempt);
      if (time < 5 && attempt > 2) {
        time = 5;
      }
      data.timeRemain = time;
      continueRetryWait(data);

    };


    var newData = { "attempt" : 0, "tryNow": false};
    checkHealth(newData);
  };

  // the last parameter is an associative array, with the key
  // being a value for a button, and the value
  // being the body text for the error message to display. If 
  // the event is null or does not match any value in the array, then 
  // it will fall back on bodyText.
  window.addHealthChecks = function(isTimed, headerText, bodyText, autoSubBody, customBodyTexts) {

    var handleHealthCheckFailure = function(oArg, errorCode) {
      var formObj = oArg.formobj;

      var span = document.createElement("span");
      span.innerHTML = '<input type="hidden" name="__hcf__" value="' + errorCode + '"/>';
      formObj.appendChild(span.firstChild);

      if (formObj.unmarkOkToLeave) {
        formObj.unmarkOkToLeave();
      }
      if (oArg.timeIsUp) {
        hideMask();
        handleTimedDialogAndRetry(headerText, autoSubBody, formObj, errorCode);
      }
      else {
        showErrorAndEnableSubmitsFn(headerText,
            bodyText,
            formObj,
            customBodyTexts,
            oArg.evtarget,
            errorCode);

        if (formObj.beforeSubmitAction) {
          formObj.action = formObj.beforeSubmitAction;
        }

        if (formObj.undoOnSubmitFail) {
          formObj.undoOnSubmitFail();
        }
      }
    };

    var delayedHealthChecks = [];

    var checkHealth = function(cbArgs) {
      var callback = {
        success: function (o) {
          var oarg = o.argument;
          var argform = oarg.formobj;
          var response = null;

          for (var i = 0, n = delayedHealthChecks.length; i < n; i += 1) {
            delayedHealthChecks[i].cancel();
          }

          //fix for bug 27208 -jhernandez 4/1/2011
          //if error parsing json, treat as failure.
          try {
            response = YAHOO.lang.JSON.parse(o.responseText);
          }
          catch (err) {
            response = null;
          }

          if (response === null) {
            handleHealthCheckFailure(o.argument, "S1");
          }
          else if (response.status !== "OK") {
            handleHealthCheckFailure(o.argument, "S2");
          }
          // if server responded ok, then go ahead and submit
          else {
            handleHealthCheckSuccess(argform);
          }
        },
        failure: function(o) {
          var now = new Date(),
              oArg = o.argument,
              timeSpentChecking = oArg.startCheck.getTime() - now.getTime(),
              statusRange = o.status % 100;

          if (statusRange === 4 || statusRange === 5 || timeSpentChecking > (2 * 1000)) {
            handleHealthCheckFailure(o.argument, "F" + o.status);
          }
          else {
            delayedHealthChecks.push(YAHOO.lang.later(500, this, function() {
              checkHealth(oArg);
            }));
          }
        },
        argument: cbArgs,
        // adding timeout for bug 27116
        timeout: 15000,
        cache: false
      };
      util.Connect.asyncRequest('GET', "/actions/qStatus/checkhealth", callback, null);
    };

    // for each form element, override submit
    Dom.getElementsBy(function() {return true;}, "form", document, function(frm) {

      // going to override submit so save the original submit function
      // so we can call that from our submit function
      frm.submit_old = frm.submit;

      frm.submit = function(event) {
        // fix for bug 27128 - mainly for IE need to get the
        // event target here, as if try later when want to
        // display the message, too late and will throw and error.
        var eventtarget;
        if (event) {
          YAHOO.util.Event.stopEvent(event);
          eventtarget = YAHOO.util.Event.getTarget(event);
        }

        var isTimeUp = isTimed && QQT && QQT.isTimeUp();

        // if time is up, then see if this form has been submitted
        // since time has been up, and if so, exit, otherwise
        // set hasBeenTimeUpSubmitted to true and continue
        //
        // This is to prevent a race condition where as the timer is about
        // to run out, the user clicks submit. When we get here, the time has
        // run out, and then the timer fires and tries to auto submit
        // the quiz. The user's submit click will now set that time was up
        // when it came thru, and so the auto submit will return.
        if (isTimeUp) {
          // fix for bug 27130
          showMask();
          if (frm.hasBeenTimeUpSubmitted) {
            return false;
          }
          else {
            frm.hasBeenTimeUpSubmitted = true;
          }
        }

        checkHealth({
          "formobj" : frm,
          "isTime" : isTimed,
          "timeIsUp" : isTimeUp,
          "evtarget" : eventtarget,
          "startCheck" : new Date()
        });

        return true;
      };
    });

  };

  // handle/show dialog for timed quizzes and add retry logic to try
  // submitting/checking server health
  var handleTimedDialogAndRetry = function (header, body, form, errorCode) {
    errordialog.hide();
    var data = { form : form, attempt: 0};
    showDialog(errordialognoclose, header, body, data, errorCode);
    addRetry(data);
  };

  // show error dialog that user can close
  // and renable submit buttons for form
  var showErrorAndEnableSubmitsFn = function (headerTxt, bodyTxt, formObj, customBodyTexts, eventtarget, errorCode) {
   
    var body = bodyTxt;
    if (eventtarget && customBodyTexts) {
      var eventVal = eventtarget.value;
      for (var key in customBodyTexts) {
       if (key === eventVal) {
          body = customBodyTexts[eventVal];
          break;
        }
      }
    }
    showDialog(errordialog, headerTxt, body, null, errorCode);
    enableSubmits(formObj);
  };

  // check the server health, and if it fails, adds a retry otherwise submits
  // the form
  var retryCheckAndSubmit = function (data) {
    data.timeLeft -= 1;
    if (data.timeLeft >= 0 && !data.tryNow) {
      continueWait(data);
      return;
    }

    //Dom.get('timeTilTryAgainTd').innerHTML = "";

    data.attempt++;
    var callback = {
      success: function(o) {
        var response = null;
        // fix for bug 27208 - jhernandez 4/1/2011
        // if error parsing json, then treat as failure case
        try {
          response = YAHOO.lang.JSON.parse(o.responseText);
        }
        catch (err) {
          response = null;
        }
        if (response === null || response.status !== "OK") {
          addRetry(o.argument.data);
        }
        else {
          handleHealthCheckSuccess(o.argument.data.form);
        }
      },
      failure: function(o) {
        addRetry(o.argument.data);
      },
      argument: {
        "data" : data
      },
      cache: false,
      // adding timeout for bug 27116
      timeout: 15000
    };

    util.Connect.asyncRequest('GET', "/actions/qStatus/checkhealth", callback, null);

  };

  // retry checking health/submitting passing thru data
  var addRetry = function (data) {

    if (data.tryNow) {
      data.tryNow = false;
      Dom.get("trynowbtn").disabled = false;
    }
    // using an exponential backoff approach
    // http://en.wikipedia.org/wiki/Exponential_backoff
    var attempt = data.attempt;
    var exp = attempt * attempt;
    var timeSec = Math.ceil(Math.random() * exp);
    if (timeSec < 5 && attempt >= 2) {
      timeSec = 5;
    }
    data.timeLeft = timeSec;
    YAHOO.lang.later(1000, this, retryCheckAndSubmit, data, false);
  };

  var continueWait = function (data) {
    //Dom.get('timeTilTryAgainTd').innerHTML = data.timeLeft + "s";
    YAHOO.lang.later(1000, this, retryCheckAndSubmit, data, false);
  };


  // function that goes thru the elements of form frm and if it has type
  // submit or reset, then enables it
  var enableSubmits = function(frm) {
    var elems = frm.elements,
        i = 0,
        len = elems.length;
    for ( ; i < len; i++) {
      var elType = elems[i].type.toLowerCase();
      if (elType === "submit" || elType === "reset") {
        elems[i].disabled = false;
      }
    }
  };


  var tryNowFn = function (mouseevent, data) {
    Dom.get("trynowbtn").disabled = true;
    data.tryNow = true;
  };
  
  var hideMask = function() {
    var m = Dom.get("healthcheckmask");
    if (!m) {
      return;
    }
    document.body.removeChild(m);
  };

  var showMask = function() {
    var isTextInput = function(input) {
      try {
        return ("text" === input.type);
      } catch(e) {
        // DO NOTHING
      }
      return false;
    };

    var blurInput = function(input) {
      try {
        input.blur();
      } catch(e) {
        // DO NOTHING
      }
    };

    // Blur all the text areas and text inputs.
    Dom.getElementsBy(function() {return true;}, "textarea", document, blurInput);
    Dom.getElementsBy(isTextInput, "input", document, blurInput);

    var mask = document.createElement("div");
    Dom.setAttribute("id", "healthcheckmask");
    Dom.setStyle(mask, "width", Dom.getDocumentWidth());
    Dom.setStyle(mask, "height", Dom.getDocumentHeight());
    Dom.setStyle(mask, "z-index", 100);
    Dom.setStyle(mask, "display", "block");
    Dom.setStyle(mask, "position", "absolute");
    Dom.setStyle(mask, "top", 0);
    Dom.setStyle(mask, "bottom", 0);
    Dom.setStyle(mask, "left", 0);
    Dom.setStyle(mask, "background-color", "#000000");
    Dom.setStyle(mask, "opacity", "0.25");
    document.body.appendChild(mask);

    mask.focus();
  };

  var showDialog = function (dialog, header, body, data, errorCode) {
    Dom.addClass(document.body, "yui-skin-sam");
    dialog.setHeader(dlgheader);
    if (dialog === errordialog) {
      dialog.setFooter(closeFooter);
    }
    else {
      dialog.setFooter(tryAgainFooter);
    }
    dialog.setBody(body);
    dialog.render(document.body);

    var div = Dom.get('healthChkHeaderDiv');
    div.appendChild(img);

    Dom.get("healthCheckErrorDetails").innerHTML = "[details: " + errorCode + "]";

    if (dialog === errordialog) {
      var closeBtn = Dom.get('closeDlgBtn');
      Event.addListener(closeBtn, "click", function () {
        this.hideMask();
        this.hide();
       }, errordialog, true);
    }
    dialog.show();
    if (dialog === errordialognoclose) {
      var btn = Dom.get("trynowbtn");
      if (btn) {
        Event.addListener(btn, "click", tryNowFn, data);
      }
    }
    dialog.sizeMask();
    dialog.showMask();
  };



}());

