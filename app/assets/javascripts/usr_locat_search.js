$(document).ready(function() {

  $('#locat-search-btn').click(function() {
    var query = $('input').val();
    $.ajax({
      type: "GET",
      url: "https://maps.googleapis.com/maps/api/geocode/json?address=" + query + "&key=AIzaSyCJWsMsY6lRxdekum1JAg4BDvao57elMw0",
      success: function(data) {
        $.getScript("/events?lat=" + data.results[0].geometry.location.lat + "&lng="+ data.results[0].geometry.location.lng);
      },
      error: function(jqXHR) {
        console.error(jqXHR.responseText);
      }
    });
  });
});
