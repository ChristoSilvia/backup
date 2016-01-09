/**
 * quia_20090514.js
 *
 * This file was created to house some random JavaScript snippet used in Quia Web, Quia Book and
 * Quia Custom Books.
 *
 */

var request = false;

var hideSpecialCookieFromJava, messageDivNameFromJava;
var bannerTypeFromJava, SpecialTagBannerFromJava;
// hideSpecialCookieFromJava, messageDivNameFromJava
// bannerTypeFromJava, SpecialTagBannerFromJava will be defined
// page by page when it calls drawHideMessageJavascript method

var tagWhereYFromJava = "whereY";
// tagWhereYFromJava is set by different java page and passed to here

// Disable buttons on submit defaults to true.  There are cases where we don't want to disable
// buttons when we submit the form, like before a recording has been submitted.  
// In those cases, set this flag to false.
var disableButtonsOnSubmit = true;

// This is the code for the special message utils.
(function() {
  var getMsgDiv = function() {
    if (document.getElementById) {
      return document.getElementById(messageDivNameFromJava);
    }
    else {
      return document.all[messageDivNameFromJava];
    }
  };

  var hostRegex = /[a-z]+\.(quia\.[a-z])/;

  var hideSpecialMessage = function(noCookieSet) {
    if (!noCookieSet) {
      var hostname = window.location.hostname,
          domain = "";

      // If on a quia.com, make the cookie a cross-domain cookie so it will persist between
      // all the quia sub-domains, like www.quia.com and secure.quia.com.
      if (hostRegex.test(hostname)) {
        domain = "; domain=" + hostname.replace(hostRegex, "$1");
      }

      document.cookie = hideSpecialCookieFromJava + '=hide_message; path=/' + domain;
    }
    var theDiv = getMsgDiv();
    theDiv.innnerHTML = '';
    // Part of fix for bug 7825 -ecurtis 9/21/06
    // Removed height:0
    // Added display:none
    theDiv.style.visibility = 'hidden';
    theDiv.style.display = 'none';
  };

  var drawSpecialMessageFromRequest = function() {
    if (request.readyState == 4) {
      if (request.status == 200) {
        var messageText = request.responseText;
        if (messageText.length > 0) {
          var theDiv = getMsgDiv();
          theDiv.innerHTML = messageText;
          theDiv.style.visibility = 'visible';
          // Part of fix for bug 7825 -ecurtis 9/21/06
          // Added display:block -- this displays the div
          theDiv.style.display = 'block';
        }
        else {
          hideSpecialMessage(true/* Don't set the cookie */);
        } // end if messageText.length > 0
      } // end if request.status == 200
    } // end if request.readyState == 4
  };

  var getSpecialMessage = function() {
    try {
      request = new XMLHttpRequest();
    } catch (error) {
      try {
        request = new ActiveXObject('Msxml2.XMLHTTP');
      } catch (error) {
        try {
          request = new ActiveXObject('Microsoft.XMLHTTP');
        } catch (error) {
          request = false;
        }
      }
    } // end try
    if (request) {
      // Fix bug 11904 -ecurtis 1/18/08 -- add try-catch
      try {
        var url =
          '/servlets/quia.common.modules.SpecialMessageServlet?'
        + SpecialTagBannerFromJava + '=' + bannerTypeFromJava
        + '&r=' + Math.random();  // Fix bug 38772 - disable caching in IE rliu 09/26/14
        request.open('GET', url, true);
        request.onreadystatechange = drawSpecialMessageFromRequest;
        request.send(null);
      } catch(error) {}
    } // end if request
  };

  // Expose some of the APIs
  window.hideSpecialMessage = hideSpecialMessage;
  window.getSpecialMessage = getSpecialMessage;

})();


// javascript that will disable the enter key
function handleEnter (field, event) {
  var keyCode = event.keyCode || event.which || event.charCode;

  // normally, the enter key has a keycode value of 13.
  // however, on the mac, the "right-side" enter key has a value of 3!
  return keyCode != 13 && keyCode != 3;
} // end func


