Date.prototype.stdTimezoneOffset = function() {
  var jan = new Date(this.getFullYear(), 0, 1);
  var jul = new Date(this.getFullYear(), 6, 1);
  return Math.max(jan.getTimezoneOffset(), jul.getTimezoneOffset());
}

$(document).ready(function() {
  if(!($.cookie('timezone'))) {
    $.cookie('timezone', (new Date()).stdTimezoneOffset());
  }
});