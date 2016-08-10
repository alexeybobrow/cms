class @CsrfMeta
  TOKEN_URL = '/csrf_token'

  getToken = -> $.getJSON(TOKEN_URL)

  template = (data) -> """
    <meta name="csrf-token" content="#{data.token}">
  """

  # public

  fetch: ->
    getToken().then (data) => template(data)
