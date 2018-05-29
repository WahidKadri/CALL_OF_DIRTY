Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
    get 'products/scan', to: 'products#scan', as: :scan_product

  resources :products, only: [:show, :new, :create, :edit, :update, :destroy]

end
