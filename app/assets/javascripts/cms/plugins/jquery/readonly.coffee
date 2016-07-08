(($, window) ->
  checkReadonly = (source) ->
    fieldName = source.data().readonlyFor
    $("[data-readonly-if='#{fieldName}']").attr('readonly', () -> source.prop('checked'))
    $("[data-readonly-unless='#{fieldName}']").attr('readonly', () -> !source.prop('checked'))

  $.fn.extend readonly: ->
    @each ->
      $this = $(this)
      checkReadonly($this)
      $this.change -> checkReadonly($this)

) window.jQuery, window
