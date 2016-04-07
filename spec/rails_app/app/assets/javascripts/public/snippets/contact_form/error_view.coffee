@Anadea ||= {}

class @Anadea.ErrorView
  constructor: (@context, @attributes_with_errors) ->

  render: ->
    @clear_old_errors()
    @render_errors()

  clear_old_errors: ->
    $('.help-inline', @context).remove()
    $('.error', @context).removeClass('error')

  field_for: (attribute) ->
    $(".form-group", @context).filter("[class$='#{attribute}']")

  render_errors: ->
    _(@attributes_with_errors).each @render_error

  render_error: (errors, attribute) =>
    error_string = errors.join(', ')
    field = @field_for(attribute)
    error_tag = $('<span>').addClass('help-inline').text(error_string)
    field.find('.controls').append(error_tag)
    field.addClass('error')
