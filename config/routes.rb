Rails.application.routes.draw do
  root 'homes#top'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }
  resources :users, only: [:index, :show]
  resources :stores do
    resource :favorite, only: [:create, :destroy]
    resource :review, only: [:create, :edit, :update, :destroy]
  end
  resources :ranks, only: [:index]
end