// attempts to add a hidden input to the form 
// with name and value set to values of those in formElem, which is
// in the form. Returns false if could not append input
// otherwise true. Also, adds undo method to form to undo add.
// For image inputs, it will create input with name, name.x, name.y
// for .x and .y will set value to 2
function addInputToFormForFormElem(formElem) {
  var input = getInputWithNameValue(formElem.name, formElem.value);

  try {
    formElem.form.appendChild(input);
  }
  catch (err) {
    return false;
  }

  var input2 = null;
  var input3 = null;

  if (formElem.type === 'image') {
    input2 = getInputWithNameValue(formElem.name + ".x", 2);
    input3 = getInputWithNameValue(formElem.name + ".y", 2);
    try {
      formElem.form.appendChild(input2);
      formElem.form.appendChild(input3);
    }
    catch (ex) {
      return false;
    }
  }

  formElem.form.undoOnSubmitFail = function() {
      formElem.form.removeChild(input);
      if (formElem.type === 'image') {
        formElem.form.removeChild(input2);
        formElem.form.removeChild(input3);
      }
    }
    
  return true;
}

// create a hidden input with name name and value set to value.
function getInputWithNameValue(name, value) {
  var input = document.createElement('input');
  input.style.display = 'none';
  input.style.visible = 'hidden';
  if (input.setAttribute) {
    input.setAttribute("name", name);
    input.setAttribute("value", value);
  }
  else {
    input.name = name;
    input.value = value;
  }
  return input;  
}

// ARG!!! http://inmyexperience.com/archives/000428.shtml
// http://msdn.microsoft.com/library/default.asp?
// url=/workshop/author/dhtml/reference/methods/createelement.asp
//
// Javascript to allow us to disable all submit buttons the moment any
// submit button is clicked

function disableAllSubmitButtons(formObj, event) {
  var Dom = YAHOO.util.Dom;
  if (document.forms && document.createElement) {
    var fIndex = 0,
        fLen = document.forms.length,
        eIndex,
        eLen,
        tempForm,
        el,
        elType;
    // Fix to bug 22861 mweiss, create and append the input before trying to
    // disable the form.
    var input = getInputWithNameValue(formObj.name, formObj.value);
   
    try {
      formObj.form.appendChild(input);
    }
    // If we can't append the input, then just try to submit the form without
    // disabling the input
    catch(err) {
      formObj.form.submit(event);
      return true;
    }
   
    formObj.form.undoOnSubmitFail = function() {
      Dom.getElementsBy(function (elem) {
          if (Dom.getAttribute(elem, "name") === formObj.name
              && Dom.getAttribute(elem, "value") === formObj.value)
          {
            // Fix for bug 27129 - need to do OR on these even tho set
            // both since might be display:none visibility:visible -jhernandez 2/15/2012
            if (Dom.getStyle(elem, "display") === 'none' 
                || Dom.getStyle(elem, "visibility") === 'hidden') {
              return true;
            }
          }
          return false;
        },
        "input",
        formObj.form,
        function(elem) {
          formObj.form.removeChild(elem);
        });
      };
    for ( ; fIndex < fLen; fIndex++) {
      tempForm = document.forms[fIndex];
      eIndex = 0;
      eLen = tempForm.elements.length;
      for (; eIndex < eLen; eIndex++) {
        el = tempForm.elements[eIndex];
        elType = el.type.toLowerCase();
        if (elType == "submit" || elType == "reset") {
          el.disabled = disableButtonsOnSubmit;
        } // end if
      } // end for
    } // end for

    formObj.form.submit(event, formObj.form);
  } // end if
  return true;
} // end func

// taken from http://wwww.quirksmode.org/js/findpos.html
function getYOffset(obj) {
  var curtop = 0;
  if (obj.offsetParent) {
    var curObj = obj;
    while (curObj.offsetParent) {
      curtop += curObj.offsetTop;
      curObj = curObj.offsetParent;
    } // end while
  }
  else if (obj.y){
    curtop += obj.y;
  } // end if
  return curtop;
} // end func

