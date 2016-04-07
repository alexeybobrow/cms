$.fn.followTo = function(options) {
  options = $.extend({
    initialPosition: 0
  }, options);

  return this.each(function() {
    var pos = options.position,
      $this = $(this),
      $window = $(window);

    $window.on('scroll', function (e) {
      var newPosition = typeof pos === 'function' ? pos() : pos;

      if ($window.scrollTop() > newPosition - options.initialPosition) {
        $this.css({
          position: 'absolute',
          top: newPosition
        });
      } else {
        $this.css({
          position: 'fixed',
          top: options.initialPosition
        });
      }
    });
  });
}
