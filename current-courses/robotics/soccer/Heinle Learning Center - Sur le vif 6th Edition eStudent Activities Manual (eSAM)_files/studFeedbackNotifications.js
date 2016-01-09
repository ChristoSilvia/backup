// feedback list widget - just displays the list of feedback that gets passed in to it.
(function() {
  var widget = YAHOO.widget,
    util = YAHOO.util,
    Dom = YAHOO.util.Dom,
    Event = YAHOO.util.Event
  
  var FeedbackList = function (div, dataSource, timezoneOffset, windowName, numItems) {
    this.timezoneOffset = timezoneOffset;
    this.windowName = windowName;
    this.numItems = numItems;

    // don't use text formatter for title as we want to allow html.
    var dataheaders = [
      {key: "title", className: "submissionName", formatter: subNameFormatter},
      {key: "feedbackDate", formatter: feedbackDateFormatter, className: "feedbackDate"}
    ];

    FeedbackList.superclass.constructor.call(this, div, dataheaders, dataSource, {width: 430, MSG_EMPTY: "No instructor feedback found." });
    this.render();

    if (this.numItems > 0) {
      this.subscribe("rowClickEvent", onRowClickHandler);
      this.subscribe("rowMouseoverEvent", this.onEventHighlightRow);
      this.subscribe("rowMouseoutEvent", this.onEventUnhighlightRow);
    }
  };

  var onRowClickHandler = function(ev, target) {
    var oRecord = this.getRecord(ev.target);
    var url = oRecord.getData("url");
    window.open(url, this.windowName, "width=655,height=400,scrollbars=yes");
  };
  var feedbackDateFormatter = function(elCell, oRecord, oColumn, oData) {
    Dom.addClass(elCell, "feedbackDate");
    var feedbackdate = Number(oData);
    // adjust for display/computation
    elCell.innerHTML = FeedbackList.formatFeedbackDate(feedbackdate, this.timezoneOffset);
  };

  var subNameFormatter = function(elCell, oRecord, oColumn, oData) {
    var subName = oData;
    var exNumber = oRecord.getData("exNum");
    if (exNumber && exNumber !== "") {
      exNumber = "<span class='exNum'>" + exNumber + "</span> - ";
      subName = exNumber + subName;
    }
    elCell.innerHTML = subName;

  };

  YAHOO.lang.extend(FeedbackList, widget.DataTable, {
    numItems: 0
  });
  widget.FeedbackList = FeedbackList;
 
  widget.FeedbackList.getMSDiffFromNow = function(feedbackDate, timezoneOffset) {

    var feedbackdate = feedbackDate + timezoneOffset * 60 * 1000;
    var adjustedDate = new Date(feedbackdate);
    
    var currAdjustDate = new Date((new Date()).getTime() + timezoneOffset * 60 * 1000);
    var dateDiff = currAdjustDate.getTime() - adjustedDate.getTime();
    return dateDiff;
  };

  widget.FeedbackList.twentyFourHrsInMS = 24* 60 * 60 * 1000;
  widget.FeedbackList.fourDaysInMS = 4 * widget.FeedbackList.twentyFourHrsInMS;
  widget.FeedbackList.weekInMS = 7 * widget.FeedbackList.twentyFourHrsInMS;
 // function to format the feedback date which is in milliseconds from 1970
 // returns a string with the date formatted for display.
 widget.FeedbackList.formatFeedbackDate = function(feedbackDate, timezoneOffset)  {
    var feedbackdate = feedbackDate + timezoneOffset * 60 * 1000;
    var adjustedDate = new Date(feedbackdate);
    
    var currAdjustDate = new Date((new Date()).getTime() + timezoneOffset * 60 * 1000);
    var dateDiff = currAdjustDate.getTime() - adjustedDate.getTime();

    var oneDay = 24 * 60 * 60 * 1000;
    var fourDays = 4 * oneDay;
    var oneYear = 365 * oneDay;

    var hour = adjustedDate.getUTCHours();
    var isPM = hour >= 12;
    var displayHour = hour % 12;
    if (displayHour === 0) {
      displayHour = 12;
    }

    var dayOfMonth = adjustedDate.getUTCDate();
    var minutesStr = "";
    var minutes = adjustedDate.getUTCMinutes();
    minutesStr = minutes + "";
    if (minutes < 10) {
      minutesStr = "0" + minutesStr;
    }
    var timeStr = displayHour + ":" + minutesStr + " "
      + (isPM ? "p.m." : "a.m.");

    var adjustedFromMidnight = (hour * 60 + minutes ) * 60 * 1000;
    var monthStrs = ["January", "February", "March", "April", "May", "June",
                     "July", "August", "September", "October", "November", "December"];
    var dayStrs = ["Sunday", "Monday", "Tuesday", "Wednesday",
                   "Thursday", "Friday", "Saturday"];
    var month = monthStrs[adjustedDate.getUTCMonth()];
    var dayOfWeek = dayStrs[adjustedDate.getUTCDay()];
    if (dateDiff <= oneDay) {
      if (currAdjustDate.getUTCDate() === adjustedDate.getUTCDate()) {
        return "today at " + timeStr;
      }
      else {
        return "yesterday at " + timeStr;
      }
    }
    else if (dateDiff < (adjustedFromMidnight + oneDay)) {
      return "yesterday at " + timeStr;
    }
    else if (dateDiff < fourDays) {
      return dayOfWeek + " at " + timeStr;
    }
    else if (dateDiff < oneYear) {
      return month + " " + adjustedDate.getUTCDate();
    }
    else {
      return month + " " + adjustedDate.getUTCDate() + ", " + adjustedDate.getUTCFullYear();
    }


 };

})();


