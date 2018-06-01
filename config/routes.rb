Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
    root to: 'pages#home'
    get :privacy, to: 'pages#privacy'
    get 'products/scan', to: 'products#scan', as: :scan_product
    get 'products/:id', to: 'products#game_new', as: :bin_game_new
    post 'products/:id', to: 'products#game', as: :bin_game

  resources :products, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :scans, only: [:index]

end
