Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cats#, only: [:new, :edit, :index, :show, :create]
  resources :cat_rental_requests
end
