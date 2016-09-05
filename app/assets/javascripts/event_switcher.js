$('#next-event-button').click(function() {
  nextEvent();
});

$('#prev-event-button').click(function() {
  previousEvent();
});





function nextEvent() {
  $('.active-event').removeClass("active-event").addClass("non-active-event").next().removeClass("non-active-event").addClass("active-event");
};

function previousEvent() {
  $('.active-event').removeClass("active-event").addClass("non-active-event").next().removeClass("non-active-event").addClass("active-event");
};
