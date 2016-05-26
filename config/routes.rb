Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Singular routes
      put 'round', to: 'ladder_round#update'
      put 'notifications', to: 'notifications#update'

      # Devise routes
      devise_for :users, :skip => :all
      devise_scope :user do
          # Registrations
          match 'register' => 'registrations#create', :via => :post, :as => :user_registration
          # Sessions
          match 'session' => 'sessions#create', :via => :post
          match 'session' => 'session#destroy', :via => :delete
          # Confirmations
          match 'confirmation' => 'confirmations#confirm', :via => :get, :as => :user_confirmation
      end

      # Ressources routes
      resources :users, except: [:new, :edit, :create] do
        get :notifications
      end

      resources :projects, except: [:new, :edit] do
        get :followers
        post :follow
        post :unfollow
        collection do
          get :ladder
          get :released
        end
        resources :comments, only: [:create, :update, :destroy]
      end
    end
  end
end
