var TT = function() {
  var timerInterval = null,
      originalTitle,
      status = 'idle',
      settings = {
        timerEndSoundId: 'ringing',
        timerSquashSoundId: 'squash',
        startButtonId: 'start',
        squashButtonId: 'squash',
        formId: 'new_tomato_form',
        timerId: 'timer',
        flashId: 'flash'
      };
  
  var init = function(options) {
    $.extend(settings, options);
  }
  
  var mapElements = function(ids, f) {
    ids.forEach(function(id) {
      $("#"+id)[f]();
    });
  }

  var show = function(ids) {
    mapElements(ids, 'show');
  }

  var hide = function(ids) {
    mapElements(ids, 'hide');
  }

  var pad = function(number, length) {
    var str = '' + number;
    while (str.length < length) {
      str = '0' + str;
    }
    return str;
  }

  var secondsToString = function(seconds) {
    minutes = Math.floor(seconds/60);
    seconds = seconds - minutes*60;
    return pad(minutes, 2) + ":" + pad(seconds, 2);
  }

  var stateStart = function(timer) {
    log("stateStart");
    
    status = 'running';
    $("#" + settings.timerId).html(secondsToString(timer));
    originalTitle = document.title;

    hide([settings.startButtonId, settings.formId]);
    show([settings.timerId, settings.squashButtonId]);
  }

  var stateCounting = function(timer) {
    log("stateCounting");

    var timerString = secondsToString(timer);
    $("#" + settings.timerId).html(timerString);
    document.title = timerString + " - " + originalTitle;
  }

  var stateStop = function() {
    log("stateStop");

    status = 'idle';
    document.title = originalTitle;
    $("#" + settings.flashId).html("");
    
    hide([settings.timerId, settings.squashButtonId]);
    show([settings.startButtonId]);
  }

  var stateNewForm = function() {
    log("stateNewForm");

    status = 'saving';
    document.title = originalTitle;

    hide([settings.timerId, settings.squashButtonId, settings.startButtonId]);
    show([settings.formId]);
  }

  var start = function(mins, callback) {
    log("start timer for " + mins + " mins");

    var timer = Math.round(mins*60);
    stateStart(timer);

    timerInterval = setInterval(function() {
      timer--;
      stateCounting(timer);
      
      if(timer <= 0) {
        clearInterval(timerInterval);
        timerInterval = null;
        soundManager.play(settings.timerEndSoundId);
        callback();
      }
    }, 1000);
  }

  var squash = function() {
    log("squash tomato");

    if(confirm("Sure?")) {
      clearInterval(timerInterval);
      timerInterval = null;
      soundManager.play(settings.timerSquashSoundId);
      stateStop();
    }
  }

  var log = function(object) {
    if(DEBUG) {
      console.log(object);
    }
  }
  
  var getStatus = function() {
    return status;
  }
  
  return {
    start: start,
    squash: squash,
    stateNewForm: stateNewForm,
    stateStop: stateStop,
    log: log,
    getStatus: getStatus
  };
}();