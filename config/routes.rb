Rails.application.routes.draw do
  get 'static_pages/inventario'

  get 'static_pages/store'

  resources :publishers
  resources :lpublishers
  resources :line_items
  resources :carts
  get 'store/index'

  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # definiamo store#index come la root del sito web
  root 'store#index', as: 'store'
  #
end
