var TT = function() {
  var timerInterval = null,
      originalTitle,
      status = 'idle',
      settings = {
        timerEndSoundId: 'ringing',
        timerSquashSoundId: 'squash',
        timerContainerId: 'timer_container',
        startButtonId: 'start',
        startHintId: 'start_hint',
        squashButtonId: 'squash',
        squashHintId: 'squash_hint',
        progressBarId: 'progress_bar',
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
    
    var timerContainerObj = $("#" + settings.timerContainerId);
    timerContainerObj.removeClass('round_left');
    timerContainerObj.addClass('round_right');

    hide([settings.startButtonId, settings.startHintId, settings.formId]);
    show([settings.timerId, settings.squashButtonId, settings.squashHintId]);
  }

  var stateCounting = function(timer, duration) {
    log("stateCounting");

    var timerString = secondsToString(timer);
    $("#" + settings.timerId).html(timerString);
    document.title = timerString + " - " + originalTitle;
    
    var factor = (duration-timer) / duration;
    log("factor: " + factor);
    
    var progressBarObj = $("#" + settings.progressBarId),
        timerContainerObj = $("#" + settings.timerContainerId);
    
    progressBarObj.css('width', factor*100 + '%');
    progressBarObj.css('backgroundColor', 'rgba(' + Math.round(factor*255) + ', ' + Math.round((1-factor)*255) + ', 0, .5)');
    if(progressBarObj.width() < 400) {
      timerContainerObj.css('right', '');
      timerContainerObj.css('left', progressBarObj.width());
    }
    else {
      if(!timerContainerObj.hasClass('round_left')) {
        timerContainerObj.removeClass('round_right');
        timerContainerObj.addClass('round_left');
        timerContainerObj.css('left', '');
        timerContainerObj.css('right', 0);
      }
    }
  }

  var stateStop = function() {
    log("stateStop");

    status = 'idle';
    document.title = originalTitle;
    $("#" + settings.flashId).html("");
    $("#" + settings.progressBarId).css('width', 0);
    
    hide([settings.timerId, settings.squashButtonId, settings.squashHintId]);
    show([settings.startButtonId, settings.startHintId]);
  }

  var stateNewForm = function() {
    log("stateNewForm");

    status = 'saving';
    document.title = originalTitle;
    $("#" + settings.formId + " input[type=text]").focus();

    hide([settings.timerId, settings.squashButtonId, settings.squashHintId, settings.startButtonId, settings.startHintId]);
    show([settings.formId]);
  }

  var start = function(mins, callback) {
    log("start timer for " + mins + " mins");

    var duration = Math.round(mins*60);
    var timer = duration;
    stateStart(timer);

    timerInterval = setInterval(function() {
      timer--;
      stateCounting(timer, duration);
      
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