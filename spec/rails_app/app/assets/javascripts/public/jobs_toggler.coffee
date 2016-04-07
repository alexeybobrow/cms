$ ->
  $('> li', '.job').on 'click', (e) -> $(this).toggleClass('active')
  $('.job-details', '.job').on 'click', (e) -> e.stopPropagation()
