class @UserMenu
  USER_URL: '/admin/session'

  getUser: ->
    $.getJSON(@USER_URL, page: window.location.pathname)

  getMenu: ->
    @getUser().then (data) =>
      @template(data) if data.page

  template: (data) -> """
    <div class="user-menu">
      <div class="user-menu--item">User: #{data.user.name}</div>
      <div class="user-menu--item">
      <a href="/admin/pages/#{data.page.id}">view</a>
      /
      <a href="/admin/pages/#{data.page.id}/edit/content">edit</a>
      /
      <a href="/admin/cache" data-method="delete" data-remote="true">clear cache</a>
      </div>
    </div>
  """
