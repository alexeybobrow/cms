$ ->
  $('[data-is-open=false]').each ->
    folder_name = $(this).data().folderName
    $("[data-parent-folder='#{folder_name}']").hide()

  $('[data-is-folder]').on 'click', (e) ->
    e.preventDefault()

    folder = $(this)
    folder_name = folder.data().folderName
    is_open = folder.data().isOpen

    if is_open
      $("[data-parent-folder^='#{folder_name}']").toggle(false)
    else
      $("[data-parent-folder='#{folder_name}']").toggle(true)

    folder.data('isOpen', !is_open)
