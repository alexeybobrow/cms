$ ->
  isTouchDevice = 'ontouchstart' of document.documentElement

  if isTouchDevice
    $('body').on 'movestart', (e) ->
      if ((e.distX > e.distY && e.distX < -e.distY) ||
          (e.distX < e.distY && e.distX > -e.distY))
        e.preventDefault()
