//= require active_admin/base


$(document).ready(function() {

  var totalCount = 9;

    var num =  Math.ceil( Math.random() * totalCount );
    $("#wrapper").css('background-image', 'url(/assets/waitlist-join-iphone'+num+'.jpg)'); 
});