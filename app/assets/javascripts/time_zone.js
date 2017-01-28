Date.prototype.stdTimezoneOffset = function() {
  var jan = new Date(this.getFullYear(), 0, 1);
  var jul = new Date(this.getFullYear(), 6, 1);
  return Math.max(jan.getTimezoneOffset(), jul.getTimezoneOffset());
}

$(document).ready(function() {
  if(!(Cookies.get('timezone'))) {
    Cookies.set('timezone', (new Date()).stdTimezoneOffset());
  }
});
