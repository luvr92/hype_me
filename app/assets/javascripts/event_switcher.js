$(document).ready(function() {
  $('#next-event-button').click(function() {
    nextEvent();
  });

  $('#prev-event-button').click(function() {
    previousEvent();
  });

});






function nextEvent() {
  console.log("next");
  $('.active-event').removeClass("active-event").addClass("non-active-event").next().removeClass("non-active-event").addClass("active-event");
};

function previousEvent() {
  $('.active-event').removeClass("active-event").addClass("non-active-event").prev().removeClass("non-active-event").addClass("active-event");
};
