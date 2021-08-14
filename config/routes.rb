Rails.application.routes.draw do
  get 'ranks/index'
  root 'homes#top'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }
  resources :users, only: [:index, :show]
  resources :stores do
    resource :favorite, only: [:create, :destroy]
    resources :reviews, only: [:create, :edit, :update, :destroy]
  end
end
