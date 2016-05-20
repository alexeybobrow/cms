Cms::Engine.routes.draw do
  root to: 'public/pages#show'

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

        resources :blog, only: :show
        resources :blog, only: :index, constraints: { format: 'rss' }
      end
    end

    get '/uploads/image_attachment/image/:id/:basename.:extension', to: 'attachments#download'

    constraints(format: 'html') do
      get '/*page', to: 'pages#show', as: 'page'
    end
  end

end
