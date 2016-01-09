/**
 * <p>
 * This version of "alttxt.js" is written to replace existing "alttxt.js".
 * Anonymous function that runs detection to determine if YUI 2 and required modules are present.
 * If YUI 2 and required modules are present, run script to setup following global methods:
 * <ul>
 * <li>window.writetxt</li>
 * <li>window.writetxtnowrap</li>
 * <li>window.writetxtcss</li>
 * </ul>
 * </p>
 * <p>
 * Required YUI 2 modules:
 * <ul>
 * <li>dom</li>
 * <li>event</li>
 * <li>event-delegate</li>
 * <li>element</li>
 * <li>containercore</li>
 * <li>selector</li>
 * </ul>
 * </p>
 * <p>
 * If either YUI 2 nor any of required module is missing, this script will load YUI 2 Loader and all required modules.
 * </p>
 * <p>
 * In addition to inline JavaScript to invoke window.writetxt, window.writetxtnowrap and window.writetxtcss,
 * user can also add "alttxt" CSS classname and "data-tooltip" attribute to a DOM element to enable overlay.
 * Data in "data-tooltip" will be used as content for the overlay.
 * </p>
 */

window.writetxt = function(){};
window.writetxtnowrap = function(){};
window.writetxtcss = function(){};

(function(win, doc){

  var nScript = doc.createElement('script'),
      nHead = doc.getElementsByTagName('head'),
      yui2BuildDirectory = '/yui2.9.0/';

  /**
   * wrapper function to handle adding event listener for both IE and non-IE browsers 
   * @method addEventSimple 
   */
  var addEventSimple =
      win.addEventListener ?
          function(obj, evt, fn) { obj.addEventListener(evt, fn, false); } :
          function(obj, evt, fn) { obj.attachEvent('on' + evt, fn); };

  /**
   * wrapper function to handle removing event listener for both IE and non-IE browsers 
   * @method removeEventSimple
   */
  var removeEventSimple =
    win.removeEventListener ?
      function(obj, evt, fn) { obj.removeEventListener(evt, fn, false); } :
      function(obj, evt, fn) { obj.detachEvent('on' + evt, fn); };

  /**
   * Some pages do not have quia.css loaded. Important CSS styling for .navtext would be missing.
   * This method add in-document style to the page.
   * @createInDocNavtextCSS
   */
  var createInDocNavtextCSS = function(Util) {
   
    var oStyleSheet,
        sNavtextCss = '.navtext, .navtextnowrap {';

    sNavtextCss += 'background-color: #FFFCE1;';
    sNavtextCss += 'font:normal 12px arial, helvetica, sans-serif;'; 
    sNavtextCss += 'border: 1px solid #666666;'; 
    sNavtextCss += 'max-width:600px;'; 
    sNavtextCss += 'overflow:hidden;'; 
    sNavtextCss += 'position:absolute;'; 
    sNavtextCss += 'width: auto;'; 
    sNavtextCss += 'z-index:999;'; 
    sNavtextCss += '} '; 

    sNavtextCss += '.navtext .bd, .navtextnowrap .bd';
    sNavtextCss += '{';
    sNavtextCss += 'margin:10px;';
    sNavtextCss += '} ';

    sNavtextCss += '.navtext .bd ol, .navtextnowrap .bd ol, .navtext .bd ul, .navtextnowrap .bd ul';
    sNavtextCss += '{';
    sNavtextCss += 'margin-left:2em;';
    sNavtextCss += '} ';

    sNavtextCss += '.navtextnowrap';
    sNavtextCss += '{';
    sNavtextCss += 'white-space: nowrap;';
    sNavtextCss += '} ';

    /** Fix for 38153 comment 11 */
    sNavtextCss += 'div.yui-module.navtext_toc div.bd {';
    sNavtextCss += ' font-size: 11px;';
    sNavtextCss += ' font-family: Verdana, Arial, Helvetica, sans-serif;';
    sNavtextCss += '}';


    if (typeof Util != "undefined" && Util.StyleSheet) {
      var oStyleSheet = new Util.StyleSheet(sNavtextCss);
    }
  };

  /**
   * <p>
   * Instantiate an Overlay. Render the overlay to the end of the document.
   * Add "mousemove" event listener to get coordinate for overlay's position.
   * Web pages may render with mouse pointer hovering over a DOM element that invoke overlay to render,
   * and without a "mousemove" event, the overlay will not have correct coordinate.
   * So, we also try to get coordinate by capture "mouseover" event at the BODY during initial page loading.
   * </p>
   * <p>
   * Max width for overlay is set to be 600px.
   * Inner DIV has a margin of 10px, so actual content will be 580px in width.
   * Please note that overlay will render with 1px border width.  So, total width will be 602px.
   * </p>
   * <p>
   * Setup window.writetxt, window.writetxtnowrap, window.writetxtcss to invoke the overlay "show" and "hide" methods.
   * </p>
   * <p>
   * Event listeners "mouseover" and "mouseout" for ".alttxt" DOM elements will trigger overlay to show and to hide.
   * These DOM elements provide content for overlay with data stored in "data-tooltip" attribute.
   * </p>
   * <p>
   * Setup callback functions for Overlay's beforeShow and hide events.
   * </p>
   * <p>
   * In beforeShow event callback function, the script examine spaces above, below, to the left and to the right
   * of the mouse pointer.  Spaces that is big enough and overall shape fits the overlay will gain higher score.
   * Overlay will show in space with highest score.
   * If necessary, inline width and height dimensions will be applied to overlay.
   * </p>
   * <p>
   * In hide event callback function, inline width and height dimentions will be removed.
   * </p>
   * @method setupAltTxtScript
   */
  var setupAltTxtScript = function(privateYAHOO) {
    
    // console.log('YAHOO-->', YAHOO);
    // console.log('sharedYAHOO-->', sharedYAHOO);
    // console.log('privateYAHOO -->', privateYAHOO);

    var docBd = doc.body,
        mouseX = 0,
        mouseY = 0,

        iWidth = 600,
        iBdrWidth = 2,
        iMaxWidthAllowed = iWidth + iBdrWidth,

        navDvCssCls = 'navtext',
        tooltipCssCls = 'alttxt',
        tooltipCssClsSelector = '.' + tooltipCssCls,

        YAHOO = privateYAHOO || sharedYAHOO,
        UA = YAHOO.env.ua,
        Lang = YAHOO.lang,
        util = YAHOO.util,
        IsNum = Lang.isNumber,
        Dom = util.Dom,
        Event = util.Event,
        Element = util.Element,
        Overlay = YAHOO.widget.Overlay,

        bHoverOccuredWithoutXY = false, // bug 38355, a overlay rendered without mouse pointer coordinate
        nBody = doc.getElementsByTagName('body'),

        aAlttxtTooltip,
        oTimer,

        i = 0, // timer cycle counter
        iTimerSafetyCancel = 10; // make sure timer is canceled after 10 cycle, no matter if document.body exists

    var navtxtOverlay = new Overlay("navtxt", {
        appendtodocumentbody:true,
        iframe:true,
        'visible':false
      });

    var elNavtxtOverlay = new Element(navtxtOverlay.element);

    // check to make sure quia.css is loaded, which contains important style for .navtext
    var quiaCssLink = Dom.getElementsBy(function(el) {

      var sHref = Dom.getAttribute(el, 'href');
      sHref = sHref ? sHref.toUpperCase() : '';
      if (sHref.indexOf('QUIA.CSS') > -1) {
        return true;
      }
      else {
        return false;
      }
    }, 'link');

    // if quia.css is not available, create in-doc style for .navtext
    if (quiaCssLink && quiaCssLink.length < 1) {
      // need to create inline CSS
      createInDocNavtextCSS(util);
    }

    /**
     * Helper function, adding event listener for hide event of the overlay, to remove added css classname.
     * @method addCleanupListener
     */
    var addCleanupListener = function(cssclass) {
      var cleanupListener = function() {
        elNavtxtOverlay.removeClass(cssclass);
        elNavtxtOverlay.hideEvent.unsubscribe(cleanupListener);
      };
      navtxtOverlay.hideEvent.subscribe(cleanupListener);
    };

    /**
     * For some pages, document.body is not available when script is running, which prevent overlay being rendered.
     * Therefore, we need to setup a timer to look for document.body.
     * When document.body is avaialbe, call "setupFunctionsDependingOnDocumentBody" method.
     * @setupFunctionsDependingOnDocumentBody
     */
    var setupFunctionsDependingOnDocumentBody = function() {
     
      docBd = document.body;
      navtxtOverlay.render(docBd);
          
      // track mouse location for legacy alttxt tooltip,
      // because it invoked by inline mouseover,
      // we need x, y location to position tooltip
      Event.on(docBd, 'mousemove', function(e) {
        if (e && e.clientX && e.clientY) {
          mouseX = e.clientX;
          mouseY = e.clientY;
        }
      });

      // look for DOM elements with 'alttxt' CSS classname
      aAlttxtTooltip = Dom.getElementsByClassName(tooltipCssCls);

      // if new tooltip link(s) is/are available, setup listener for it
      if (aAlttxtTooltip && aAlttxtTooltip.length > 0) {

        Event.delegate(docBd, 'mouseout', function(ev, matchedEl, container) {
          navtxtOverlay.hide();
        }, tooltipCssClsSelector);

        Event.delegate(docBd, 'mouseover', function(ev, matchedEl, container) {
          // double check to make sure it has "data-tooltip" attribute
          var tooltipData = Dom.getAttribute(matchedEl, 'data-tooltip');
          if (tooltipData) {
            navtxtOverlay.setBody(tooltipData);
            navtxtOverlay.show();
          }
        }, '.alttxt');
      }
    };

    // bug 37065
    // For Chrome, if there are applet present in iframe window, we want to hide the applet when hover/mouseover
    // occurs in the TOC.  To do so, we want to compile a list of applet and save it to the window global variable.
    // We verify that TOC is present, and compile an iframe list (if present), saving it to the window global variable.
    var setAppletWindowList = function(win, doc) {

      var nToc = null,
          iFrame = null,
          validIframeList,
          // winList = [{ "ParentNode":win, "IFrameWindow": win }],
          winList = [],
          appletList = [];

      // search for applet, if found, store it at window.appletList
      Dom.getElementsBy(function(el) {
        return true;
      }, 'applet', doc, function(nApplet) {
        appletList.push({"doc": doc, "applet": nApplet});
      });
   
      if (appletList.length > 0) { 
        win.appletList = appletList;
      }

      // if we are in window with TOC, check to see if there is an iframe, and store it for later use.
      nToc = doc.getElementById('toc');
      if (nToc) {
        validIframeList = Dom.getElementsBy(function(el) {
          return (el.src !== '');
        }, 'iframe', doc);

        for (i = 0; i < validIframeList.length; i += 1) {
          iFrame = validIframeList[i];
          if (iFrame.contentWindow) {
            winList.push({ "ParentNode":iFrame.parentNode, "IFrameWindow": iFrame.contentWindow});
            // winList.push(iFrame.contentWindow);
          }
        }
        if (winList.length > 0) {
          win.winList = winList;
        }
      }
    };

    // bug 37065 
    // For Chrome, when hover/mouseover occurs in the TOC section, we want to try to hide applet in the iframe.
    // We go through winList (if exists) and appletList (if exists), create a mask with brief message.
    // We hide the applet and present the mask when hover occurs.
    // We show the applet and remove the mask when hover is remvoed.
    var showAppletUponMouseover = function(bVisible) {

      var winList = win.winList,
          oWin, nWin, nWinParentNode, oWinParentNodeRegion,
          aApplet, oData, nApplet,
          i, j,
          nMask,
          oRegion,
          nBd,
          nDoc,
          nText,
          sMaskId = 'appletMaskId',
          sMessage = 'Applet is hidden temporary for pop-over.';

      if (winList && winList.length > 0) {

        for (i = 0; i < winList.length; i += 1) {

          oWin = winList[i];
          nWin = oWin.IFrameWindow;
          // nWinParentNode = oWin.ParentNode;
          // oWinParentNodeRegion = Dom.getRegion(nWinParentNode)

          if (nWin && nWin.appletList && nWin.appletList.length && nWin.appletList.length > 0) {

            aApplet = nWin.appletList;

            for (j = 0; j < aApplet.length; j += 1) {

              oData = aApplet[j];
              
              nApplet = oData.applet;
              nDoc = oData.doc;

              if (bVisible) {
                // remove mask
                nMask = nDoc.getElementById(sMaskId);
                if (nMask) {
                  nMask.parentNode.removeChild(nMask);
                }
                Dom.setStyle(nApplet, 'visibility', 'visible');
              }
              else {
                // add mask
                oRegion = Dom.getRegion(nApplet);
                
                nBd = nDoc.getElementsByTagName('body');
                nText = nDoc.createTextNode(sMessage);
                nMask = nDoc.createElement('div');
                
                Dom.setAttribute(nMask, 'id', sMaskId);
                Dom.setStyle(nMask, 'background', '#ececec');
                Dom.setStyle(nMask, 'border', '1px solid #ccc');
                Dom.setStyle(nMask, 'top', oRegion.top);
                Dom.setStyle(nMask, 'left', oRegion.left);
                Dom.setStyle(nMask, 'height', oRegion.height);
                Dom.setStyle(nMask, 'width', oRegion.width);
                Dom.setStyle(nMask, 'position', 'absolute');
                Dom.setStyle(nMask, 'text-align', 'center');
                Dom.setStyle(nMask, 'line-height', oRegion.height + 'px');
                Dom.setStyle(nMask, 'opacity', 0.5);

                nMask.appendChild(nText);

                if (nBd) {
                  nBd[0].appendChild(nMask);
                }
               
                Dom.setStyle(nApplet, 'visibility', 'hidden');
              } // else
            } // end for j
          } // end if (nWin && nWin.appletList && ....)
        } // end for i
      } // end if (winList.length > 0)
    };

    /**
     * @method writetxtcss
     */
    var writetxtcss = function(text, cssclass) {

      elNavtxtOverlay.addClass(cssclass);

      // navDVCssCls stores overlay's default CSS class, we do not want to remove that.
      // we remove all other css classname.
      if (cssclass !== navDvCssCls) {
        addCleanupListener(cssclass);
      }

      if (text === 0) {
        navtxtOverlay.hide();
      }
      else {
        navtxtOverlay.setBody(text);
        navtxtOverlay.show();
      }
    };

    win.writetxt = function(text) {
      writetxtcss(text, "navtext");
    };
    win.writetxtnowrap = function(text) {
      writetxtcss(text, "navtextnowrap");
    };
    win.writetxtcss = writetxtcss;

    elNavtxtOverlay.addClass(navDvCssCls);

    // For some pages, document.body is not available when this script is running.
    // This is true even when we use Event.onDOMReady.
    // We setup a timer running periodically to look for document.body.
    // Time is canceled when 10 cycles completed and document.body is still not found.
    if (docBd) {
      setupFunctionsDependingOnDocumentBody();
    }
    else {
      oTimer = Lang.later(500, null, function(o){
        if (document.body || i === iTimerSafetyCancel) {
          oTimer.cancel();
          setupFunctionsDependingOnDocumentBody();
        }
        else {
          i += 1;
        }
      }, {}, true);
    }

    // Bug 38355 - speng, 03/01/13
    //
    // In most cases, overlay is placed at correct position with coordinate derived from "mousemove" events.
    // When web pages refresh with mouse pointer to a DOM element that invoke hover,
    // initial overlay coordinate are set as zero (mouseX, mouseY), because no "mousemove" event has taken place yet.
    // As a result of that, overlay shows up on upper left hand corner rather than where mouse points to.
    //
    // To mitigate this problem, we want to capture the first mouseover event at the body and use it to set
    // our overlay coordinate (mouseX, mouseY).
    //
    // If a hover did occur already, with bHoverOccuredWithoutXY set as true, we want to move the overlay.
    Event.on(docBd, 'mouseover', function(e) {
      if (e && e.clientX && e.clientY) {
        mouseX = e.clientX;
        mouseY = e.clientY;
        if (bHoverOccuredWithoutXY && navtxtOverlay) {
          navtxtOverlay.moveTo(mouseX, mouseY);
        }
      }
      Event.removeListener(docBd, 'mouseover');
    });



    // setup callback function for overlay's "hide" event.
    navtxtOverlay.hideEvent.subscribe(function(ev) {
      elNavtxtOverlay.setStyle('width', 'auto');
      elNavtxtOverlay.setStyle('height', 'auto');
      showAppletUponMouseover(true); // bug 37065 
    });

    // setup callback function for overlay's "beforeShow" event.
    navtxtOverlay.beforeShowEvent.subscribe(function(ev) {
     
      var oOverlayRegion = Dom.getRegion(elNavtxtOverlay),
          vH = Dom.getViewportHeight(),
          vW = Dom.getViewportWidth(),
          oT = oOverlayRegion.top,
          oB = oOverlayRegion.bottom,
          oL = oOverlayRegion.left,
          oR = oOverlayRegion.right,
          oClientRegion = Dom.getClientRegion(),
          iClientTop = (oClientRegion ? oClientRegion.top : 0),
          iClientLeft = (oClientRegion ? oClientRegion.left : 0),
          x = mouseX,
          y = mouseY,
          iX = x,
          iY = y,
          iOffset = 8,
          oH = oB - oT,
          oW = oR - oL,
          aLayoutChoice = [],
          aPreferType = [],
          i, j, maxH, maxW, tempW, tempH, iScore, oPreferLayout, oTemp, sTemp;

      /**
       * We want to list 4 possible spaces where we can place the overlay when mouseover occurs.
       * Each spaces are represented with a configuration object, stating related attribute.
       * Some attributes needs simple calculation, and this function invoke required calculation. 
       * @method createOverlayLayoutOption
       */
      var createOverlayLayoutOption = function(config) {
        config.oX = config.getOverlayX();
        config.oY = config.getOverlayY();
        config.maxW = config.getMaxW();
        config.maxH = config.getMaxH();
        return config;
      };

      // all value are present, do evaluation of overlay placement and dimension.
      if (IsNum(vH) && IsNum(vW) && IsNum(oT) && IsNum(oB) && IsNum(oL) && IsNum(oR) && IsNum(x) && IsNum(y)) {

        // Many pages in Quia Book and Custom Books do not have doc type at all.
        // For IE, that means pages are rendered in Quirks mode.
        // IE (even for version 9) will ignore max-width. Therefore, we need to set width here.
        if (oW > iMaxWidthAllowed) {
          elNavtxtOverlay.setStyle('width', iWidth);
          oOverlayRegion = Dom.getRegion(elNavtxtOverlay);
          oT = oOverlayRegion.top || 0;
          oB = oOverlayRegion.bottom || 0;
          oL = oOverlayRegion.left|| 0;
          oR = oOverlayRegion.right || 0;
          oH = oB - oT;
          oW = oR - oL;
        }

        // For each possible layout, we calculate overlay coordinate and maxium width and height allowed. 
        // We push config objects into an array, aLayoutChoice. 
        // We compile a config object for each possible layout with "createOverlayLayoutOption" function.
        // We need to use a separate function some calculations are required.
        //
        // 4 possible layouts for tooltip, relative to where mouse pointer is:
        // 1. on top of
        // 2. at the bottom
        // 3. to the right
        // 4. to the left
        
        // possible layout, viewport top edge to top of mouse pointer, left to right edge of viewport
        aLayoutChoice.push(createOverlayLayoutOption({
          type: 'top',
          top: (0 + iOffset), // possible overlay top, we want some padding off the browser edge (iOffset)
          bottom: (y - iOffset), // possible overlay bottom, just above mouse y cooridnate with padding (iOffset)
          right: (vW - iOffset), // possible overlay right, viewport width minus iOffset as padding 
          left: (0 + iOffset), // possible overlay left, browser edge with some padding (iOffset)
          isOverlayWidthFitInViewport: ((oW + iOffset * 2) < vW), // current overlay & padding width vs viewport width
          isOverlayHeightFitInViewport: ((y - iOffset * 2 - oH) > 0), // current overlay height vs viewport height
          // if current overlay width fits within top possible layout width, then calculate the X coordinate,
          // else use the viewport edge minus some padding (iOffset). 
          getOverlayX: function(){ return this.isOverlayWidthFitInViewport ? (x - (x/vW * oW)): iOffset; },
          // if current overlay height fits within possible top layout height, then calculate the Y coordinate,
          // else use the viewport edge minus some padding (iOffset).
          getOverlayY: function(){ return this.isOverlayHeightFitInViewport ? (y - iOffset * 2 - oH) : iOffset; },
          // if current overlay width is too large for possible top layout, return max width allowed,
          // which is viewport width minus padding on both side (iOffset * 2).
          getMaxW: function(){ return this.isOverlayWidthFitInViewport ? null : (vW - iOffset * 2); },
          // if current overlay height is too tall for possible top layout, return max height allowed,
          // which is viewport height minus padding on both side (iOffset * 2).
          getMaxH: function(){ return this.isOverlayHeightFitInViewport ? null : (y - iOffset * 2); }
        }));

        // possible layout, viewport bottom edge to bottom of mouse pointer, left to right edge of viewport
        aLayoutChoice.push(createOverlayLayoutOption({
          type: 'bottom',
          top: (y + iOffset),
          bottom: (vH - iOffset),
          right: (vW - iOffset),
          left: (0 + iOffset),
          isOverlayWidthFitInViewport: ((oW + iOffset * 2) < vW),
          isOverlayHeightFitInViewport: ((y + iOffset * 2 + oH) < vH),
          getOverlayX: function(){ return this.isOverlayWidthFitInViewport ? (x - (x/vW * oW)): iOffset; },
          getOverlayY: function(){ return (y + iOffset); },
          getMaxW: function(){ return this.isOverlayWidthFitInViewport ? null : (vW - iOffset * 2); },
          getMaxH: function(){ return this.isOverlayHeightFitInViewport ? null : (vH - y - iOffset * 2); }
        }));

        // possible layout, viewport left edge to left of mouse pointer, bottom to top edge of viewport
        aLayoutChoice.push(createOverlayLayoutOption({
          type: 'left',
          top: (0 + iOffset),
          bottom: (vH - iOffset),
          right: (x - iOffset),
          left: (0 + iOffset),
          isOverlayWidthFitInViewport: ((x - iOffset * 2 - oW) > 0),
          isOverlayHeightFitInViewport: ((oH + iOffset * 2) < vH),
          getOverlayX: function(){ return this.isOverlayWidthFitInViewport ? (x - iOffset - oW) : iOffset; },
          getOverlayY: function(){ return this.isOverlayHeightFitInViewport ? (y - (y/vH * oH)) : iOffset; },
          getMaxW: function(){ return this.isOverlayWidthFitInViewport ? null : (x - iOffset * 2); },
          getMaxH: function(){ return this.isOverlayHeightFitInViewport ? null : (vH - iOffset * 2); }
        }));

        // possible layout, viewport right edge to right of mouse pointer, bottom to top edge of viewport
        aLayoutChoice.push(createOverlayLayoutOption({
          type: 'right',
          top: (0 + iOffset),
          bottom: (vH - iOffset),
          right: (vW - iOffset),
          left: (x + iOffset),
          isOverlayWidthFitInViewport: ((x + iOffset * 2 + oW) < vW),
          isOverlayHeightFitInViewport: ((oH + iOffset * 2) < vH),
          getOverlayX: function(){ return (x + iOffset); },
          getOverlayY: function(){ return this.isOverlayHeightFitInViewport ? (y - (y/vH * oH)) : iOffset; },
          getMaxW: function(){ return (this.isOverlayWidthFitInViewport ? null : (vW - x - iOffset * 2)); },
          getMaxH: function(){ return (this.isOverlayHeightFitInViewport ? null : (vH - iOffset * 2)); }
        }));

        // pick 2 possible type of layouts left vs right, top vs bottom
        // generally speaking, if mouse is at the top half of the page, we want overlay appear at the bottom.
        // if mouse is on the right side of the page, we want the overlay appear on the left.
        if (y > vH/2) { // mouse is at bottom half
          aPreferType.push('top');
        }
        else { // mouse is at top half
          aPreferType.push('bottom');
        }

        if (x > vW/2) { // mouse is at right half
          aPreferType.push('left');
        }
        else { // mouse is at left half
          aPreferType.push('right');
        }

        // determine which layout fits better, assign compatibility score
        for (i = 0; i < aLayoutChoice.length; i+=1) {

          oTemp = aLayoutChoice[i];
          iScore = 0;
          tempW = oTemp.right - oTemp.left;
          tempH = oTemp.bottom - oTemp.top;

          // space width can fit overlay in width
          if (tempW > oW) {
            iScore += 100;
          }

          // space height can fit overlay in height
          if (tempH > oH) {
            iScore += 100;
          }
         
          // preferred spaces gets extra score 
          sTemp = aPreferType.toString();
          if (sTemp && oTemp.type && sTemp.indexOf(oTemp.type) > -1) {
            iScore += 100;
          }

          // check the width versus height ratio of the space and overlay
          // similar ratio will deduct least amount of points
          oTemp.iScore = iScore - Math.abs(tempW/tempH - oW/oH);
        } 
        
        aLayoutChoice = aLayoutChoice.sort(function(a, b) {
          return (b.iScore - a.iScore);
        });

        oPreferLayout = aLayoutChoice[0];

        // need to apply width restriction to overlay
        if (oPreferLayout.maxW !== null) {
          elNavtxtOverlay.setStyle('width', oPreferLayout.maxW);
        }
        
        // need to apply height restriction to overlay
        if (oPreferLayout.maxH !== null) {
          elNavtxtOverlay.setStyle('height', oPreferLayout.maxH);
        }

        iX = oPreferLayout.oX + iClientLeft;
        iY = oPreferLayout.oY + iClientTop;
      } // end if

      // Bug 38355 - speng, 03/01/13
      // If hover coordinates are not set, both X and Y are 0/zero, it is possible that a overlay is displayed
      // at upper left hand corner.  We want to setup a flag to indicate that.
      // See additional notes for bug 38355 on this JavaScript file, "alttxt.js".
      if (x === 0 && y === 0) {
        bHoverOccuredWithoutXY = true;
      }

      showAppletUponMouseover(false); // bug 37065 
      navtxtOverlay.cfg.setProperty('xy', [iX, iY]);
    });
 
    // bug 37065 
    // iframe option for overlay is turned on, so overlay/mouseover/pop-over will be on top of applet.
    // However, for Chrome, that is not the case.  So, for Chrome, we need to hide the applet.
    // We want to delay the applet search for 1 second, because "alttxt.js" maybe loaded in the HEAD section.
    // In examples we found, "alttxt.js" is loaded at the bottom when applet is used.
    if (UA.chrome) {
      setTimeout(function() {
        setAppletWindowList(win, doc);
      }, 1000); 
    }
  };

  /**
   * Instantiate YUI 2 Loader; load 'dom', 'event', 'event-delegate', 'element', 'containercore', 'selector' modules.
   * @method setupYUI
   */
  var setupYUI = function() {

    // We use sandbox to make sure alttxt.js uses privately-scoped copy of YUI if any YUI 2 modules are being loaded.
    // This is because we had at least one case loading additional YUI modules interfered with pre-exist YUI code.
    //
    // To see an example, try following step:
    // 1. Use method "insert" rather than "sandbox" with instatiated YUI 2 loader.
    // 2. Change "if (YUtil.Dom && YUtil.Event && YUtil.Element && ..." below so that
    //    existing loader (loaded by other script on the page) is utilized.
    // 3. Login as "heinleinstructor" for HLC
    // 4. Drill into "Wie geht's? 9th Edition" course, class 1.
    // 5. Go to "Classes -> Assign" page, if any of the required moduel is not loaded 
    // 6. Make above "if" conditions failed, so this "else if" will be invoked.
    // 7. The "Assign Table" will not render.
    
    var loaderAlttxt;
    if (typeof YUtil != "undefined" && YUtil.YUILoader) {
      // sharedYAHOO, exists at the beginning of script
      loaderAlttxt = new YUtil.YUILoader();
    }
    else if (typeof YAHOO != "undefined" && YAHOO.util && YAHOO.util.YUILoader) {
      // YAHOO loaded by getYUILoader 
      loaderAlttxt = new YAHOO.util.YUILoader();
    }
    loaderAlttxt.sandbox({
      require: ['dom', 'event', 'element', 'containercore', 'selector', 'event-delegate', 'stylesheet'],
      onSuccess: function(o) {
        var privateYAHOO = o.reference;
        privateYAHOO.util.Event.onDOMReady(function() {
          setupAltTxtScript(privateYAHOO);
        });
      },
      loadOptional:true,
      base: yui2BuildDirectory,
      allowRollup: false
    });
  };

  /**
   * Load YUI 2 Loader, then run setupYUI method to load for all required modules.
   * @method getYUILoader
   */
  var getYUILoader = function() {
    nScript.setAttribute('id', 'yui2loader');
    nScript.setAttribute('type', 'text/javascript');
    nScript.setAttribute('src', yui2BuildDirectory + 'yuiloader/yuiloader-min.js');

    // for non IE browser, add event listener that upon successful loading of YUI 2 loader, run setupYUI
    addEventSimple(nScript, 'load', function(ev) {
      setupYUI();
    });

    // for IE browser, add event listener that upon successful loading of YUI 2 loader, run setupYUI
    addEventSimple(nScript, 'readystatechange', function(ev) {
      var readyState = (ev && ev.srcElement && ev.srcElement.readyState) ? ev.srcElement.readyState : '';
      if (readyState == 'complete' || readyState == 'loaded') {
        setupYUI();
      }
    });

    if (nHead && nHead[0]) {
      nHead[0].appendChild(nScript);
    }
  };

  /**
   * Variable "sharedYAHOO" represents YAHOO that is loaded by other script on the same page.
   * This become crucial when we need to use a privately scoped copy of YUI 2.
   * Please see notes in setupYUI method.
   * @variable sharedYAHOO
   */
  var sharedYAHOO = (typeof YAHOO != "undefined") ? YAHOO : {},
      YUtil = sharedYAHOO.util || {};

  // If YUI 2 and required modules are present, go ahead and run setupAltTxtScript function.
  if (YUtil.Dom && YUtil.Event && YUtil.Element && YUtil.StyleSheet &&
      YUtil.Event.delegate && YUtil.Selector && sharedYAHOO.widget && sharedYAHOO.widget.Overlay)
  {
    // console.log('if-->');
    YUtil.Event.onDOMReady(function() {
      setupAltTxtScript();
    });
  }

  // If YUI 2 Loader are present, but not all required YUI 2 modules, run setupYUI function to load required modules.
  else if (YUtil.YUILoader) {
    // console.log('else if-->');
    setupYUI();
  }

  // If required modules nor YUI 2 Loader are present, run getYUILoader function to load YUI 2 Loader.
  else {
    // console.log('else-->');
    getYUILoader();
  }

}(window, document));

