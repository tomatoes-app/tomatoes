var TTReminder = function() {
  var reminderId,         // reminder timeout callback id
      maxBackoffExp = 4,  // max exponential backoff
      constantDelay = 10, // constant delay in seconds
      baseDelay = 6;      // base delay in seconds

  var delayReminderExp = function (exp, message) {
    reminderId = setTimeout(function() {
      // reminder notification
      if (!NOTIFIER.notify(tomatoNotificationIcon, "Tomatoes", message)) {
        log('Permission denied. Click "Request Permission" to give this domain access to send notifications to your desktop.');
      }

      // conditionally delay the next reminder
      if (exp + 1 <= maxBackoffExp) {
        delayReminderExp(exp + 1, message);
      }
    }, delay(exp));
  };

  var delay = function(exp) {
    return (Math.pow(baseDelay, exp) + constantDelay) * 1000;
  };

  var resetReminder = function() {
    clearTimeout(reminderId);
  };

  return {
    resetReminder: resetReminder,
    delayReminder: delayReminderExp.bind(this, 1)
  };
}();

// initialize TTReminder
$(document).ready(function() {
  $(document).on('timer_start', TTReminder.resetReminder);
  $(document).on('timer_stop', function() {
    TTReminder.resetReminder();
    TTReminder.delayReminder('Did you forget to start your next tomato?');
  });
  $(document).on('new_tomato_form', function() {
    TTReminder.delayReminder('Did you forget to save your current tomato?');
  });
});
