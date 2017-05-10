Rails.application.routes.draw do
  get 'store/index'

  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # definiamo store#index come la root del sito web
  root 'store#index', as: 'store'
  #
end
