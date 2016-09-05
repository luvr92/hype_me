$('#hype-btn').click(function(e) {
  // On click on the Hype button

  // 1: Do not navigate (default behavior of link)
  e.preventDefault();

  // 3. In case the user accepts to be geolocalized
  var geoSuccess = function(position) {
    // 4. Display the gif
    $('.se-pre-con').removeClass('hidden');

    // 5. Wait for 3 seconds before...
    setTimeout(function() {
      // 6. Making the AJAX call to retrieve event list for (lat, lng)
      $.getScript("/events?lat=" + position.coords.latitude + "&lng="+ position.coords.longitude);
    }, 3000);
  };

  // 3 (bis). In case the user refuses to be geolocalized
  var geoError = function(error) {
    console.log('Error occurred. Error code: ' + error.code);
    // error.code can be:
    //   0: unknown error
    //   1: permission denied
    //   2: position unavailable (error response from location provider)
    //   3: timed out
  };

  // 2: Ask user to be geolocolaized
  navigator.geolocation.getCurrentPosition(geoSuccess, geoError, {
    enableHighAccuracy: true
  });
});
