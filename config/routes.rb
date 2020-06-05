Rails.application.routes.draw do
  root 'welcome#home'

  devise_for :users, :controllers => {registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get '/login', to: 'devise/sessions#new'
    get '/signup', to: 'devise/registrations#new'
  end

  get '/workouts', to: 'workouts#index', as: :user_root

  resources :users, only: [:show] do
    resources :workouts, only: [:index, :new, :create]
  end

  resources :workouts, only: [:index, :show, :edit, :update, :destroy] do
    resources :user_saved_workouts, only: [:new, :create, :edit, :update, :destroy]
    resources :custom_exercises, only: [:create]
    resources :comments, only: [:create]
  end

  resources :exercises, only: [:show]
  
end
