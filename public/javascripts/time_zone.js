$(document).ready(function() {
  if(!($.cookie('timezone')) || $.cookie('timezone') != new Date().getTimezoneOffset() ) {
    $.cookie('timezone', (new Date()).getTimezoneOffset());
  }
});
