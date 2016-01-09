// ----------------------------------------------------------------------------
// Copyright (c) 2005, Quia Corporation. All rights reserved.
//
// This script allows for the Quia accent bar.
//
// $Id$;
// ----------------------------------------------------------------------------

var ROLL_DIRECTION_STAY = 0;
var ROLL_DIRECTION_RIGHT = 1;
var ROLL_DIRECTION_LEFT = 2;
var hasBeenInitialized = false;

// ----------------------------------------------------------------------------
function toggleAccentBar() {

  switch (rollDirection) {
    case ROLL_DIRECTION_RIGHT:
      rollDirection = ROLL_DIRECTION_LEFT;
      break;

    case ROLL_DIRECTION_LEFT:
      rollDirection = ROLL_DIRECTION_RIGHT;
      break;

    default:
      rollDirection = ROLL_DIRECTION_LEFT;
      break;
  }

  activeAccentBar();

}



// ----------------------------------------------------------------------------
function getAccentBar() {

  bar = null;

  if (document.getElementById ("accentbar")) {
    bar = document.getElementById ("accentbar") ;
  }

  return bar;
}


// ----------------------------------------------------------------------------
function activeAccentBar() {


  bar = getAccentBar();

  if (bar) {

    // If the accent bar has not been initialized yet and it needs to
    // be, then initialize it now.
    if (!hasBeenInitialized && !isQuiaBookActivity) {
      accentSetup();
      hasBeenInitialized = true;
    }




    hasUpdated = false;

    currentYPos = parseInt(bar.style.top);
    currentPos = parseInt(bar.style.left);

    var m = navigator.userAgent.match(/MSIE\s([^;]*)/);
    var isIE = 0;
    if (m&&m[1]) isIE = m[1];

    // The accent bar needs to always be at the top of the page
    // if this is for a quia book activity
    if (isQuiaBookActivity) {
      if (isDockToTop) {
        if (isIE == 0) {
          bar.style.position = "fixed";
          bar.style.top = 0;
        }
        else if (currentYPos != document.body.scrollTop) {
          bar.style.top = document.body.scrollTop;
          hasUpdated = true;
        }
      }
      else if(isIE == 0) {
        bar.style.position = "absolute";
      }
    }


    else {

      switch (rollDirection) {

        case ROLL_DIRECTION_RIGHT:
          if (currentPos < MAX_X_POS) {
            bar.style.left =
              (currentPos + Math.abs((MAX_X_POS - currentPos) / 25) + 10)
              + "px";
            hasUpdated = true;

            currentPos = parseInt(bar.style.left);

            if (currentPos > MAX_X_POS) {
              bar.style.left = MAX_X_POS + "px";
            }

            showAccentBar();

          }

          break;

        case ROLL_DIRECTION_LEFT:
          if (currentPos > MIN_X_POS) {
            bar.style.left =
              (currentPos - Math.abs(currentPos / 25) - 10)
              + "px";

            currentPos = parseInt(bar.style.left);

            if (currentPos < MIN_X_POS) {
              bar.style.left = MIN_X_POS + "px";
              hideAccentBar();
            }
            else {
              showAccentBar();
            }

            hasUpdated = true;
          }
          break;

      }




      switch (rollDirection) {

        case ROLL_DIRECTION_RIGHT:
          documentHeight = document.body.clientHeight + document.body.scrollTop;
          documentHeight -= bar.clientHeight;
          documentTop = document.body.scrollTop;

          if (bar.style.position=="absolute") {
            if (currentYPos > documentHeight) {
              bar.style.top = documentHeight;
              hasUpdated = true;
            }
            else if (documentTop > currentYPos) {
              bar.style.top = documentTop;
              hasUpdated = true;
            }
          }

          currentPos = parseInt(bar.style.left);
          documentWidth = document.body.clientWidth + document.body.scrollLeft;
          documentWidth -= bar.clientWidth;
          documentLeft = document.body.scrollLeft;

          if (currentPos > documentWidth) {
            bar.style.left = documentWidth + "px";
            hasUpdated = true;
          }
          else if (documentLeft > currentPos) {
            bar.style.left = documentLeft + "px";
            hasUpdated = true;
          }

      }
    }


/*
    var IfrRef = document.getElementById('DivShim');
    bar.style.display = "block";
    IfrRef.style.width = bar.offsetWidth;
    IfrRef.style.height = bar.offsetHeight;
    IfrRef.style.top = bar.style.top;
    IfrRef.style.left = bar.style.left;
    IfrRef.style.zIndex = bar.style.zIndex - 1;
    IfrRef.style.display = "block";
*/




    // If there was an update, then we will need to perform the
    // refresh operation more frequently
    if (hasUpdated) {
      setTimeout("activeAccentBar()", 10);
    }

    // Otherwise we do a refresh in less frequent intervals
    else {
      setTimeout("activeAccentBar()", 100);
    }

  }





}


