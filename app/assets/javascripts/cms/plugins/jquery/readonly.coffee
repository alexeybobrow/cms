(($, window) ->
  checkReadonly = (source) ->
    fieldName = source.data().readonlyFor
    $("[data-readonly-if='#{fieldName}']").attr('readonly', () -> source.prop('checked') ? null : 'true')
    $("[data-readonly-unless='#{fieldName}']").attr('readonly', () -> source.prop('checked') ? 'true' : null)

  $.fn.extend readonly: () ->
    @each ->
      $this = $(this)
      checkReadonly($this)
      $this.change () -> checkReadonly($this)

) window.jQuery, window
