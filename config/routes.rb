Rails.application.routes.draw do
  get 'pets/index'
  resources :pets
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
