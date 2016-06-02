Rails.application.routes.draw do

  get 'account/password/forgotten', to: 'password#forgotten'
  get 'account/password/reset/:reset_token', to: 'password#reset'

  namespace :api do
    namespace :v1 do
      # Singular routes
      put 'round', to: 'ladder_round#update'
      get 'notifications', to: 'notifications#index'
      put 'notifications', to: 'notifications#update'
      get 'search', to: 'search#index'

      # Devise routes
      devise_for :users, :skip => :all
      devise_scope :user do
          # Registrations
          match 'register' => 'registrations#create', :via => :post, :as => :user_registration
          match 'register' => 'registrations#update', :via => :put, :as => :edit_user_registration
          match 'register/reset' => 'registrations#init_reset', :via => :get
          match 'register/reset' => 'registrations#reset', :via => :post
          # Sessions
          match 'session' => 'sessions#create', :via => :post
          match 'session' => 'session#destroy', :via => :delete
          # Confirmations
          match 'confirmation' => 'confirmations#confirm', :via => :get, :as => :user_confirmation
          match 'confirmation/resend' => 'confirmations#resend', :via => :get
      end

      # Ressources routes
      resources :users, except: [:new, :edit, :create]

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
