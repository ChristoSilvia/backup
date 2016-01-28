// JavaScript Document 
$(document).ready(function() {
    if ($.browser.mozilla) {
         $('textarea\[rows]').each(function(i, el) {
             if (!$(el).data('ffRowsFixed')) {
                 var rows = parseInt($(el).attr('rows'));
                 if (rows > 1) $(el).attr('rows', (rows - 1));
                 $(el).data('ffRowsFixed', true);
             }
         });
    }
});