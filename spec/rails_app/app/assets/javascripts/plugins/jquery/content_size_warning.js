$.fn.contentSizeWarning = function() {
  function getLabel(field) {
    return $('label[for="'+$(field).attr('id')+'"]').text();
  };

  return this.each(function() {
    $(this).on('submit', function(e) {
      var warn = [];

      $('[data-warn-max-size]').each(function() {
        var el = $(this);
        var length = el.val().length;
        var maxSize = el.data().warnMaxSize;

        if (length > maxSize) {
          warn.push([
            getLabel(el) + '\'s maximum length should be less then '+ maxSize+'.',
            'Now it is ' + length + '.',
            'Do you still want to continue?'
          ].join("\n"));
        }
      });

      if (warn.length > 0) {
        return confirm(warn.join("\n"));
      }
    });
  });
}
