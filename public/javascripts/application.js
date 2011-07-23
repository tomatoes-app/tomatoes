var pomodoroDuration = 0.1; // min
var timer = pomodoroDuration*60;

$(document).ready(function() {
  $("#timer").html(pomodoroDuration*60);
  
  var i = setInterval(function() {
    $("#timer").html(--timer);
  }, 1000);
  
  setTimeout(function() {
    clearInterval(i);
    $("#timer").html(0);
  }, pomodoroDuration*60000);
});