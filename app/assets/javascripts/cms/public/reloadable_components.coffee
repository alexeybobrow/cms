#= require cms/public/reloadable_components/user_menu
#= require cms/public/reloadable_components/csrf_meta

class @ReloadableComponents
  @components: {}
  @registerHandler: (name, handler) -> @components[name] = handler

  init: ->
    $('[data-reloadable-component]').each (_, el) ->
      handlerName = el.dataset.reloadableComponent
      ComponentFetcher = ReloadableComponents.components[handlerName]
      (new ComponentFetcher()).fetch().then (text) ->
        $(el).replaceWith(text) if text


@ReloadableComponents.registerHandler('user-menu', UserMenu)
@ReloadableComponents.registerHandler('csrf-meta', CsrfMeta)