// ----------------------------------------------------------------------------
function showAccentBar() {

  bar = getAccentBar();
  bar.style.visibility = "visible";

}


// ----------------------------------------------------------------------------
function hideAccentBar() {

  bar = getAccentBar();
  bar.style.visibility = "hidden";

}






// ----------------------------------------------------------------------------
function getInfo() {

  if (document.getElementById ("info")) {
    bar = document.getElementById ("info") ;
  }

  return bar;
}

// ----------------------------------------------------------------------------
function showInfo() {

  bar = getInfo();
  bar.style.visibility = "visible";

}


// ----------------------------------------------------------------------------
function hideInfo() {

  bar = getInfo();
  bar.style.visibility = "hidden";

}



// ----------------------------------------------------------------------------

var whichTextField;

function puttext(text) {

  if (whichTextField != null) {

    // IE uses createTextRange
    if (document.all &&
        whichTextField.createTextRange &&
        whichTextField.caretPos) {  
      whichTextField.caretPos.text = text;
      whichTextField.caretPos.select();
    }

    // Mozilla uses setSelectionRange
    else if (whichTextField.setSelectionRange) {
      var rangeStart = whichTextField.selectionStart;
      var rangeEnd   = whichTextField.selectionEnd;
      var tempStr1 = whichTextField.value.substring(0,rangeStart);
      var tempStr2 = whichTextField.value.substring(rangeEnd);
      whichTextField.value = tempStr1 + text + tempStr2;
      setSelectionRange(whichTextField, rangeStart+1, rangeStart+1);
    }

    // Handle the default case.
    else {
      whichTextField.value += text;
      whichTextField.focus();
    }

  }

}


// ----------------------------------------------------------------------------
function setSelectionRange(input, selectionStart, selectionEnd) {
  if (input.setSelectionRange) {
    input.focus();
    input.setSelectionRange(selectionStart, selectionEnd);
  }
  else if (input.createTextRange) {
    var range = input.createTextRange();
    range.collapse(true);
    range.moveEnd('character', selectionEnd);
    range.moveStart('character', selectionStart);
    range.select();
  }
}



// ----------------------------------------------------------------------------
function setTextField(obj) {
  whichTextField = obj;

  if (whichTextField.createTextRange) {
    whichTextField.caretPos = document.selection.createRange().duplicate();
  }

}


// ----------------------------------------------------------------------------
function accentSetup() {
  xMoveTo('accentbar', -200, 20);
  xEnableDrag('accentbar', onDragStart, onDrag);
}


function onDragStart(ele, mx, my) {
  xZIndex('accentbar', highZ++);
}

function onDrag(ele, mdx, mdy) {
  xMoveTo('accentbar', xLeft('accentbar') + mdx, xTop('accentbar') + mdy);
}


/*
// ----------------------------------------------------------------------------
function DivSetVisible(state) {
   var DivRef = document.getElementById('PopupDiv');
   var IfrRef = document.getElementById('DivShim');
   if(state) {
    DivRef.style.display = "block";
    IfrRef.style.width = DivRef.offsetWidth;
    IfrRef.style.height = DivRef.offsetHeight;
    IfrRef.style.top = DivRef.style.top;
    IfrRef.style.left = DivRef.style.left;
    IfrRef.style.zIndex = DivRef.style.zIndex - 1;
    IfrRef.style.display = "block";
   }

   else {
    DivRef.style.display = "none";
    IfrRef.style.display = "none";
   }

  }
*/




