// sound manager setup
soundManager.url = '/sm/swf/';
soundManager.flashVersion = 9; // optional: shiny features (default = 8)
soundManager.useFlashBlock = false; // optionally, enable when you're ready to dive in
soundManager.useHTML5Audio = true;

// sound manager initializing sounds
soundManager.onready(function() {
  if (soundManager.supported()) {
    // SM2 is ready to go!
    ['ringing', 'reset', 'tictac'].forEach(function(sound) {
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
    TT.start(tomatoDuration, currentUser ? TT.stateNewForm : TT.stateSignIn);
    event.preventDefault();
  }
}

function resetCallback(event) {
  if('running' == TT.getStatus()) {
    TT.reset();
    event.preventDefault();
  }
}

function resetSigninCallback(event) {
  $("#progress_bar").css('width', 0);
  $("#new_tomato_form").unbind("keypress");
  TT.start(tomatoBreakDuration, TT.stateStop);
}

function updateVolumeIcon() {
  var level = Math.floor(TT.getVolume()/25);
  level = Math.min(level, 3);
  level = Math.max(level, 0);
  $("#volume_icon").removeClass().addClass("mute_toggle left level_" + level);
}

$(document).ready(function() {
  TTFavicon.init();
  $("#start").click(startCallback);
  $("#reset").click(resetCallback);
  $("#reset_signin").click(resetSigninCallback);
  
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
    event.which == 27 && resetCallback(event);
  });
  
  if((typeof window.chrome == 'undefined') || (window.chrome && window.chrome.app && window.chrome.app.isInstalled)) {
    $("#add_to_chrome").hide();
  }

  $(".volume .up").click(function() {
    TT.setVolume(TT.getVolume() + 25);
    updateVolumeIcon();
  });
  $(".volume .down").click(function() {
    TT.setVolume(TT.getVolume() - 25);
    updateVolumeIcon();
  });
  $(".volume .mute_toggle").click(function() {
    TT.setVolume(0 == TT.getVolume() ? 50 : 0);
    updateVolumeIcon();
  });

  updateVolumeIcon();
});

$(window).bind('beforeunload', function() {
  if('running' == TT.getStatus()) {
    return "Timer is running."
  }
  if('saving' == TT.getStatus()) {
    return "You're about to save a pomodoro."
  }
});
