Rails.application.routes.draw do
  scope :monitoring do
    require 'sidekiq/web'
    mount Sidekiq::Web, at: '/jobs'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

  devise_for :users

  resources :dashboard, only: :index
  root to: 'dashboard#index'
  resources :users, only: :index do
    member do
      get :edit_profile
      post :update_profile
    end
  end

  authenticated :user do
    namespace :admin_panel do
      root to: "members#index"

      resources :members, only: %i[index show destroy]
      resources :events do
        member do
          get :export_rsvp
        end
      end
      resources :posts, only: %i[destroy]
      resources :reports, only: %i[index destroy] do
        member do
          get :post_report
          get :member_report
          get :close_reports
        end
      end
      resources :colleges, only: %i[index new create edit update destroy]
    end
  end

  %w(admin instructor student).each do |user_type|
    resources user_type.pluralize.to_sym, controller: "users", type: user_type.camelize, only: :index
  end

  get 'terms_and_conditions', to: 'public#terms_and_conditions', as: 'terms_and_conditions'

  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  devise_for :members, controllers: { confirmations: 'members/confirmations', passwords: 'members/passwords' }, skip: [:sessions, :registrations]
  resources :members, only: [:index,:show,:destroy] do
    member do
      get :password_change_success
    end

    collection do
      get :confirm_notice
    end
  end

  namespace :api do
    namespace :v1 do
      devise_for(
        :members,
        controllers: { sessions: 'api/v1/devise/sessions', registrations: 'api/v1/devise/registrations' },
        path_names: { sign_in: :login },
        defaults: { format: :json },
        skip: [:confirmations, :passwords]
      )

      resources :accounts, only: %i[] do
        collection do
          get :resend_confirmation
          post :reset_password_link
          get :confirmation_status
          post :change_password
          get :suggestions
        end
      end

      resources :skills, only: %i[index]
      resource :onboarding, only: %i[create]
      resources :members, only: %i[index] do
        get :follow
        get :unfollow

        collection do
          post :bulk_follow
          get :followers_list
          delete :logout
        end

        member do
          get :profile
        end
      end

      resources :posts, only: %i[index create show destroy] do
        resources :comments, only: %i[index create destroy]
        resource :likes, only: %i[create destroy]
        resource :shares, only: %i[create destroy]
      end

      resources :block_members, only: %i[create] do
        delete :destroy
      end
      resources :member_reports, only: %i[create] do
        delete :destroy
      end
      resources :post_reports, only: %i[create] do
        delete :destroy
      end
      resources :groups, only: %i[index create update show destroy]
      resources :feeds, only: %i[index]
      resources :groups, only: %i[create update show destroy] do
        member do
          post :leave_group
          get '/read_conversation/:member_id', to: 'groups#read_conversation', as: :read_conversation
        end
      end

      resources :notifications, only: %i[index] do
        member do
          get :read
        end
      end
      resources :rsvps, only: %i[create destroy], param: :event_id
      resources :events, only: %i[index show]
      resources :devices, only: %i[create]
      resources :colleges, only: %i[index]
    end
  end

  post :talkjs, to: 'webhooks#talkjs'
end
