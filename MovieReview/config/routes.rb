Rails.application.routes.draw do
  get 'users/index'

  get 'users/show'
devise_for :users, :controllers => { registrations: 'registrations' }


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  resources :movies do
  	resources :reviews
  end

  root 'movies#index'
end
