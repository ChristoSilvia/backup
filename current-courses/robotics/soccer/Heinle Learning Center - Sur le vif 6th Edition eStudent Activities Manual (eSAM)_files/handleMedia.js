function setAudioLinks() {
  // DO NOTHING... THIS IS LEGACY!
}

/************************************************************************************************
 * Audio embed (qb_mp3_sm, qb_mp3_lg, and pop-up mp3)
 ************************************************************************************************/
(function($) {

  var useEmbedPlayer = true;

  // If flash was supposed to be installed and it's not, there's a paragraph tag that
  // asks you to install it... we don't want to do this, so just open the window as normal
  var requiresNonEmbed = function (player) {
    return useEmbedPlayer === false;
  };

  var handlePlayerError = function(ev) {
    switch (ev.jPlayer.error.type) {
      case $.jPlayer.error.NO_SOLUTION:
      case $.jPlayer.error.NO_SUPPORT: {
        useEmbedPlayer = false;
        goAheadLaunchPluginIfQuiaWebAudioWindow();
        break;
      }
    }
  };

  var usePluginUri = "usePlugin=true";

  // bug 30785: if we know jPlayer failed, try reload and use plugin
  var goAheadLaunchPluginIfQuiaWebAudioWindow = function() {
    // verify we are in Quia Web Audio Player Window, and URL does not ask for "usePlugin" option
    // reloading with use Plugin parameter
    var oQwAudioWinBody = $('#qwAudioWin');
    if (oQwAudioWinBody.length > 0 && document.location.search.indexOf(usePluginUri) < 0) {
      var tempUrl = document.location;
      document.location = tempUrl + "&" + usePluginUri;
    }
  };

  var createPlayer = function(onReady, positionPlayer) {

    var ids = insertPlayerHTML();

    positionPlayer(ids.playerId);

    if (!$.support.boxModel) {
      $('#' + ids.playerId).addClass("bbmodel");
    }

    var updateInterface = function(ev) {
      var status = ev.jPlayer.status;
      $('#' + ids.playBarId).slider('option', 'value', status.currentPercentAbsolute);
      $('#' + ids.loadBarId).progressbar('option', 'value', status.seekPercent);
    };

    var jp = $('#' + ids.audioId).jPlayer({
      preload: 'auto',
      swfPath: "/pub-swf",
      solution: "flash, html",
      backgroundColor: "#fff",
      cssSelectorAncestor: "#" + ids.playerId,
      cssSelector: {
        playBar: '',
        seekBar: ''
      },
      error: handlePlayerError,
      progress: updateInterface,
      timeupdate: updateInterface,
      durationchange: updateInterface,
      ended: updateInterface,
      wmode:'window', // for flash on FF3.6
      ready: onReady
    });

    // Create the load progress bar
    $('#' + ids.loadBarId).progressbar();

    // Create the play slider and progress bar
    $('#' + ids.playBarId).slider({
      max: 100,
      range: 'min',
      animate: true,
      slide: function(ev, ui) {
        // Fix bug 25468 -ecurtis 4/5/11
        // The playHead function takes percentOfSeekable, while the number we have is
        // the percent of total. So, scale the value so we seek to the correct position.
        var value = (ui.value / jp.data("jPlayer").status.seekPercent * 100);
        jp.jPlayer("playHead", value);
      }
    });

    return jp;
  };

  var createUniqueID = (function() {
    var counter = 0;

    return function(prefix) {
      prefix = (typeof prefix === 'string') ? prefix : "_";
      counter += 1;
      return prefix + counter;
    };

  }());

  var insertPlayerHTML = function() {

    var uniqueId = createUniqueID(),
        audioId = "qbmp3_embed_audio" + uniqueId,
        playerId = "qbmp3_embed_player" + uniqueId,
        playBarId = "jplayer_slider" + uniqueId,
        loadBarId = "jplayer_load_bar" + uniqueId;

    var playerHTML =
      '<div id="' + audioId + '"></div>' +
      '<div id="' + playerId + '" class="jp-single-player">' +
        '<div class="jp-interface">' +
          '<ul class="jp-controls">' +
            '<li><a href="#" class="jp-play" tabindex="1"><span>play</span></a></li>' +
            '<li><a href="#" class="jp-pause" tabindex="1"><span>pause</span></a></li>' +
            '<li><a href="#" class="jp-stop" tabindex="1"><span>stop</span></a></li>' +
          '</ul>' +
          '<div class="jp-bars">' +
            '<div id="' + playBarId + '" class="jp-slider-bar"></div>' +
            '<div id="' + loadBarId + '" class="jp-load-bar"></div>' +
          '</div>' +
        '</div>' +
      '</div>';

    $(playerHTML).appendTo('body');

    return {
      audioId: audioId,
      playerId: playerId,
      playBarId: playBarId,
      loadBarId: loadBarId
    };
    
  };

  /**
   * openAudioWindow
   *
   * Opening a new window for audio file links.
   * jPlayer will be utilized for MP3 file links.
   * Non-mp3 file links will fallback to browser plugins.
   *
   * See quia.activities.common.ListenAudioPage for more details.
   */
  var openAudioWindow = (function() {

    var winName = 'view_file',
        winOpts = 'width=250,height=130,resizable,screenX=200,screenY=0,left=200,top=0,scollbar=no,alwaysraised',
        stripFiles = /(\S*)files\/(\S*)$/;

    return function(url) {
      // RE: usePlugin=true
      // In the past, MediaPlayer will open a pop-up that only use plugin.
      // Now, the same pop-up will load this script and try to use jPlayer first.
      // If we already know that is NOT what we want we need to be explicit about it.
      var cleanUrl = stripFiles.exec(url),
          popUpUrl = "/servlets/quia.activities.common.MediaPlayer?listenAudio=" + cleanUrl[2] + "&isAudio=true" + (requiresNonEmbed(useEmbedPlayer) ? "&" + usePluginUri : ""),
          viewFile = window.open(popUpUrl, winName, winOpts);

      viewFile.focus();
    };

  }());

  var openEmbedAudio = (function() {
    var player,
        playerUI;

    var mimicPositionFixed = function(elId, topOffset) {
      var positionOnScroll = function() {
        $('#' + elId).css("top", ($(window).scrollTop() + topOffset) + "px");
      };
      $(window).scroll(positionOnScroll);
      positionOnScroll();
    };

    var positionPlayer = function(playerId) {

      var offset,
          scrollOffset;

      // If we're on a grading page, put it in the top left corner.
      if ($("#drawGradingTabsTbl").length === 1) {
        offset = {
          left: 0,
          top: 0
        };
      }

      // Try the #ContentArea (this is the most common id for the book content).
      if (!offset) {
        offset = $("#ContentArea").offset();
      }

      // Try the #bookcontent (this is another common id for the book content).
      if (!offset) {
        offset = $("#bookcontent").offset();
        if (offset) {
          offset.left += parseFloat($("#bookcontent").css("margin-left"));
        }
      }

      //
      // Position based on the accent bar
      //

      // Position the player directly underneath an accent bar that has buttons
      if (!offset) {
        $("#accentbar:has(button)").each(function() {
          var ab = $(this);
          if (ab.css('position') === 'fixed') {
            offset = {
              left: parseInt(ab.css('left'), 10),
              top: parseInt(ab.css('top'), 10)
            };
          }
          else {
            offset = ab.offset();
          }
          scrollOffset = ab.outerHeight();
          offset.top += scrollOffset;
        });
      }

      // Position the player to the right of the "i" on accent bars that don't have buttons
      if (!offset) {
        $("#accentbar").each(function() {
          var ab = $(this);
          offset = ab.offset();
          offset.left += ab.outerWidth();
        });
      }

      // Try #yui-main (this is the common id for the book content in integrated books)
      if (!offset) {
        $("#yui-main").each(function() {
          offset = $(this).offset();
          offset.left += parseFloat($(this).css("padding-left"));
        });
      }

      // If all else fails, position the player on the top left of the page
      if (!offset) {
        offset = {
          left: 0,
          top: 0
        }
      }

      // Position the player using position fixed or absolute.
      $('#' + playerId).css({
        left: offset.left + 'px',
        position: ($.support.boxModel ? 'fixed' : 'absolute'),
        top: offset.top + 'px',
        zIndex: 100
      });

      scrollOffset = scrollOffset || offset.top;

      // If position: fixed is not supported, mimic it using position absolute
      if (!$.support.boxModel) {
        mimicPositionFixed(playerId, scrollOffset);
      }

    };

    return function(url) {

      var loadAndPlay = function(p) {
        p.jPlayer("setMedia", {mp3: url});
        p.jPlayer("play");
      };

      if (!player) {
        player = createPlayer(function() {
          loadAndPlay($(this));

          var selector = $(this).jPlayer("option", "cssSelectorAncestor") + " " +
                         $(this).jPlayer("option", "cssSelector.stop");

          $(selector).bind("click", function() {
            playerUI.hide();
          });

        }, positionPlayer);

        playerUI = $(player.jPlayer("option", "cssSelectorAncestor"));

        if (requiresNonEmbed(player)) {
          useEmbedPlayer = false;
          playerUI.hide();
        }
      }
      else if (useEmbedPlayer) {
        playerUI.show();
        loadAndPlay(player);
      }
    };

  }());

  var getHost = function(domain) {
    var split = domain.split(":");
    return (split.length > 0 ? split[0] : domain);
  };

  /**
   * handleAudioLink
   *
   * Invoked when an event takes place on a link.
   * If the link is for an audio file (mp3, wav, au, mid, m4a), do something special:
   *  1. mp3 - use embed player (jPlayer for now)
   *  2. au - open new window with "openAudioWindow", which will utilize browser plugin
   *  3. wav - open new window with "openAudioWindow", which will utilize browser plugin
   *  4. mid - open new window with "openAudioWindow", which will utilize browser plugin
   *  5. m4a - open new window with "openAudioWindow", which will utilize browser plugin
   */
  var handleAudioLink = function(ev) {
    var link = this;
    if (!link || getHost(document.domain) !== getHost(link.hostname)) {
      return true;
    }

    var nameParts = link.pathname.split(".");
    if (nameParts.length > 0) {
      switch (nameParts[nameParts.length-1].toLowerCase()) {
        case "wav":
        case "au":
        case "m4a":
        case "mid":
          ev.preventDefault();
          openAudioWindow(link.pathname);
          return false;
        case "mp3":
          ev.preventDefault();
          if (useEmbedPlayer) {
            openEmbedAudio(link.href);
          }

          // The call to openEmbedAudio could set useEmbedPlayer to false, so do the test again.
          if (!useEmbedPlayer) {
            openAudioWindow(link.pathname);
          }
          return false;
      }
    }

    return true;
  };

  /**
   * initJPlayerOnlyMp3
   *
   * A wrapper function, going through a collection of audio files,
   * invoke "createQB_MP3_LG" only for mp3 file links.
   *
   * jPlayer really only works for MP3 files now.
   *
   * bug 30671 - update QW Audio Player
   *
   */
  var initJPlayerOnlyMp3 = function() {
    var el = this;
    var nameParts = el.pathname.split(".");
    if (nameParts.length > 0) {
      if (nameParts[nameParts.length-1].toLowerCase() === 'mp3') {
        createQB_MP3_LG.apply(this, []);
      }
    }
  };

  /**
   * init jPlayer for links with class name of "qb_mp3_lg"
   */
  var createQB_MP3_LG = function() {

    var el = this,
        url = el.href,
        nonEmbedUrl = el.pathname,
        onReady;

    var onReadyWithAutoStart = function(){
      $(this).jPlayer("setMedia", {mp3: url}).jPlayer("play");
    };
    var onReadyWithoutAutoStart = function(){
      $(this).jPlayer("setMedia", {mp3: url});
    };

    if ($(el).hasClass('auto_start')) {
      onReady = onReadyWithAutoStart;
    }
    else {
      onReady = onReadyWithoutAutoStart;
    }

    var positionPlayer = function(playerId) {
      $(el).replaceWith($('#' + playerId));
    };

    var player = createPlayer(onReady, positionPlayer);

    if (requiresNonEmbed(player)) {
      player.css("visibility", "hidden");

      var selector = player.jPlayer("option", "cssSelectorAncestor") + " " +
                     player.jPlayer("option", "cssSelector.play");

      $(selector).bind("click", function() {
        openAudioWindow(nonEmbedUrl);
      });
    }
  };

  var createQB_MP3_SM = (function() {

    var createSmallPlayer = function(onReady) {
      var uniqueId = createUniqueID(),
          audioId = "qb_mp3_audio_small" + uniqueId;

      $('<div id="' + audioId + '"></div>').appendTo('body');

      return $('#' + audioId).jPlayer({
        preload: 'auto',
        swfPath: "/pub-swf",
        solution: "flash, html",
        backgroundColor: "#fff",
        cssSelector: {
          play: '',
          pause: ''
        },
        error: handlePlayerError,
        ready: onReady
      });
    };

    var curEl,
        player;

    return function() {

      if (!player) {
        player = createSmallPlayer(function() {
          $(this).data("jPlayer")._updateButtons = function(playing) {
            this.status.paused = !playing;
            $(curEl).children('img').toggleClass("jp-playing", playing);
          };
        });
      }

      if (requiresNonEmbed(player)) {
        player.css("visibility", "hidden");
      }

      var el = this;

      $(el).removeClass("qb_mp3_sm");
      $(el).addClass("jp-player-sm");

      $(el).click(function() {
        if (requiresNonEmbed(player)) {
          openAudioWindow(el.pathname);
        }
        else if (el === curEl) {
          if ($(player).data("jPlayer").status.paused) {
            player.jPlayer("play");
          }
          else {
            player.jPlayer("stop");
          }
        }
        else {
          player.jPlayer("stop");
          setTimeout(function() {
            curEl = el;
            player.jPlayer("setMedia", {mp3: el.href});
            player.jPlayer("play");
          }, 0);
        }
        
        return false;
      });

    };


  }());

  /**
   * Initializes audio, only looking for elements that are children of el.
   */
  var initAudio = function(el) {
    /**
     * bug 30671 - update QW Audio Player
     *
     * All Share-It files with "au", "mid", "mp3" and "wav" file extensions
     * are now considered to be audio files.  CSS classname of "si_audio"
     * is added to the "a" tag.
     *
     * Wrapper function, initJPlayerOnlyMp3, will only invoke jPlayer for mp3 file links.
     * Non-mp3 file links will be handled by "openAudioWindow" via "allLinks".
     *
     */
    $("a.si_audio", el).each(initJPlayerOnlyMp3);

    /**
     * bug 30671 - update QW Audio Player
     *
     * "a.dp_mp3_sm" instances can no longer be found in
     * "/code/lib/quia", "/code/java", "/code/jsps" nor "/static" folders.
     * They only appear in this script, "handleMedia.js" (/static folder).
     * Maybe it is obsolete?
     *
     * "a.qb_mp3_lg" is only used via quia.activities.common.ListenAudioPage.
     *
     * To auto start playing the audio, insert CSS classname of "auto_start" right after
     * "qb_mp3_lg" or "qb_mp3_sm".
     *
     */
    var qb_mp3_lg = $("a.qb_mp3_lg", el),
        qb_mp3_sm = $("a.qb_mp3_sm", el);

    qb_mp3_lg.each(createQB_MP3_LG);
    qb_mp3_sm.each(createQB_MP3_SM);

    /**   
     * bug 30671 - update QW Audio Player
     *
     * Array "allLinks" collects nearly all <a> tags on the DOM indiscriminately.
     * This is for Quia Books where many audio links are not identified with special selectors.
     *
     * It is not necessary to exclude "a.si_audio", "a.qb_mp3_lg" or "a.qb_mp3_sm" from "allLinks",
     * because function "handleAudioLink" will not interfere with jPlayer,
     * because corresponding file link will be taken out of the DOM when jPlayer is invoked.
     *
     * Sometimes, we don't want a link handled by "handleAudioLink".
     * This can be achieved by adding  CSS classname of "excludeHandleMediaAllLk" to the "a" tag.
     *
     */
    var allLinks = $("a", el).add("area").not("a.excludeHandleMediaAllLk");

    allLinks.not(qb_mp3_lg).not(qb_mp3_sm).click(handleAudioLink);
    
  }

  /**
   * When DOM tree is ready, do following.
   */
  $(document).ready(function() {
    initAudio(document);
  });

  $(document).bind('processAudioStartWithElId', function(ev, elId) {
    var elem = $("#" + elId).get();
    if (elem) {
      initAudio(elem);
    }
  });

})(jQuery);

