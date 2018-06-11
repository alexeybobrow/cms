require 'sidekiq/web'

Cms::Engine.routes.draw do
  root to: 'public/pages#show'

  constraints Cms::RoutingConstraints::CanAccessSidekiq.new do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :admin do
    resources :pages do
      resources :page_versions, only: :index do
        post 'reify', on: :member
      end

      resources :urls, only: :destroy

      member do
        get 'edit/:form_kind', action: :edit, as: :edit
        put :publish
        put :unpublish
        get :delete
      end
    end
    resources :image_attachments, only: [:create, :destroy] do
      post :restore
    end
    resources :fragments, except: :show do
      resources :fragment_versions, only: :index do
        post 'reify', on: :member
      end
    end
    resources :liquid_variables, except: :show
    resource :cache, only: :destroy
    resource :session, only: :show
  end

  get "/#{I18n.default_locale}", to: redirect('/')
  get "/#{I18n.default_locale}/*page", to: redirect(Cms::LocaleRedirector.new)

  scope module: :public do
    scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/, defaults: { locale: I18n.default_locale } do
      constraints(format: 'html') do
        constraints(Cms::RoutingConstraints::SetLocaleConstraint.new) do
          resources :blog, only: :index do
            get 'category/:tag', action: 'tag', on: :collection, as: :tag
            get 'author/:author', action: 'author', on: :collection, as: :author
          end
        end

        get '/blog/feed', constraints: { format: 'rss' }, as: :blog_feed, to: 'blog#feed'
        resources :blog, only: :show
      end
    end

    resource :csrf_token, only: :show
    resource :rates, only: :create

    constraints(format: :html) do
      get '/*page', to: 'pages#show', as: 'page'
    end
  end

end
