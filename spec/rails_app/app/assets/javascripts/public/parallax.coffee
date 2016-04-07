#= require stellar
#= require 'public/device'

do ($) ->
  $ ->
    unless Device.isTablet()
      $.stellar.positionProperty.position = {
        setTop: ($element, newTop, originalTop) ->
          shouldStop = newTop - originalTop < -380
          $element.css('margin-top', newTop) unless shouldStop
      }

      $ -> $.stellar(
        horizontalScrolling: false
        hideDistantElements: false
      )
