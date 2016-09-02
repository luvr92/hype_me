  // $(window).load(function() {
  //   // Animate loader off screen
  //   $(".se-pre-con").fadeOut("slow");;
  // });
  $('#hype-btn').on('click', function(event) {
    event.preventDefault();
    $('.se-pre-con').removeClass('hidden');
    setTimeout(event, 3000);
    document.getElementById('hype-btn').click();
  });

