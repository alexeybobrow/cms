$ ->
  $("[data-sortable]").sortable(
    placeholder: "ui-state-highlight"
    stop: (e, ui) ->
      $.ajax(
        url: "/admin/occupations/#{ui.item.data('id')}/position"
        method: 'PUT'
        data: { position: ui.item.index() }
      )
  )
  $("[data-sortable]").disableSelection()
