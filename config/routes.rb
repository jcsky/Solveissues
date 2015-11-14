Rails.application.routes.draw do

  root 'issues#index'
  resources :issues do
    resources :votes
    member do
      get "/support" => 'votes#support_issue'
      get "/unsupport" => 'votes#unsupport_issue'
    end
  end

  # get 'support' => 'votes#create', :as => :support
  # delete 'unsupport' => 'votes#destroy', :as => :unsupport

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    # get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :des_user_session
  end

  resources :users do
    member do
      get "/like" => 'votes#like_user'
      get "/unlike" => 'votes#unlike_user'
      get "/dislike" => 'votes#dislike_user'
    end
  end

  get 'agent_list' => 'votes#agent_list'

  # for API
  scope :path => '/api/v1/', :module => "api_v1", :defaults => { :format => :json }, :as => 'v1' do
    post "login" => "auth#login"
    post "logout" => "auth#logout"
    match 'login' => 'auth#options', via: :options
    resources :issues
    resources :users
    get "same_votes_reps" => "users#same"
  end

end
