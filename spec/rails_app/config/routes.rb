RailsApp::Application.routes.draw do
  root to: 'cms/public/pages#show'

  get '/admin', to: redirect('/admin/pages'), as: :admin_root

  scope '/auth', module: :auth do
    get 'sign_in', to: 'sessions#new'
    post 'sign_in', to: 'sessions#create'
    get 'sign_out', to: 'sessions#destroy'
  end

  namespace :admin do
    resources :users do
      get 'delete', on: :member
    end
    resources :emails, only: [:index, :edit, :update]
    resources :employees do
      get 'retire', on: :member
      get 'hire', on: :member
    end
    resources :occupations do
      put 'position', on: :member
      put 'restore', on: :member
    end
  end

  scope module: :public do
    scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/, defaults: { locale: I18n.default_locale } do
      scope constraints: { format: 'html' } do
        resources :contacts, only: :create
      end
    end
  end

  mount Cms::Engine => '/', as: :cms

  get '*unmatched_route', :to => 'application#raise_not_found!'
end
