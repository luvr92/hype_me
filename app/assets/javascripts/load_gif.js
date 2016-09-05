  // $(window).load(function() {
  //   // Animate loader off screen
  //   $(".se-pre-con").fadeOut("slow");;
  // });
  $('#hype-btn').on('click', function(event) {
    event.preventDefault();
    var url = $(event.target).attr('href');
    $('.se-pre-con').removeClass('hidden');

    setTimeout(function(){
      window.location = url;
    }, 3000);

  });

