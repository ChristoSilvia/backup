function isBlank(val){if(val==null){return true;}for(var i=0;i<val.length;i++){if((val.charAt(i)!=' ')&&(val.charAt(i)!="\t")&&(val.charAt(i)!="\n")&&(val.charAt(i)!="\r")){return false;}}return true;}

(function() {
  var UA = YAHOO.env.ua,
      Event = YAHOO.util.Event,
      Dom = YAHOO.util.Dom;

  // Fix IE's problem with background images
  if (UA.ie) {
    try {
      document.execCommand("BackgroundImageCache", false, true);
    } catch(err) {}
  }

  // Event handler for the expandable links list
  Event.addListener("doexpand", "click", function(ev) {
    Event.preventDefault(ev);

    // Blur the link click (hides the dashed outline in IE6)
    try {this.blur();} catch(e) {}

    // Toggle whether or not tools/workbooks is expanded
    var exDiv = Dom.getAncestorByClassName(this, "expandable"),
        expanded = Dom.hasClass(exDiv, "expanded");
    if (expanded) {
      Dom.removeClass(exDiv, "expanded");
    }
    else {
      Dom.addClass(exDiv, "expanded");
    }
  });

  // Add hint text to the tagSearchField
  Event.onAvailable("pagenav", function() {
    var inputs = this.getElementsByTagName("input");
    for (var i = 0; inputs && i < inputs.length; i++) {
      if (inputs[i].name == "tagSearchField") {
        inputs[i].value = "Page #";
        Event.addListener(inputs[i], "focus", function() {
          this.value = "";
        });
        Event.addListener(inputs[i], "blur", function() {
          if (isBlank(this.value)) {
            this.value = "Page #";
          }
        });
      }
      if (inputs[i].name == "tagSubmitKeywordSearch") {
        Dom.addClass(inputs[i], "quia_books_button");
      }
    }

    // Fix bug 13475 -ecurtis 6/18/08
    // Check on the height of the navi-text and make it fit if necessary
    Dom.getElementsByClassName("navi-text", "*", "hd", function() {
      if (this.scrollHeight > 30) {
        Dom.setStyle(this, "line-height", "15px");
      }
    })
  });

  // Fix bug 12987 -ecurtis 4/22/08 -- Change iframe width in Firefox 2.x
  if (UA.gecko && UA.gecko <= 1.8) {
    Event.onAvailable("yui-main", function() {
      var qframe = Dom.getLastChild(this);
      if (qframe.tagName.toUpperCase() == 'IFRAME') {
        Dom.setStyle(qframe, 'width', 'auto');
      }
    });
  }
  
})();

