window.Device or= {}

helperFunctions = {
  isMobile: ->
    $('.is-mobile').is(':visible')

  isTablet: ->
    $('.is-tablet').is(':visible')
}

$.extend(window.Device, helperFunctions)