// feedback popover panel - popover, loads data, handles buttons, creates FeedbackList
(function() {
  var widget = YAHOO.widget,
    util = YAHOO.util,
    Dom = YAHOO.util.Dom,
    Event = YAHOO.util.Event


  var FeedbackNotifications = function(timezoneOffset, urlToGetData, limitNumParamName)
  {
    this.timezoneOffset = timezoneOffset;
    this.urlToGetData = urlToGetData;
    this.limitNumParamName = limitNumParamName;

    var config = {
      width: "450px",
      visible: false,
      draggable: false,
      constraintoviewport: true,
      close: false,
      modal: true,
      zindex : 10,
      fixedCenter: true
    };
    this.elem = document.createElement("div");

    this.elem.value = this;
    FeedbackNotifications.superclass.constructor.call(this, this.elem, config);


    Dom.addClass(this.element, "studFeedbackNotifsPanel");

    var header = 
      "<div class=\"notificationsHeader\"><table><tr>"
      + "<td class=\"title\">Instructor feedback</td>"
      + "<td class=\"closeLinkTd\"><a href=# id=\"feedbackNotifsClose\">close</a></td>"
      + "</tr></table></div>";

    var body =
      "<div id=\"feedbackNotifsBodyDiv\"></div>";

    this.setBody(body);


    var footer =
      "<div id=\"feedbackNotifsFooter\">"
      + "</div>";
    this.setFooter(footer);
    Event.onAvailable("feedbackNotifsBodyDiv", function() {
      this.loadNotifications(5);
    },
    this,
    true);
    Event.onAvailable("feedbackNotifsClose", function() {
      Dom.get("feedbackNotifsClose").blur();
    });

    Event.on("feedbackNotifsClose", "click", function(args) {
        Event.preventDefault(args);
        this.destroy();
      },
      this,
      true);


    this.setHeader(header);

    this.render(document.body);
    this.show();
    // part of fix for 45291
    this.elem.focus();
  };

  YAHOO.lang.extend(FeedbackNotifications, widget.Panel, {
    
    loadNotifications: function(numNotifs) {
      if (this.feedbacklist) {
        this.feedbacklist.destroy();
        this.center();
      }

      Dom.addClass("feedbackNotifsBodyDiv", "loading");

      var callbackObj = {
        success: function(o) {
          var dataStr = o.responseText;
          try {
            Dom.removeClass("feedbackNotifsBodyDiv", "loading");
            var data = YAHOO.lang.JSON.parse(dataStr);
            var numItems = data.feedbackList.length;
            var datasource = new util.LocalDataSource(data.feedbackList);
            if (numNotifs > 0 && numItems === numNotifs) {
              var footerEl = YAHOO.util.Dom.get("feedbackNotifsFooter");
              footerEl.innerHTML = 
                  "<input type=\"button\" id=\"viewAllBtn\" value=\"View all\" class=\"viewAllBtn\">";
              Event.on("viewAllBtn", "click", function(args) {
                Event.preventDefault(args);
                this.setFooter("");
                this.viewAllNotifications();
              },
              this,
              true);
            }

            if (numItems > 6) {
              Dom.addClass("feedbackNotifsBodyDiv", "scrollFeedback");
            }
            this.feedbacklist =
              new widget.FeedbackList("feedbackNotifsBodyDiv", datasource, -480, "testwname", numItems);
            this.center();
          }
          catch (e) {

          }
        },
        failure: function(o) {

        },
        scope: this
      };

      var loadUrl = this.urlToGetData + "&" + this.limitNumParamName + "=" + numNotifs;
      util.Connect.asyncRequest('GET', loadUrl, callbackObj); 
      
    },

    viewAllNotifications: function() {
      this.loadNotifications(-1);

    }


  });

  widget.FeedbackNotifications = FeedbackNotifications;

})();


