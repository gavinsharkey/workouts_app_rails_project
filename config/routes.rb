Rails.application.routes.draw do
  root 'application#home'
  devise_for :users, :controllers => {registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show]
end