/************************************************************************************************
 * Video embed (qbv)
 ************************************************************************************************/
(function($) {

  // JS source file for the Brightcove video player.
  var brightcoveJS = "http://admin.brightcove.com/js/BrightcoveExperiences.js";

  // Default parameters
  var defaultParams = {
    //playerID: "712621967001",
    //playerKey: "AQ~~,AAAAksURK3E~,0ogDd7g5L7EPunnQ_64QoUTCRWrIUjKC",
    //playerID: "1159955438001",
    //playerKey: "AQ~~,AAAAksURK3E~,0ogDd7g5L7HAonWcP5hqel94IAvQKstc",
 
    playerID: "2534698324001", //"2127322297001", 
    playerKey: "AQ~~,AAAAksURK3E~,0ogDd7g5L7EvMQ9IaH9Agmk4yQt5j8yy",  // "AQ~~,AAAAksURK3E~,0ogDd7g5L7HEF6-ELt95I-ttR3-jh5dj",

    bgcolor: "#FFFFFF",
    height: 412,
    width: 486,
    wmode: "transparent",

    dynamicStreaming: true,
    isUI: true,
    isVid: true
  };

  //var isIOS = /(iPad|iPhone|iPod)/.test(navigator.userAgent);

  // Function to embed the video within the given element
  var embedVideo = function() {

    var el = $(this),
        videoId = el.attr("id").substring(4),     // the "qbv_" prefix of the id is 4 chars
        options = {};

    // Grab the data options from the element.
    $.each(defaultParams, function(key, value) {
      var dataValue = el.attr("data-" + key);
      options[key] = (dataValue === undefined) ? value : dataValue;
    });
    
    // Sept 2013 - removing special case for iOS as defaulting to a new player that
    // works on iOS
    // If the user is on an iOS device, override the player settings and
    // use the iOS player which is enabled for HTML5
    //if (isIOS) {
      //options.playerId = "694908268001";
      //options.playerKey = "AQ~~,AAAAksURK3E~,0ogDd7g5L7GGAwfdBoS1K8xBkMlee1Ot";
    //}

    // Create the HTML for the embed
    var embedHTML = '<object id="myExperience' + videoId + '" class="BrightcoveExperience">'
                  + '<param name="@videoPlayer" value="' + videoId + '"/>';

    // Add the parameters to the embed HTML
    $.each(options, function(name, value) {
      embedHTML += '<param name="' + name + '" value="' + value + '" />';
    });

    embedHTML += '</object>';

    // Set the innerHTML of the element
    el.html(embedHTML);

    brightcove.createExperiences();
  };
  
  // Function which scans the document for elements with the className qbv and tries
  // to embed video for each of them.
  var processEmbeddedVideo = function() {
    // Find all the videos to embed.
    var videos = $(".qbv");

    // If there are videos, download the Brightcove JS and embed each video
    if (videos.is("*")) {
      $.getScript(brightcoveJS, function(){
        videos.each(embedVideo);
      });
    }

    // use delegate since for study plans, etc, content may be set thru javascript
    // and thus not be on the page by the time processEmbeddedVideo is called/run.
    // NOTE: Cannot use href^= because this does not work in IE.
    $(document).delegate("a[href*='/actions/books/video']", "click", function(event) {
      event.preventDefault();

      // use currentTarget not target since with target if has say part italics, then
      // if click on that part would not work. fix for 31230
      window.open(event.currentTarget.href, "_blank", "height=430,width=520");
      return false;
    });
  };
 
    
  // Fix to bug 26227 mweiss 2/10/2011 - Add a listener to a global rendering event
  // so we can process embedded video with qbv elements created after the page is initially made.
  $(document).bind('processEmbeddedVideo', processEmbeddedVideo);
  $(document).ready(processEmbeddedVideo);

})(jQuery);


