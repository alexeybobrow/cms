$ ->
  header = $('.site-header .inner')
  minHeight = 50
  initialHeight = header.height()

  $(@).on 'scroll', (e) ->
    scrollTop = $(@).scrollTop()
    height = initialHeight - scrollTop
    isSticky = minHeight > height

    if isSticky
      header.height(minHeight)
      header.css('margin-top', 0)
      $('.site-header').addClass('active')
    else
      header.height(height)
      header.css('margin-top', scrollTop)
      $('.site-header').removeClass('active')
