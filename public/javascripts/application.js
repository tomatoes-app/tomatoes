var timerInterval;

function show(ids) {
  ids.forEach(function(id) {
    $("#"+id).show();
  });
}

function hide(ids) {
  ids.forEach(function(id) {
    $("#"+id).hide();
  });
}

function pad(number, length) {
    var str = '' + number;
    while (str.length < length) {
      str = '0' + str;
    }
    return str;
}

function secondsToString(seconds) {
  minutes = Math.floor(seconds/60);
  seconds = seconds - minutes*60;
  return pad(minutes, 2) + ":" + pad(seconds, 2);
}

function stateStart(timer) {
  console.log("stateStart");
  
  $("#timer").html(secondsToString(timer));
  
  show(["timer", "squash"]);
  hide(["start"]);
}

function stateCounting(timer) {
  console.log("stateCounting");
  
  $("#timer").html(secondsToString(timer));
}

function stateStop() {
  console.log("stateStop");
  
  hide(["timer", "squash"]);
  show(["start"]);
}

function stateNewForm() {
  console.log("stateNewForm");
  
  hide(["timer", "squash", "start"]);
  show(["new_tomato_form"]);
}

function start(mins) {
  console.log("start timer for " + mins + " mins");
  
  var timer = mins*60;
  stateStart(timer);
  
  timerInterval = setInterval(function() {
    timer--;
    stateCounting(timer);
    if(timer <= 0) {
      clearInterval(timerInterval);
      stateNewForm();
    }
  }, 1000);
}

function squash() {
  console.log("squash tomato");
  
  if(confirm("Sure?")) {
    clearInterval(timerInterval);
    stateStop();
  }
}

$(document).ready(function() {
  
});