#= require 'plugins/jquery/follow_to'
#= require jscrollpane
#= require imagesloaded/imagesloaded.pkgd

do ($) ->
  $ ->
    $('body').imagesLoaded ->
      hr_box = $('.hr-box')

      if hr_box.length
        hr_offset =  hr_box.height() + 130
        scroll_to = $('.office-life')

        hr_box.followTo(
          position: -> scroll_to.offset().top - hr_offset
          initialPosition: parseInt(hr_box.css('top'))
        )
