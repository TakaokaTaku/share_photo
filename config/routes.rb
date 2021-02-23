Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/home',    to: 'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/terms',   to: 'static_pages#terms'
  get    '/contact', to: 'static_pages#contact'
  get    '/search',  to: 'static_pages#search'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users do
    member do
      get   :following, :followers, :liking
      get   'edit/password', to:'users#edit_password'
      patch 'edit/password', to:'users#update_password'
    end
  end

  resources :posts,             expect: [:edit, :update] do
    member do
      get   :likers
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]
  resources :favorites,           only: [:create, :destroy]
  resources :comments,            only: [:create, :destroy]
  resources :notices,             only: [:index]
end
