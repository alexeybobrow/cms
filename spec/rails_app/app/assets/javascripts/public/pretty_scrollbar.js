//= require jscrollpane
//= require imagesloaded/imagesloaded.pkgd

(function($) {
  $(function() {
    var $pane = $('.scroll-pane');

    var initPane = function() {
      $pane.jScrollPane({
        horizontalDragMaxWidth: 150
      });

      $pane.each(function() {
        var startHeight = $('.jspContainer', $(this)).height();
        $('.jspContainer', $(this)).attr('data-start-height', startHeight);
      });
    }

    $(window).on('resize', initPane);
    $pane.imagesLoaded(initPane);

    $pane.not('[data-no-zoom]').on('click', 'img', function(e) {
      var slideMaxHeight,
        pane = $(e.delegateTarget),
        jspContainer = $('.jspContainer', pane),
        startHeight = jspContainer.attr('data-start-height'),
        currentHeight = jspContainer.height();
        api = pane.data('jsp'),
        images = $('img', pane);

      if((jspContainer.width() >= 1240) && (!pane.hasClass('zooming'))) {
        pane.addClass('zooming');

        slideMaxHeight = Math.max.apply(null, $.map($('img', pane), function(img) {
          return img.naturalHeight;
        }));

        jspContainer.animate({
          height: currentHeight < slideMaxHeight ? slideMaxHeight : startHeight
        }, function() {
          api.reinitialise();
          api.scrollToPercentX(images.index(e.target) / (images.size() - 1), true);
          pane.removeClass('zooming');
        });

        $('img', pane).each(function() {
          var img = $(this);

          if (pane.hasClass('zoomed')) {
            img.animate({ width: 450 });
          } else {
            img.animate({ width: 755 });
          }
        });

        pane.toggleClass('zoomed');
      }
    });
  });
})(jQuery);
