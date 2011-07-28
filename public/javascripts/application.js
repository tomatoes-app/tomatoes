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

var timerInterval = null;
var originalTitle;

function show(ids) {
  ids.forEach(function(id) {
    $("#"+id).show();
  });
}

function hide(ids) {
  ids.forEach(function(id) {
    $("#"+id).hide();
  });
}

function pad(number, length) {
    var str = '' + number;
    while (str.length < length) {
      str = '0' + str;
    }
    return str;
}

function secondsToString(seconds) {
  minutes = Math.floor(seconds/60);
  seconds = seconds - minutes*60;
  return pad(minutes, 2) + ":" + pad(seconds, 2);
}

function stateStart(timer) {
  console.log("stateStart");
  
  $("#timer").html(secondsToString(timer));
  originalTitle = document.title;
  
  show(["timer", "squash"]);
  hide(["start", "new_tomato_form"]);
}

function stateCounting(timer) {
  console.log("stateCounting");
  
  var timerString = secondsToString(timer);
  $("#timer").html(timerString);
  document.title = timerString + " - " + originalTitle;
}

function stateStop() {
  console.log("stateStop");
  
  document.title = originalTitle;
  
  $("#flash").html("");
  hide(["timer", "squash"]);
  show(["start"]);
}

function stateNewForm() {
  console.log("stateNewForm");
  
  document.title = originalTitle;
  
  hide(["timer", "squash", "start"]);
  show(["new_tomato_form"]);
}

function start(mins, callback) {
  console.log("start timer for " + mins + " mins");
  
  var timer = Math.round(mins*60);
  stateStart(timer);
  
  timerInterval = setInterval(function() {
    timer--;
    stateCounting(timer);
    if(timer <= 0) {
      clearInterval(timerInterval);
      timerInterval = null;
      soundManager.play('ringing');
      callback();
    }
  }, 1000);
}

function squash() {
  console.log("squash tomato");
  
  if(confirm("Sure?")) {
    clearInterval(timerInterval);
    timerInterval = null;
    soundManager.play('squash');
    stateStop();
  }
}

$(document).ready(function() {
  $("#start").click(function() {
    start(tomatoDuration, stateNewForm);
    return false;
  });
  
  $("#squash").click(function() {
    squash();
    return false;
  });
});

$(window).bind('beforeunload', function() {
  if(timerInterval != null) {
    return "You're running a pomodoro."
  }
});