/**
 * assignmentcalendar.js
 *
 * JavaScript handling new functionality that comes with the new layout,
 * which Calendar and Assignment Lists page are accessed from same main button .
 *
 */

YAHOO.namespace("quiabook.assignmentCalendar");

var Dom = YAHOO.util.Dom,
    Event = YAHOO.util.Event,
    Cookie = YAHOO.util.Cookie,
    Element = YAHOO.util.Element,
    AssignCal = YAHOO.quiabook.assignmentCalendar;

AssignCal.setup= function() {

  /**
   *
   */
  var oActivityTbl = Dom.get("tblAssignIntDetail");
  var sCookieViewActivityOnlyCheckBox = "ckViewActOnly";
  var sCheckBoxId = "ckActOnly";


  /**
   * reload window with new URL when user select and change Chapter List  <select>
   */
  Event.addListener('chapterLi', 'change', function(ev){
    var eTarget = Event.getTarget(ev); 
    var nextUrl = eTarget.options[eTarget.selectedIndex].value.toString(); 
    document.location = nextUrl;
  }, null, false);


  /**
   * Look through #tblAssignIntDetail,
   * hide tr.secHdr that has no showing "tr.isAssigned" or "tr.notAssigned" 
   * hide tr.notAssigned
   */
  var hideUnassignedRows = function(bHide) {

    var noAssignedMsgDivCssClass = 'noAssignedMsg';

    var isActivityRow = function(el){
      if (Dom.hasClass(el, 'isAssigned')
          || Dom.hasClass(el, 'notAssigned')) {
        return true;
      }
      else {
        return false;
      }
    };

    var isSecHdrOrActivityRow = function(el) {
      if (Dom.hasClass(el, 'secHdr') || isActivityRow(el)) {
        return true;
      }
      return false;
    }
    
    // going through tr.notAssigned, hide it if user checked the checkbox (bHide)
    Dom.getElementsByClassName("notAssigned", "tr", oActivityTbl, function() {
      if (bHide) {
        Dom.setStyle(this, 'display', 'none');
      }
      else {
        Dom.setStyle(this, 'display', '');
      }
    });

    // we deal with tr.secHdr, and tr.notAssigned independently,
    // because they do not necessary dependent on each other.
    // ex. supplment section may have tr.notAssigned while there is no tr.secHdr
    //
    // going through tr.secHdr, and hide it if all it's "child" tr is hidden
    Dom.getElementsByClassName("secHdr", "tr", oActivityTbl, function() {

      var oCurrentRow = Dom.getNextSibling(this);
      var allTrHidden = true;

      if (bHide) {
        while(isActivityRow(oCurrentRow)) {
          if (Dom.hasClass(oCurrentRow, "isAssigned")) {
            allTrHidden = false; // has row that is showing
          }
          oCurrentRow = Dom.getNextSibling(oCurrentRow);
        }
      }
      else {
        allTrHidden = false;
      }

      if (allTrHidden) {
        Dom.setStyle(this, 'display', 'none');
      }
      else {
        Dom.setStyle(this, 'display', '');
      }

    });

    // we deal with tr.chapterHdr, tr.secHdr, and tr.notAssigned independently,
    // because they do not necessary dependent on each other.
    // ex. supplment section may have tr.notAssigned while there is no tr.secHdr
    //
    // going through chapterHdr, and insert text message if all it's dependency rows are hidden
    if (bHide) {
      Dom.getElementsByClassName("chapterHdr", "tr", oActivityTbl, function() {
        
        var elMsgDiv;
        var oTd;
        var oMsgDiv;
        var oMsgTxt;

        var oCurrentRow = Dom.getNextSibling(this);
        var allTrHidden = true;
        while(isSecHdrOrActivityRow(oCurrentRow)) {
          if (Dom.getStyle(oCurrentRow, "display") !== "none") {
            allTrHidden = false;
          }
          oCurrentRow = Dom.getNextSibling(oCurrentRow);
        }

        if (allTrHidden) {
          oTd = Dom.getElementBy(function(){return true;}, "td", this);
          oMsgDiv = document.createElement('div'); 
          oMsgTxt = document.createTextNode('There are no activities assigned in this section.');

          elMsgDiv = new Element(oMsgDiv);
          elMsgDiv.addClass(noAssignedMsgDivCssClass);
          elMsgDiv.appendChild(oMsgTxt)

          elMsgDiv.appendTo(oTd);
        }
      });
    }
    else {
      // unhide unassigned rows, removing text message
      Dom.getElementsByClassName(noAssignedMsgDivCssClass, "div", oActivityTbl, function() {
        var oParent = Dom.getAncestorByTagName(this, 'td');
        var elParent = new Element(oParent);
        elParent.removeChild(this);
      });
    }

  };


  /**
   * When users click the checkbox to "View assigned activities only",
   * run function alterArrayOfDomElementDisplayProperty
   */
  Event.addListener(sCheckBoxId, 'click', function(ev){
    var oCheckBox = Event.getTarget(ev);
    var bViewAssignedOnly = false;
    if (oCheckBox && oCheckBox.checked) {
      Cookie.set(sCookieViewActivityOnlyCheckBox, "true");
      bViewAssignedOnly = true;
    }
    else {
      Cookie.set(sCookieViewActivityOnlyCheckBox, "false");
    }
    hideUnassignedRows(bViewAssignedOnly);
  }, null, false);


  /**
   * when loading at the beginning, always check the checkbox for Viewing Assigned Activities Only,
   * and run necessary function to collapse unassigned activity
   */
  var oCheckBox = Dom.get(sCheckBoxId);
  if (oCheckBox) {
    if (Cookie.get(sCookieViewActivityOnlyCheckBox) == "false") {
      // user specifically do not want checked box, do nothing
    }
    else {
      oCheckBox.checked = true;
      Cookie.set(sCookieViewActivityOnlyCheckBox, "true");
      hideUnassignedRows(true);
    }
  }


  /**
   * hide textbook and activity legend that do not apply
   * 
   * Use following script to hide unused legend when #tblAssignIntDetail (oActivityTbl) is present.
   * #tblAssignIntDetail is the table name of the activity list on "View by chapter" page.
   * "View by date" page uses "/static/quia/book/dashboard.js" script to hide unused legend.
   */

  // Name/value pairs - "BookDraft.BookType" : "corresponding legend ID string"
  var oBkTypeLegendId = {
    "workbook": "wrkrow", // -1, default
    "textbook": "txtrow", // 0
    // "custom_resource": "", // 1
    // "wimba_book": "", // 2
    "laboratory_manual": "labrow", // 3
    "workbook_lab_manual": "wrklabrow", // 4
    "activities_manual": "actrow", // 5
    "manual": "manrow" // 6 
    // "additional_practice_workbook": "", // 7
    // "study_plans_workbook": "" //8
  };

  var aTypeOfActivity = [];
  var oLegend = Dom.get("tblCalLegend");
  var sUnhideThisLegend, oUnhideThisLegend;

  if (oActivityTbl && oLegend) {

    // hide all legend except green and red dot
    Dom.getElementsBy(
      function(el) { return !(el.id === "greenLeg" || el.id === "redLeg"); },
      "tr",
      oLegend,
      function(el) { Dom.addClass(el, "hiddenRow"); }
    );

    // get a list of activity type
    Dom.getElementsBy(function(el){
        return true;
      }, "tr", oActivityTbl, function(el){
      var bkType = Dom.getAttribute(el, "data-booktype");
      if (bkType) {
        aTypeOfActivity.push(bkType);
      }
    });

    // unhide legends correspond to retrieved "data-booktype" values 
    for (var i = 0; i < aTypeOfActivity.length; i++) {
      sUnhideThisLegend = oBkTypeLegendId[aTypeOfActivity[i]];
      if (sUnhideThisLegend) {
        oUnhideThisLegend = Dom.get(sUnhideThisLegend);
        if (oUnhideThisLegend) {
          Dom.removeClass(oUnhideThisLegend, "hiddenRow");
        }
      }
    }
  }

  /**
   * Setup tool tips for hover over the activity icons
   */
  if (oActivityTbl) {
    var aCtx = Dom.getElementsByClassName('bkTypeIcon', 'div', oActivityTbl);
    var ttBkTypeIcon = new YAHOO.widget.Tooltip(
      "ttBkTypeIcon", {
        context:aCtx,
        showdelay:0,
        xyoffset:[15,5]
       });

    var updateTooltipTxt = function(type, args) {
        
        var ttText = "";
        var context = args[0];
        var oTr = Dom.getAncestorByTagName(context, 'tr');

        var oSecTr = Dom.getPreviousSiblingBy(
          oTr,
          function(el){ return Dom.hasClass(el, 'secHdr') });
        
        var oChapterTr = Dom.getPreviousSiblingBy(
          oTr,
          function(el){ return Dom.hasClass(el, 'chapterHdr') });


        var sBkName = Dom.getAttribute(oTr, 'data-bookname');
        if (sBkName) {
          ttText = ttText + sBkName;
        }

        var sChapterName = Dom.getAttribute(oChapterTr, 'data-chaptername');
        ttText = ttText + '<br/>' + (sChapterName ? sChapterName : '');

        var sSecName = Dom.getAttribute(oSecTr, 'data-secname');
        if (sSecName) {
          ttText = ttText + (sChapterName ? ' > ' : '') + sSecName;
        } 

        this.cfg.setProperty("text", ttText);
    };
    
    ttBkTypeIcon.contextTriggerEvent.subscribe(updateTooltipTxt);
  }

};

YAHOO.register("assignmentCalendar", YAHOO.quiabook.assignmentCalendar, { version: "2.8.2r1", build: "1" });

