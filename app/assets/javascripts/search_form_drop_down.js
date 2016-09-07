$(document).ready(function() {
  $(document).on("click", '#search-icon-to-drop', function() {
    if ($('#mobile-locat-search-form').hasClass('hidden')) {
    $('#mobile-locat-search-form').removeClass('hidden');
    } else {
    $('#mobile-locat-search-form').addClass('hidden');
    }
  });
});
