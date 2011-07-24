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

function stateStart(timer) {
  console.log("stateStart");
  
  $("#timer").html(timer);
  
  show(["timer", "squash"]);
  hide(["start"]);
}

function stateCounting(timer) {
  console.log("stateCounting");
  
  $("#timer").html(timer);
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
  
  clearInterval(timerInterval);
  stateStop();
}

$(document).ready(function() {
  
});