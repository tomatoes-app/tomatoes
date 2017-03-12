// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require notifier
//= require farbtastic

function permissionCallback(permission) {
  $("#request_notification_permission a").html(permissionLabel(permission));
}

function permissionLabel(permission) {
  switch (permission) {
    case 'granted':
      return 'Tomatoes is allowed to use desktop notifications';
    case 'denied':
      return 'Tomatoes is not allowed to use desktop notifications :(<br/>If you want to receive notifications remove www.tomato.es from the blacklist.';
    default:
      return 'Allow desktop notifications';
  }
}

$(document).ready(function() {
  if(NOTIFIER.isSupported()) {
    // setup request notification permission element
    permissionCallback(NOTIFIER.getPermission());

    $("#request_notification_permission a").click(function(event) {
      NOTIFIER.requestPermission(permissionCallback);
      event.preventDefault();
    });
  }
  else {
    $("#notification_not_supported").show();
  }

  if($('#colorpicker').length > 0) {
    $('#colorpicker').farbtastic('#user_color');
  }
});
