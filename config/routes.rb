Rails.application.routes.draw do
  
  
  # routes for Active Admin
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  authenticate :admin_user do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  mount ActionCable.server => '/cable'
  # the page root
  root 'dashboards#index'  
  
  # resources :widgets,     only: [] do
  #   get '/:name', action: :show,    on: :collection
  #   put '/:name', action: :update,  on: :collection
  # end

  # routes for Devise and Omniauth
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  # routes for the API's
  namespace :api, defaults: {format: :json} do
    mount TolSkitSessions::Engine => "/"
    mount TolSkitSessionsFacebook::Engine => "sessions/facebook"
    mount TolSkitSessionsTwitter::Engine => "sessions/twitter"
    mount TolSkitSessionsInstagram::Engine => "sessions/instagram"
    
    resources :users
    resources :admin_sessions, only: [:create]
    resources :admin_users, only: [:show]
    
    get "widget_data/:id", to: "widgets#widget_data", as: :get_widget_data
    post "test_suite/:auth_token", to: "widgets#jenkins_test_suite", as: :widget_test_suite
  end

  # routes for locale change
  get 'sessions/:locale', to: "sessions#switch", as: :sessions

  # route for User Sign Out
  devise_scope :user do
    get 'sign_out', to: 'devise/sessions#destroy', as: :signout
  end

  # routes for Omniauth
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  resources :dashboards do
    member do
      get :delete_dashboard
    end
    
    resources :widgets
  end
  
  resources :widgets do
    member do
      get :delete_widget
    end
  end
  
  get '/set_form/:type', to: "widgets#set_form", as: :set_form
  get '/save_layout/:id', to: 'dashboards#save_layout', as: :dashboard_save_layout
  
  # routes for Users
  resources :users do
    resources :dashboards
  end
  
  match '/verifications/:alert_id', to: "verifications#create", via: [:get, :post], as: :verify_alert
  get '/verifications/:alert_id/resend_verification', to: "verifications#resend_verification", as: :resend_verification_token
  
  post 'gg/bugs', to: 'api/slack/golf_genius_commands#bugs'
  get 'gg/bugs', to: 'api/slack/golf_genius_commands#bugs'

  post 'gg/hb', to: 'api/slack/golf_genius_commands#hb'
  get 'gg/hb', to: 'api/slack/golf_genius_commands#hb'

  post 'gg/stats', to: 'api/slack/golf_genius_commands#status'
  get 'gg/stats', to: 'api/slack/golf_genius_commands#status'

  post 'gg/ping', to: 'api/slack/golf_genius_commands#ping'
  get 'gg/ping', to: 'api/slack/golf_genius_commands#ping'

  post 'gg/help', to: 'api/slack/golf_genius_commands#help'
  get 'gg/help', to: 'api/slack/golf_genius_commands#help'
end
