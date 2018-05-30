Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
    root to: 'pages#home'
    get :privacy, to: 'pages#privacy'
    get 'products/scan', to: 'products#scan', as: :scan_product

  resources :products, only: [:show, :new, :create, :edit, :update, :destroy]

end
