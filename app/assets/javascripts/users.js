// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require notifier
//= require farbtastic

function permissionCallback(hasPermission) {
  var permissionLabel = hasPermission ? "Tomatoes is allowed to use desktop notifications" : "Allow desktop notifications";

  $("#request_notification_permission a").html(permissionLabel);
}

$(document).ready(function() {
  if(NOTIFIER.hasSupport()) {
    permissionCallback(NOTIFIER.hasPermission());
    
    $("#request_notification_permission a").click(function(event) {
      NOTIFIER.requestPermission(permissionCallback);
      event.preventDefault();
    });
  }
  else {
    $("#request_notification_permission").hide();
  }

  $('#colorpicker').farbtastic('#user_color');
});