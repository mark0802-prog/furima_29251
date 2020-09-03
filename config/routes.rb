Rails.application.routes.draw do
  get 'cards/index'
  root 'items#index'
  devise_for :users, controllers: {registrations: 'users/registrations'} do 
    resources :cards, only: [:index, :create]
  end
  resources :items do
    resources :orders, only: [:index, :create]
  end
end
