function Notifier() {}

// Returns "true" if this browser supports notifications.
Notifier.prototype.HasSupport = function() {
  return window.webkitNotifications ? true : false;
}

// Request permission for this page to send notifications. If allowed,
// calls function "cb" with true.
Notifier.prototype.RequestPermission = function(cb) {
  window.webkitNotifications.requestPermission(function() {
    cb && cb(this.HasPermission());
  });
}

Notifier.prototype.HasPermission = function() {
  return window.webkitNotifications.checkPermission() == 0;
}

// Popup a notification with icon, title, and body. Returns false if
// permission was not granted.
Notifier.prototype.Notify = function(icon, title, body) {
  if (this.HasPermission()) {
    var popup = window.webkitNotifications.createNotification(icon, title, body);
    popup.show();

    return true;
  }

  return false;
}

var NOTIFIER = new Notifier();