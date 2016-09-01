$('#hype-btn').click(function() {
  var geoOptions = {
    enableHighAccuracy: true
  }

  var geoSuccess = function(position) {
    window.location.href = "/events?lat=" + position.coords.latitude + "&lng="+ position.coords.longitude
  };
  var geoError = function(error) {
    console.log('Error occurred. Error code: ' + error.code);
    // error.code can be:
    //   0: unknown error
    //   1: permission denied
    //   2: position unavailable (error response from location provider)
    //   3: timed out
  };

  navigator.geolocation.getCurrentPosition(geoSuccess, geoError, geoOptions);
});
