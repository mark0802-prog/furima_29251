Rails.application.routes.draw do
  root 'items#index'
  devise_for :users, controllers: {registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks'}
  resources :items do
    resources :orders, only: [:index, :create]
  end
  resources :cards, only: [:index, :create, :edit, :update]
  resources :users, only: :new
end
