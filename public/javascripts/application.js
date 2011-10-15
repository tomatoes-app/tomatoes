// sound manager setup
soundManager.url = '/javascripts/sm/swf/';
soundManager.flashVersion = 9; // optional: shiny features (default = 8)
soundManager.useFlashBlock = false; // optionally, enable when you're ready to dive in
soundManager.useHTML5Audio = true;

// sound manager initializing sounds
soundManager.onready(function() {
  if (soundManager.supported()) {
    // SM2 is ready to go!
    ['ringing', 'squash'].forEach(function(sound) {
      soundManager.createSound({
        id: sound,
        url: '/sounds/' + sound + '.mp3',
        autoLoad: true,
        autoPlay: false,
        volume: 50
      });
    });
  } else {
    // unsupported/error case
  }
});

function startCallback(event) {
  if('idle' == TT.getStatus()) {
    TT.start(tomatoDuration, TT.stateNewForm);
    event.preventDefault();
  }
}

function squashCallback(event) {
  if('running' == TT.getStatus()) {
    TT.squash();
    event.preventDefault();
  }
}

function permissionCallback() {
  var requestObject = $("#request_notification_permission a");
  
  if(NOTIFIER.HasPermission()) {
    requestObject.html("Tomatoes is allowed to use desktop notifications");
  }
  else {
    requestObject.html("Allow desktop notifications");
  }
}

$(document).ready(function() {
  $("#start").click(startCallback);
  $("#squash").click(squashCallback);
  
  $("#new_tomato_form").live("ajax:beforeSend", function() {
    TT.log("ajax:beforeSend");
    
    $(this).keypress(function(event) {
      TT.log("keypress event");
      
      // ENTER key
      event.which == 13 && event.preventDefault();
    });
  });
  
  $(document).keydown(function(event) {
    TT.log("keydown: " + event.which);
    
    // SPACE key
    event.which == 32 && startCallback(event);
    // ESC key
    event.which == 27 && squashCallback(event);
  });
  
  if((typeof window.chrome == 'undefined') || (window.chrome && window.chrome.app && window.chrome.app.isInstalled)) {
    $("#add_to_chrome").hide();
  }
  
  if(NOTIFIER.HasSupport()) {
    permissionCallback();
    
    $("#request_notification_permission a").click(function(event) {
      NOTIFIER.RequestPermission(permissionCallback());
      event.preventDefault();
    });
  }
  else {
    $("#request_notification_permission").hide();
  }
});

$(window).bind('beforeunload', function() {
  if('running' == TT.getStatus()) {
    return "Timer is running."
  }
  if('saving' == TT.getStatus()) {
    return "You're about to save a pomodoro."
  }
});