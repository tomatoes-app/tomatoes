var TTReminder = function() {
  var reminderDelay = 20; // constant delay in seconds
  var reminderId;

  var delayReminder = function(message) {
    reminderId = setTimeout(function() {
      // reminder notification
      NOTIFIER.notify(tomatoNotificationIcon, 'Tomatoes', message, true);
    }, reminderDelay * 1000);
  };

  var cancelReminder = function() {
    clearTimeout(reminderId);
  };

  return {
    delayReminder: delayReminder,
    cancelReminder: cancelReminder
  };
}();

// initialize TTReminder
$(document).ready(function() {
  $(document).on('timer_start', TTReminder.cancelReminder);
  $(document).on('timer_stop', function() {
    TTReminder.delayReminder('Did you forget to start your next tomato?');
  });
  $(document).on('new_tomato_form', function() {
    TTReminder.delayReminder('Did you forget to save your current tomato?');
  });
});
