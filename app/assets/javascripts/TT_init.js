soundManager.setup({
  // where to find flash audio SWFs, as needed
  url: 'https://cdnjs.cloudflare.com/ajax/libs/soundmanager2/2.97a.20150601/swf/',
  debugMode: DEBUG,
  debugFlash: DEBUG,
  flashVersion: 9,
  useFlashBlock: false, // allow recovery from flash blockers
  useHTML5Audio: true, // use HTML5 Audio() where supported
  onready: function() { // sound manager initialization
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
      console.error('Sound not supported');
    }
  },
  ontimeout: function() {
    console.error('Sound initialization failed');
  }
});

function startCallback(event) {
  if('idle' == TT.getStatus()) {
    chosenDuration = document.getElementById("duration_time_input").value;
    tomatoDuration = parseInt(chosenDuration);
    if(DEBUG) tomatoDuration /= 60;
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
  TT.resetProgressBar();
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
  $("#start").click(startCallback);
  $("#reset").click(resetCallback);
  $("#reset_signin").click(resetSigninCallback);

  $("#new_tomato_form").on("ajax:beforeSend", function() {
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

  // ask for desktop notifications permission
  if(NOTIFIER.isSupported() && !NOTIFIER.isPermissionGranted()) {
    NOTIFIER.requestPermission();
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
