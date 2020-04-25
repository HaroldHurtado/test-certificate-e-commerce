Rails.application.routes.draw do
  #resources :preferences
  #resources :order_items
  resources :orders
  #resources :items
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post 'order_success', to: 'orders#order_success', as: 'order_success'
  get 'order_pending/:order_id', to: 'orders#order_pending', as: 'order_pending'
  get 'order_failure/:order_id', to: 'orders#order_failure', as: 'order_failure'
  post 'order_notification', to: 'orders#order_notification', as: 'order_notification'

  root 'orders#index'
end
