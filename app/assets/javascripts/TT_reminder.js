var TTReminder = function() {
  var reminderDelay = 20; // constant delay in seconds

  var delayReminder = function(message) {
    setTimeout(function() {
      // reminder notification
      NOTIFIER.notify(tomatoNotificationIcon, 'Tomatoes', message, true);
    }, reminderDelay * 1000);
  };

  return {
    delayReminder: delayReminder
  };
}();

// initialize TTReminder
$(document).ready(function() {
  $(document).on('timer_stop', function() {
    TTReminder.delayReminder('Did you forget to start your next tomato?');
  });
  $(document).on('new_tomato_form', function() {
    TTReminder.delayReminder('Did you forget to save your current tomato?');
  });
});