function getFormElementInDocument(elemName) {
  var elem = null;
  if (document.forms) {
    for (var fIndex=0;elem == null && fIndex < document.forms.length;fIndex++){
      var tempForm = document.forms[fIndex];
      for (var index = 0;elem == null && index < tempForm.length; index++){
        var tempobj = tempForm.elements[index];
        if (tempobj.name == elemName) {
          elem = tempobj;
        } // end if
      } // end for
    } // end for
  } // end if
  return elem;
} // end func

function getWindowHeight() {
  var winHeight = -1;
  if (window.innerHeight) {
    winHeight = window.innerHeight;
  }
  else if (document.documentElement && document.documentElement.clientHeight
            && document.documentElement.clientHeight > 0) {
    winHeight = document.documentElement.clientHeight;
  }
  else if (document.body.clientHeight) {
    winHeight = document.body.clientHeight;
  } // end if
  return winHeight;
} // end func

// draw the javascript necessary to save and go to a scroll location
function getCurYLoc() {
  var yLoc = -1;
  if (window.pageYOffset) {
    yLoc = window.pageYOffset;
  }
  else if (document.body.scrollTop) {
    yLoc = document.body.scrollTop;
  } // end if
  return yLoc;
} // end func

function saveScrollCoordinates(curForm) {
  var yLoc = getCurYLoc();
  if (document.createElement) {
    var yInput = document.createElement("input");
    yInput.name = tagWhereYFromJava;
    yInput.id = tagWhereYFromJava;
    yInput.value = yLoc;
    // -ecurtis 7/6/06
    // Doing a try-catch when setting the type because it causes and uncaught
    // exception in IE5.
    // see: http://alt-tag.com/blog/archives/2006/02/ie-dom-bugs/
    try {
      yInput.type = "hidden";
    } catch(e) { yInput.style.visibility = 'hidden'; }
    curForm.appendChild(yInput);
  } // end if
} // end func

function scrollToCoordinates(whereY) {
  if (whereY != -1) {
    window.scrollTo(0, whereY);
  } // end if
} // end func

function gotoUrlWithWhereY(url) {
  var yLoc = getCurYLoc();
  url = url + "&" + tagWhereYFromJava + "=" + yLoc;
  window.location = url;
} // end func

function getWhereYandScroll(fieldName, whereY){
  if (fieldName != null) {
    var fieldElem = getFormElementInDocument(fieldName);
    if (fieldElem != null) {
      var fieldY = getYOffset(fieldElem);
      var winHeight = getWindowHeight();
      if (fieldY > -1 && winHeight > 0) {
        var quarterHeight = winHeight / 4;
        whereY = fieldY - quarterHeight;
      } // end if
    } // end if fieldElem != null
  } // end if fieldName != null
  if (whereY >= 0) {
    scrollToCoordinates(whereY);
  } // end if
} // end func


// addLoadEvent functionality
function addLoadEvent(func) {
  YAHOO.util.Event.onDOMReady(func);
}

// script to handle Quia Web Home functions, such as focus and blur,
// prepare teacher search field etc.

(function() {
  var lightColor = '#CCCCCC',
      origColor  = '#444444',
      firstTxt   = 'First Name',
      lastTxt    = 'Last Name',
      firstName  = 'firstName',
      lastName   = 'lastName';

  var setText = function(el, txt, color) {
    el.value = txt;
    el.style.color = color || lightColor;
  };

  // Expose the QUIHOME API
  window.QUIAHOME = {

    focus : function (target) {
      if ( (target.value === firstTxt && target.id === firstName) ||
           (target.value === lastTxt && target.id === lastName) ) {
        setText(target, '', origColor);
      }
    },

    blur  : function (target) {
      if (target.value === '' && target.id === firstName){
        setText(target, firstTxt);
      }
      if (target.value === '' && target.id === lastName){
        setText(target, lastTxt);
      }
    },

    prepareFindTeacher : function () {
      var firstObj = document.getElementById(firstName),
          firstVal = firstObj.value,
          secObj = document.getElementById(lastName),
          secVal = secObj.value;
      if (firstVal === '' || firstVal === firstTxt){
        setText(firstObj, firstTxt);
      }
      if (secVal === '' || secVal === lastTxt) {
        setText(secObj, lastTxt);
      }
    },

    processFindTeacherSubmit : function (formObj) {
      var firstObj = document.getElementById(firstName);
      var secObj = document.getElementById(lastName);
      if (firstObj.value === firstTxt) {
        firstObj.value = '';
      }
      if (secObj.value === lastTxt) {
        secObj.value = '';
      }
    }

  };
}());

