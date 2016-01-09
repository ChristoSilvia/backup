var analyticsurl = 'http://analytics.tv5network.com/log.aspx'

var appcodename = encodeURIComponent(navigator.appCodeName);
var appname = encodeURIComponent(navigator.appName);
var appversion = encodeURIComponent(navigator.appVersion);
var cookieenabled = encodeURIComponent(navigator.cookieEnabled);
var language = encodeURIComponent(navigator.language);
var online = encodeURIComponent(navigator.onLine);
var platform = encodeURIComponent(navigator.platform);
var product = encodeURIComponent(navigator.product);
var useragent = encodeURIComponent(navigator.userAgent);

function logUserActionVideo(nexted, action, videotype, item, guid, ip, itemid, userid, fallback)
{
    if (!nexted)
        $.post(analyticsurl + '?action=' + action + '&type=' + videotype + '&item=' + item + '&guid=' + guid + '&ipaddress=' + ip + '&itemid=' + itemid + '&userid=' + userid + '&appcodename=' + appcodename + '&appname=' + appname + '&appversion=' + appversion + '&cookieenabled=' + cookieenabled + '&language=' + language + '&online=' + online + '&platform=' + platform + '&product=' + product + '&useragent=' + useragent + '&sectionid=2');
    else
        $.post(analyticsurl + '?action=' + action + '&type=' + fallback.split('|')[4] + '&item=' + item + '&guid=' + fallback.split('|')[1] + '&ipaddress=' + ip + '&itemid=' + fallback.split('|')[0] + '&userid=' + userid + '&appcodename=' + appcodename + '&appname=' + appname + '&appversion=' + appversion + '&cookieenabled=' + cookieenabled + '&language=' + language + '&online=' + online + '&platform=' + platform + '&product=' + product + '&useragent=' + useragent + '&sectionid=2');

}

function logUserActionAd(action, adtype, item, guid, ip, itemid, userid)
{
    $.post(analyticsurl + '?action=' + action + '&type=' + adtype + '&item=' + item + '&guid=' + guid + '&ipaddress=' + ip + '&itemid=' + itemid + '&userid=' + userid + '&appcodename=' + appcodename + '&appname=' + appname + '&appversion=' + appversion + '&cookieenabled=' + cookieenabled + '&language=' + language + '&online=' + online + '&platform=' + platform + '&product=' + product + '&useragent=' + useragent + '&sectionid=2');
}

function logUserActionShare(action, contenttype, item, guid, ip, itemid, userid)
{
    $.post(analyticsurl + '?action=' + action + '&type=' + contenttype + '&item=' + item + '&guid=' + guid + '&ipaddress=' + ip + '&itemid=' + itemid + '&userid=' + userid + '&appcodename=' + appcodename + '&appname=' + appname + '&appversion=' + appversion + '&cookieenabled=' + cookieenabled + '&language=' + language + '&online=' + online + '&platform=' + platform + '&product=' + product + '&useragent=' + useragent + '&sectionid=2');
}

$(window).resize(function () {
    //resize just happened, pixels changed
    try { $("#more").css('left', ($("#module-video-most-recent").width() / 2 + ($("#module-video-most-recent").width() * .02))); } catch (exception) { }
    try { $(".mobile-stats-content-previous-game-main-wrap").css('width', $(window).width + 'px') } catch (Exception) { }

    if ($(window).width() > 980) {
        try { document.getElementById("special_img").style.height = '466px'; } catch (exception) { }
        try {
            $(".mobile-tab-content-arrow-right").hide();
            $(".mobile-tab-content-arrow-left").hide();
            $(".main-tab-content-arrow-right").show();
            $(".main-tab-content-arrow-left").show();
            try { $(".module-search-result-item-text .module-search-result-item-text-title a").css('white-space', 'nowrap') } catch (Exception) { }
            try { $(".module-search-result-item-text .module-search-result-item-text-content").css('white-space', 'nowrap') } catch (Exception) { }
            //try { $(".module-search-result-item-text").css('width', '725px') } catch (Exception) { }
        } catch (exception) { }
        try {
            $(".module-play-of-the-day-content-video").style.width = '640px';
            $(".module-play-of-the-day-content-video").style.height = '409px';
        } catch (exception) { }

    } else {
        try { document.getElementById("special_img").style.removeProperty('height'); } catch (exception) { }
        try {
            $(".mobile-tab-content-arrow-right").show();
            $(".mobile-tab-content-arrow-left").show();
            $(".main-tab-content-arrow-right").hide();
            $(".main-tab-content-arrow-left").hide();
            $(".main-tab-content-filter-list-wrap").css('margin', '5px 0 0 35px');
        } catch (exception) { }
        try { $(".module-search-result-item-text .module-search-result-item-text-title a").css('white-space', 'normal') } catch (Exception) { }
        try { $(".module-search-result-item-text .module-search-result-item-text-content").css('white-space', 'normal') } catch (Exception) { }
        //try { $(".module-search-result-item-text").css('width', '100%') } catch (Exception) { }
        try {
            var embedwidth = $(".module-play-of-the-day-content-video").width();
            var embedheight = embedwidth * 0.64;

            $(".module-play-of-the-day-content-video").css('height', embedheight + 'px');
        } catch (exception) { }
    }
});

try { $("#more").css('left', ($("#module-video-most-recent").width() / 2 + ($("#module-video-most-recent").width() * .02))); } catch (exception) { }

if ($(window).width() > 980) {
    try { document.getElementById("special_img").style.height = '466px'; } catch (exception) { }
    try {
        $(".mobile-tab-content-arrow-right").hide();
        $(".mobile-tab-content-arrow-left").hide();
        $(".main-tab-content-arrow-right").show();
        $(".main-tab-content-arrow-left").show();
    } catch (exception) { }
    try {
        document.getElementById(".module-play-of-the-day-content-video").style.width = '640px';
        document.getElementById(".module-play-of-the-day-content-video").style.height = '409px';
    } catch (exception) { }
} else {
    try { document.getElementById("special_img").style.removeProperty('height'); } catch (exception) { }
    try {
        $(".mobile-tab-content-arrow-right").show();
        $(".mobile-tab-content-arrow-left").show();
        $(".main-tab-content-arrow-right").hide();
        $(".main-tab-content-arrow-left").hide();
        $(".main-tab-content-filter-list-wrap").css('margin', '5px 0 0 35px');
    } catch (exception) { }
    try { $(".module-search-result-item-text .module-search-result-item-text-title a").css('white-space', 'normal') } catch (Exception) { }
    try { $(".module-search-result-item-text .module-search-result-item-text-content").css('white-space', 'normal') } catch (Exception) { }
    //try { $(".module-search-result-item-text").css('width', '100%') } catch (Exception) { }
    try
    {
        var embedwidth = $(".module-play-of-the-day-content-video").width();
        var embedheight = embedwidth * 0.64;

        $(".module-play-of-the-day-content-video").css('height', embedheight + 'px');
    } catch (exception) { }
}
