class @UserMenu
  USER_URL = '/admin/session'

  getUser = ->
    $.getJSON(USER_URL, page: window.location.pathname)

  template = (data) -> """
    <div class="user-menu">
      <div>User: #{data.user.name}</div>
      <a class="user-menu__item" href="/admin/pages/#{data.page.id}">view</a>
      <a class="user-menu__item" href="/admin/pages/#{data.page.id}/edit/content">edit</a>
      <a class="user-menu__item" href="/admin/cache" data-method="delete" data-remote="true">clear cache</a>
    </div>
  """

  # public

  fetch: ->
    getUser().then (data) =>
      template(data) if data.page
