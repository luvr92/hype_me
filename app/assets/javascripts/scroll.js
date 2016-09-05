$(document).on('click', '.js-scroll', function(e) {
  $(window).scrollTo($($(e.target).data('target')), 300);
  e.preventDefault();
});

