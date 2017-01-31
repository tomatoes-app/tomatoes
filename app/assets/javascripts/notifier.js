// See:
//  * https://developer.mozilla.org/en-US/docs/Web/API/notification
//  * https://developer.chrome.com/apps/notifications
function Notifier() {}

// Returns "true" if this browser supports notifications.
Notifier.prototype.isSupported = function() {
  return "Notification" in window;
};

// Request permission for this page to send notifications.
Notifier.prototype.requestPermission = Notification.requestPermission;

Notifier.prototype.isPermissionGranted = function() {
  return this.getPermission() === "granted";
};

Notifier.prototype.getPermission = function() {
  return Notification.permission;
};

// Popup a notification with icon, title, and body. Returns false if
// permission was not granted.
Notifier.prototype.notify = function(icon, title, body) {
  if (this.isPermissionGranted()) {
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
