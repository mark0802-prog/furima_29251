Rails.application.routes.draw do
  root 'items#index'
  devise_for :users, controllers: {registrations: 'users/registrations'}
  resources :items do
    resources :orders, only: [:index, :create]
  end
  resources :cards, only: [:index, :create]
end
