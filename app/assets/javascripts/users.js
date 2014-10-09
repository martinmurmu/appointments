# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready(function() {

  var totalCount = 9;

    var num =  Math.ceil( Math.random() * totalCount );
    $("#wrapper").background = 'waitlist-join-iphone'+num+'.jpg'; 
});