/**
 * createBeforeUnload is used to warn user when they exit the Quiz Editor (Quia Web) without saving,
 * in this case, a submit event.
 * 
 * @param msg the message to show in the before unload dialog
 * @param closeCheck (optional) returns true if we should not show the before unload dialog, false
 * otherwise.  This method is ignored when the user hits submit.
 * @param submitCheck (optional) If submitCheck is specified, it overrides the method param as the check to use when the user submits.
 * This method will return true if we should not show the before unlaod dialog, false otherwise.
 * beforeUnload event handle
 */
(function() {
  var YU = YAHOO.util,
      Dom = YU.Dom,
      Event = YU.Event,
      UA = YAHOO.env.ua;

  var alwaysTrue = function() {
    return true;
  };

  var alwaysFalse = function() {
    return false;
  };

  var isSubmitOrResetOrImage = function (el) {
    var type = (el.type ? el.type.toLowerCase() : null);
    return type === "submit" || type === "reset" || type === "image";
  };

  window.createBeforeUnload = function(msg, closeCheck, submitCheck) {

    // Old versions of Safari don't play well with disabling submit buttons
    // and having the beforeUnload event. To fix this, don't add a beforeUnload.
    // Or, if we've already added the listeners, don't add it again.
    if ((UA.webkit && UA.webkit < 419) || Event.getListeners(window, "beforeunload")) {
      return false;
    }

    closeCheck = closeCheck || alwaysFalse;

    var okToLeave = false;
    
    // A function to say, yes it is ok to leave the page. 
    var markOkToLeave = function() {
      okToLeave = true;
    };

    var unmarkOkToLeave = function() {
      okToLeave = false;
    }

    // Add listeners to the forms submit events, as well as the click
    // events for all submit and reset buttons.
    Dom.getElementsBy(alwaysTrue, "form", document, function(frm){
    
      // Add click event listeners to all the forms input DOM objects,
      // attaching to markOkToLeave as long as these DOM objects pass
      // the requirement test of isSubmitOrResetOrImage.
      Event.addListener(
        Dom.getElementsBy(isSubmitOrResetOrImage, "input", frm),
        "click", markOkToLeave);

      // Add click event listeners to all the forms a.switchViewEditLk,
      // attaching to markOkToLeave
      Event.addListener(
        Dom.getElementsByClassName("switchViewEditLk", "a", frm),
        "click", markOkToLeave);

      // Unfortunately, a call from javascript to "submit" doesn't fire the
      // submit event, so we have to work around this by overriding the
      // real submit function with a fake one.
      frm._submit = frm.submit;
      frm.submit = function(event) {
        markOkToLeave();
        frm._submit(event);
      };

      // put these on the form because we may need to call these 
      // for instance if user not connected to internet and we show
      // error dialog, been marked ok to leave but need to unmark
      frm.unmarkOkToLeave = function() {
        unmarkOkToLeave();
      };
      frm.markOkToLeave = function() {
        markOkToLeave();
      };
    });
    

    // Listen for the beforeunload event
    Event.addListener(window, "beforeunload", function(ev) {
      var notOkayToSubmit;
      if (okToLeave && YAHOO.lang.isFunction(submitCheck)) {
        notOkayToSubmit = !submitCheck();
      }
      else {
        notOkayToSubmit = !okToLeave && !closeCheck();
      }
      if (notOkayToSubmit) {
        // fixes bug 39108 - issue is that if here, not going to submit,
        // but health check assumes will submit, so need to say no longer submitting
        // -jhernandez May 2013
        Dom.getElementsBy(alwaysTrue, "form", document, function(frm) {
          frm.isBeingSubmitted = false;
        });
        if (ev) {
          ev.returnValue = msg;
        }
        return msg;
      }
    });

  };
})();


