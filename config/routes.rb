Rails.application.routes.draw do
  root to: "sessions#new"
  resources :users, except: [:index] do
    resources :subs, only: [:edit, :new]
  end

  resource :session, only: [:new, :create, :destroy]
  resources :subs, except: [:edit, :new] do
    resources :posts, only: [:new, :edit]
  end

  resources :posts, except: [:new, :edit] do
    resources :comments, only: [:new]
  end

  resources :comments, only: [:create]
end
