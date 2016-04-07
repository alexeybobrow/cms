#= require ./contact_form/error_view

Anadea = @Anadea ||= {}

$ ->
  event_categories = {
    'contact_form': 'ContactUs',
    'codereview_form': 'CodeReview'
  }

  contact_form = $('.contact_form')

  redirect = (page) ->
    document.location = page

  contact_form.on 'ajax:success', (e, data) ->
    redirect(data.redirect_to)

  contact_form.on 'ajax:error', (e, xhr) ->
    errors = new Anadea.ErrorView(contact_form, xhr.responseJSON.errors)
    errors.render()
