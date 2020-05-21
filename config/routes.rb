Rails.application.routes.draw do
  root 'application#home'

  devise_for :users, :controllers => {registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get '/login', to: 'devise/sessions#new'
  end
  devise_scope :user do
    get '/signup', to: 'devise/registrations#new'
  end

  resources :users, only: [:show] do
    resources :workouts, only: [:index, :new, :create]
  end

  resources :workouts, only: [:index, :show, :edit, :update, :destroy]
end