/**
 * textPlaceholder function
 *
 * If browser does not support placeholder attribute, we will add listener, method to emulate it.
 * @param cssClsPlaceholder String CSS classname applied when placeholder (as default) value shown.
 */
(function() {

  var util = YAHOO.util,
      Dom = util.Dom,
      Event = util.Event;

  var conditionalCreateById = function(el, func, args) {
    el = Dom.get(el);
    if (el) {
      return func.apply(el, args);
    }
    return false;
  };
  
  var conditionalCreateByClassName = function(el, func, args) {
    var aEl = Dom.getElementsByClassName(el);
    if (aEl) {
      for (var i = 0; i < aEl.length; i++){
        func.apply(aEl[i], args);
      }
    }
    return false;
  };

  var textPlaceholder = function(cssClsPlaceholder) {
    // if browser support placeholder attribute, we skip rest of the function.
    if ('placeholder' in document.createElement(this.tagName)) {
      return;
    }

    // if placeholder attribute of the input field is not defined or empty, we exit this funtion
    if (!this.getAttribute('placeholder')) {
      return;
    }
    var placeholder = this.getAttribute('placeholder'),
        cssClass = cssClsPlaceholder || 'text-placeholder';

    if (this.value === '' || this.value == placeholder) {
      Dom.addClass(this, cssClass);
      this.value = placeholder;
    }

    Event.addListener(this, 'focus', function() {
      if (Dom.hasClass(this, cssClass)) {
        this.value = '';
        Dom.removeClass(this, cssClass)
      }
    });

    Event.addListener(this, 'blur', function() {
      if (this.value === '') {
        Dom.addClass(this, cssClass);
        this.value = placeholder;
      }
      else {
        Dom.removeClass(this, cssClass);
      }
    });

    if (this.form) {
      Event.addListener(this.form, 'submit', function() {
        if (Dom.hasClass(this, cssClass)) {
          this.value = '';
          Dom.removeClass(this, cssClass);
        }
      }, this, true);
    }

  };

  Event.onDOMReady(function() {
    // input#qbkey, book key/course code input field, Quia Book, Quia Custom Platform
    conditionalCreateById("qbkey", textPlaceholder, []);
    conditionalCreateByClassName("plcHldr", textPlaceholder, []);
  });

}());


(function() {

  var util = YAHOO.util,
      Dom = util.Dom,
      Event = util.Event;
 
  var conditionalCreateByClassName = function(el, func, args) {
    var aEl = Dom.getElementsByClassName(el);
    if (aEl) {
      for (var i = 0; i < aEl.length; i++){
        func.apply(aEl[i], args);
      }
    }
    return false;
  };

  /**
   * Generic method to open a new web browser window.
   *
   * To use it, insert CSS class name of "openNewWindow" within an A tag.
   * Upon DOM completed loading, script will go through the DOM tree looking for A tags
   * with openNewWindow CSS class name.
   *
   * Default new window configuration can be modified with a name-value pairs object as parameter.
   * Insert a new conditionalCreate with a different CSS class name and customized parameter object.
   *
   * @method openNewWindow
   * @requires yahoo, dom, event
   * @param oCustomize A object of name-value pairs that insert new and overwrites default values 
   */
  var openNewWindow = function(oCustomize) {

    var winConf = "", j = 0, i = 0;
    var newWindowDefaultConfig = {
      width:800,
      height:600,
      screenX:75,
      screenY:75,
      resizable:"yes",
      scrollbars:"no",
      toolbar:"yes", 
      alwaysraised:"yes"
    };
 
    if (oCustomize) {
      YAHOO.lang.augmentObject(newWindowDefaultConfig, oCustomize, true);
    }
    
    for (prop in newWindowDefaultConfig) {
      if (newWindowDefaultConfig.hasOwnProperty(prop)) {
        winConf = winConf + prop.toString() + "=" + newWindowDefaultConfig[prop].toString() + ",";
      }
    }

    winConf = winConf.slice(0, (winConf.length-1));

    Event.addListener(this, 'click', function(ev){
      Event.preventDefault(ev);
      var oTarget = Event.getTarget(ev);
      var newWin = window.open(oTarget.href, '', winConf);
    }, null, false);
  };

  Event.onDOMReady(function() {
    conditionalCreateByClassName("openNewWindow", openNewWindow, []);

   
    // bug 27459 - speng, 05/10/211 
    // Share It Activities viewed from Quia Book grading bench,
    // a link says "View file and comments in Share It!, it will open a new window
    conditionalCreateByClassName("newWinScroll", openNewWindow, [{scrollbars:"yes"}]);
  });

}());


