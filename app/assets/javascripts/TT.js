// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require soundmanager2-nodebug-jsmin
//= require notifier
//= require TT_favicon
//= require TT_init

var TT = function() {
  var timerInterval = null,
      originalTitle,
      status = 'idle',
      volume = 50,
      settings = {
        timerTickingSoundId: 'tictac',
        timerEndSoundId: 'ringing',
        timerResetSoundId: 'reset',
        timerContainerId: 'timer_container',
        startButtonId: 'start',
        startHintId: 'start_hint',
        progressBarId: 'progress_bar',
        formId: 'new_tomato_form',
        timerId: 'timer',
        timerCounterId: 'timer_counter',
        flashId: 'flash'
      };
  
  var init = function(options) {
    $.extend(settings, options);
  }
  
  var mapElements = function() {
    var ids = Array.prototype.shift.call(arguments),
        f = Array.prototype.shift.call(arguments),
        args = arguments;
        
    ids.forEach(function(id) {
      $("#"+id)[f].apply($("#"+id), args);
    });
  }

  var show = function(ids) {
    mapElements(ids, 'show');
  }

  var hide = function(ids) {
    mapElements(ids, 'hide');
  }
  
  var disable = function(ids) {
    mapElements(ids, 'prop', 'disable', true);
  }
  
  var enable = function(ids) {
    mapElements(ids, 'prop', 'disable', false);
  }
  
  var blur = function(ids) {
    mapElements(ids, 'css', 'opacity', .3);
  }
  
  var unblur = function(ids) {
    mapElements(ids, 'css', 'opacity', 1);
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
    $(document).trigger('timer_start');
    
    status = 'running';
    $("#" + settings.timerCounterId).html(secondsToString(timer));
    originalTitle = document.title;
    
    var timerContainerObj = $("#" + settings.timerContainerId);
    timerContainerObj.removeClass('round_left');
    timerContainerObj.addClass('round_right');

    disable([settings.startButtonId])
    blur([settings.startButtonId, settings.startHintId])
    hide([settings.formId]);
    show([settings.timerId]);
  }

  var stateCounting = function(timer, duration) {
    log("stateCounting");
    $(document).trigger('timer_tick', [(duration-timer), duration]);

    var timerString = secondsToString(timer);
    $("#" + settings.timerCounterId).html(timerString);
    document.title = timerString + " - " + originalTitle;
    
    var factor = (duration-timer) / duration;
    log("factor: " + factor);

    var progressBarObj = $("#" + settings.progressBarId),
        timerContainerObj = $("#" + settings.timerContainerId);
    
    progressBarObj.css('width', factor*100 + '%');
    if(progressBarObj.width() < 400+40) {
      timerContainerObj.css('left', progressBarObj.width());
    }
    else {
      if(!timerContainerObj.hasClass('round_left')) {
        timerContainerObj.removeClass('round_right');
        timerContainerObj.addClass('round_left');
      }
      timerContainerObj.css('left', progressBarObj.width() - (400+40+1));
    }
  }

  var stateStop = function(reset) {
    log("stateStop");
    $(document).trigger('timer_stop');

    status = 'idle';
    document.title = originalTitle;
    $("#" + settings.flashId).html("");
    $("#" + settings.progressBarId).css('width', 0);
    $("#" + settings.timerContainerId).css('right', 0);
    $("#" + settings.timerContainerId).css('left', '');
    
    if(typeof reset == 'undefined') {
      if (!NOTIFIER.notify(tomatoNotificationIcon, "Tomatoes", "Break is over. It's time to work.")) {
        log('Permission denied. Click "Request Permission" to give this domain access to send notifications to your desktop.');
      }
    }
    
    hide([settings.timerId]);
    enable([settings.startButtonId])
    unblur([settings.startButtonId, settings.startHintId])
  }

  var stateNewForm = function() {
    log("stateNewForm");

    status = 'saving';
    document.title = originalTitle;
    $("#" + settings.formId + " input[type=text]").focus();
    
    // notify tomato end
    if (!NOTIFIER.notify(tomatoNotificationIcon, "Tomatoes", "Pomodoro finished!")) {
      log('Permission denied. Click "Request Permission" to give this domain access to send notifications to your desktop.');
    }

    hide([settings.timerId]);
    show([settings.formId]);
  }

  var stateSignIn = function() {
    log("stateSignIn");

    status = 'signin';
    document.title = originalTitle;
    
    // notify tomato end
    if (!NOTIFIER.notify(tomatoNotificationIcon, "Tomatoes", "Pomodoro finished!")) {
      log('Permission denied. Click "Request Permission" to give this domain access to send notifications to your desktop.');
    }

    hide([settings.timerId]);
    show([settings.formId]);
  }

  var start = function(mins, callback) {
    log("start timer for " + mins + " mins");

    var duration = Math.round(mins*60);
    var startDate = new Date();
    var timer = duration;
    stateStart(timer);

    (function tick() {
      var msPassed = new Date() - startDate;
      timer = Math.round(duration - msPassed/1000);

      stateCounting(timer, duration);
      
      if(timer <= 0) {
        callback();
        soundManager.setVolume(settings.timerEndSoundId, volume).play();
      }
      else {
        timerInterval = setTimeout(tick, 1000);
        if($('#ticking_sound_switch').is(':checked')) {
          soundManager.setVolume(settings.timerTickingSoundId, volume).play();
        }
      }
    })();
  }

  var reset = function() {
    log("reset tomato");

    if(confirm("Sure?")) {
      clearInterval(timerInterval);
      stateStop(true);
      soundManager.setVolume(settings.timerResetSoundId, volume).play();
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

  var getVolume = function() {
    return volume;
  }

  var setVolume = function(newVolume) {
    volume = Math.max(Math.min(newVolume, 100), 0);
  }
  
  return {
    start: start,
    reset: reset,
    stateNewForm: stateNewForm,
    stateSignIn: stateSignIn,
    stateStop: stateStop,
    log: log,
    getStatus: getStatus,
    getVolume: getVolume,
    setVolume: setVolume
  };
}();
