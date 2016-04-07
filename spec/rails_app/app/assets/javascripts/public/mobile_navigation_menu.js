$(function() {
  $('[data-nav-link]').on('click', function(e) {
    e.preventDefault();
    $('body').toggleClass('js-mobile-nav-active');
    $(this).toggleClass('sandwich_open');
  });
});