(function() {
  var widget = YAHOO.widget,
    util = YAHOO.util,
    Dom = YAHOO.util.Dom,
    Event = YAHOO.util.Event


  var StudFeedbackNotifications = function(timezoneOffset, urlToGetData, elemId, numParamName)
  {
    this.elemId = elemId;
    this.urlForData = urlToGetData;
    this.tzOffset = timezoneOffset;
    this.numParamName = "studFeedbackNumNotifications";//numParamName;

    var elem = Dom.get(elemId);

    var callbackObj = {
      success: function(o) {
        try {
          var notifs = YAHOO.lang.JSON.parse(o.responseText);
          var notifarr = notifs.feedbackList;
          if (notifarr && notifarr.length > 0) {
            var recentNotif = notifarr[0];
            var diffFromNow = widget.FeedbackList.getMSDiffFromNow(recentNotif.feedbackDate, recentNotif.timezoneOffset);

            var txt = "";

            var displayDate = widget.FeedbackList.formatFeedbackDate(recentNotif.feedbackDate, recentNotif.timezoneOffset);
            if (diffFromNow < widget.FeedbackList.twentyFourHrsInMS) {
              txt = "New instructor feedback";
            }
            else if (diffFromNow < widget.FeedbackList.weekInMS) {
              txt = "Recent instructor feedback";
            }
            else {
              txt = "Instructor feedback";
              // part of fix for 45712
              displayDate = "updated " + displayDate;
            }

            util.Dom.get(this.elemId).innerHTML =
              "<span class=\"feedbackLinkSpan\">"
              + txt + "</span> <span class=\"feedbackLinkDate\">" + displayDate + "</span>";
            Event.on(this.elemId, "click", function(args) {
              this.notifsPanel = new widget.FeedbackNotifications(recentNotif.timezoneOffset, this.urlForData, this.numParamName);
            },
            this,
            true);


          }
        }
        catch (e) {

        }
      },
      failure: function(o) {
        //alert("failed to load notifs");
      },
      scope: this
    };
    util.Connect.asyncRequest('GET', urlToGetData, callbackObj, "&" + this.numParamName + "=" + 1); 

  }

  widget.StudFeedbackNotifications = StudFeedbackNotifications;

})();
