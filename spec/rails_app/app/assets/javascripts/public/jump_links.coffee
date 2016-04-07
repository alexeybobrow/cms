#= require jquery.scrollTo
#= require jquery.localScroll

do ($) -> $ ->
  $('header').localScroll(offset: -61)
  $('.freecodereview').localScroll()