/**
 * For forms that does not wish to submit on -enter-,
 * put a classname "noSubmitOnEnter" as an attribute to the FORM tag,
 * following script will "prevent default" for keypress event from enter key.
 * 
 * Need to make exception for TEXTAREA tag, because newlines should be allowed.
 *
 * If user has focus on the input type=submit, -enter- will work as well.
 *
 * This is easier than adding onkeypress inline script to invoke function handleEnter().
 */
(function() {
  var Dom = YAHOO.util.Dom,
  Event = YAHOO.util.Event;

  var conditionalCreate = function(el, func, args) {
    var aEl = Dom.getElementsByClassName(el, 'FORM', document.body);
    if (aEl) {
      for (var i = 0; i < aEl.length; i++){
        func.apply(aEl[i], args);
      }
    }
    return false;
  };

  var noSubmitOnEnter = function(ev) {
    var keyCode = ev.keyCode ? ev.keyCode : ev.which ? ev.which : ev.charCode;
    var oTarget = Event.getTarget(ev);
    // keycode for -enter- is 13 or 3
    if (keyCode === 13 || keyCode === 3) {
      // for textarea, return true
      if (oTarget.tagName.toLowerCase() === 'textarea') {
        return true;
      }

      if (oTarget.tagName.toLowerCase() === 'input'
          && oTarget.type.toLowerCase() === 'submit') {
        return true;
      }

      Event.preventDefault(ev);
      return false;
    }
  };

  var applyNoSubmitOnEnterListener = function(aDomElement) {
    Event.addListener(this, 'keypress', noSubmitOnEnter);
  };

  // looking for form.noSubmitOnEnter, apply listener for event keypress
  Event.onDOMReady(function() {
    conditionalCreate("noSubmitOnEnter", applyNoSubmitOnEnterListener, []);
  });

}());

/**
 * bug 28678 - speng, 09/12/2011
 *
 * When user click on web links to open new separate window, Quia Web, Quia Book and Quia Custom
 * Books utilize "return false" and "href='#'" to prevent default behavoir excuted by the browser.
 * While this approach worked well often, occasionally the "#" sign as the HREF value invoke the
 * browser to reload.
 *
 * As a fix to this bug, we will place a listener to the 'document' DOM element.  If it is an
 * "a" tag link with "#" as the value for HREF attribute, we will "prevent default".
 *
 * We have similar fix for IXL.
 * For more information, please view file "/yui3/ixl/prepage/js/preventDefault.js".
 *
 * This particular fix is different from those in IXL. This does require YUI being loaded.
 */

(function(){

  var Dom = YAHOO.util.Dom,
  Event = YAHOO.util.Event;

  var isLinkTag = function(oTarget) {
    var lcTagName = oTarget.tagName.toLowerCase();
    return lcTagName === 'a' || lcTagName === 'area';
  };

  Event.onDOMReady(function() {
    Event.addListener(document, 'click', function(ev){
      var oTarget = Event.getTarget(ev);
      if (oTarget
          && isLinkTag(oTarget)
          && Dom.getAttribute(oTarget, 'href') === '#') {
        Event.preventDefault(ev);
        return false;
      }
    });
  });

}());


