var wurl = 'http://services.tv5network.com/gateway/entertainment';

function getVideoUrl(guid) {

    var mydata = [];
    $.ajax({
        url: wurl + '/v.aspx?g=' + guid,
        async: false,
        dataType: 'json',
        success: function (data) {
            mydata = data.NewDataSet.Video.html5location;
        }
    });

    return mydata;
}

function getVideo(guid) {
    var mydata = [];
    $.ajax({
        url: wurl + '/v.aspx?g=' + guid,
        async: false,
        dataType: 'json',
        success: function (data) {
            mydata = data.NewDataSet.Video;
        }
    });

    return mydata;
}