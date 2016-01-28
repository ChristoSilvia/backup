/**
 * smarticons.js
 *
 * Without this script, smart icon tooltips relies on CSS hover and it is not possible to change
 * toolip location.
 *
 * JavaScript at the end of book page will confirm smart icons existtances.
 * It will load this script, smarticon.js.
 * This script will remove tooltip DIVs from HTML while instantiating tooltips that will appear
 * when user hovers over corresponding DOM elements.
 */

YAHOO.namespace("quiabook.smarticons");

var Dom = YAHOO.util.Dom,
    Event = YAHOO.util.Event,
    Smarticons = YAHOO.quiabook.smarticons;

Smarticons.setup= function(aSmartIconLk) {

  var i, k, oTooltip, aShadow, sTooltipId, aDvBdr, aTxtDv, oTooltipTxt;

  for (i = 0; i < aSmartIconLk.length; i++) {

    // HTML/CSS rendered tooltip text are wrapped in DIVs, which is wrapped by DIV#dvBdr,
    // which is wrapped by DIV#shadow
    aShadow = Dom.getElementsByClassName('shadow', 'div', aSmartIconLk[i]);
    aDvBdr = Dom.getElementsByClassName('dvBdr', 'div', aSmartIconLk[i]);
  
    // remove HTML/CSS rendered tooltips from DOM,
    // we are going to instatiate them in following script
    aShadow[0].parentNode.removeChild(aShadow[0]);

    // get all tooltip text DIVs 
    aTxtDv = Dom.getChildren(aDvBdr[0]);

    // create DIV, insert tooltip text in it
    oTooltipTxt = document.createElement('div');
    for (k = 0; k < aTxtDv.length; k++) {
      oTooltipTxt.appendChild(aTxtDv[k]);
    }

    sTooltipId = "sTooltipId" + i.toString();
   
    // instantiate tool tips 
    oTooltip = new YAHOO.widget.Tooltip(sTooltipId, { 
      context:aSmartIconLk[i],
      container:'bd',
      underlay:'shadow',
      showdelay:0,
      hidedelay:0
    });
    oTooltip.setBody(oTooltipTxt);
  }
};

YAHOO.register("smarticons", YAHOO.quiabook.smarticons, { version: "2.8.2r1", build: "1" });

