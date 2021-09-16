Rails.application.routes.draw do
  root 'homes#top'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :users, only: [:index, :show]

  resources :stores do
    resource :favorite, only: [:create, :destroy]
    resource :review, only: [:create, :edit, :update, :destroy]
  end

  resources :ranks, only: [:index]
  resources :spots, only: [:index]
end
