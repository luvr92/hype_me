$( document ).ready(function() {
  setClass();
});





function setClass() {
  $('.all-the-events div:first').addClass("active-event");
};
function nextEvent() {
  $('.active-event').removeClass("active-event").next().addClass("active-event");
};

function previousEvent() {
  $('.active-event').removeClass("active-event").prev().addClass("active-event");
};
