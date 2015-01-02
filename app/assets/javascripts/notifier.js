// See:
//  * https://developer.mozilla.org/en-US/docs/Web/API/notification
//  * https://developer.chrome.com/apps/notifications
function Notifier() {}

// Returns "true" if this browser supports notifications.
Notifier.prototype.hasSupport = function() {
  return "Notification" in window;
};

// Request permission for this page to send notifications.
Notifier.prototype.requestPermission = function(callback) {
  Notification.requestPermission(function(permission) {
    callback(permission === "granted");
  });
};

Notifier.prototype.hasPermission = function() {
  return Notification.permission === "granted";
};

// Popup a notification with icon, title, and body. Returns false if
// permission was not granted.
Notifier.prototype.notify = function(icon, title, body) {
  if (this.hasPermission()) {
    console.log(icon, title, body);

    var notification = new Notification(body, { icon: icon, title: title });
    console.log(notification);

    notification.onclick = function() {
      window.focus();
      notification.close();
    };

    setTimeout(function() {
      notification.close();
    }, 10000);

    return true;
  }

  return false;
};

var NOTIFIER = new Notifier();
