Rails.application.routes.draw do

  root 'main#index'
  resources :issues do
    member do
      post :like
    end
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :des_user_session
  end

  resources :users do
    member do
      get "/like" => 'votes#like_user'
      get "/unlike" => 'votes#unlike_user'
      get "/dislike" => 'votes#dislike_user'
    end
  end

  get 'agent_list' => 'users#agent_list'

  namespace :admin do
    resources :users
  end

end
